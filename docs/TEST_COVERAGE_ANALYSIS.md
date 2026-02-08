# Test Coverage Analysis

**Package**: responsive_builder2 v0.8.8  
**Date**: 2026-02-08  
**Total Tests**: 117 (all passing)  
**Test Files**: 9

---

## Test File Inventory

| File | Tests | What it covers |
|------|-------|---------------|
| `device_screen_type_test.dart` | 3 | Enum ordinals and comparison operators |
| `sizing_information_test.dart` | 5 | Data classes, breakpoint constructors, toString |
| `responsive_sizing_config_test.dart` | 5 | Singleton, default/custom breakpoints |
| `helpers_test.dart` | ~25 | getDeviceType, getRefinedSize, getValueForScreenType/RefinedSize |
| `helpers/helpers_test.dart` | ~25 | Near-duplicate of above |
| `widget_builders_test.dart` | ~30 | ResponsiveBuilder, OrientationLayoutBuilder, ScreenTypeLayout, RefinedLayoutBuilder |
| `responsive_wrapper_test.dart` | 5 | Extensions, ResponsiveAppUtil, ResponsiveApp widget |
| `scroll/scroll_transform_view_test.dart` | 1 | Scroll offset propagation |
| `scroll/scroll_transform_item_test.dart` | 1 | Offset and scale transforms |

---

## Coverage Assessment by Component

### Well-Covered

#### `DeviceScreenType` and `RefinedSize` enums
- Ordinal values verified for all enum members (including deprecated)
- Comparison operators (`>`, `>=`, `<`, `<=`) tested
- Cross-references between deprecated and new values verified
- **Gap**: No test for equality between `phone` and `mobile` (same ordinal
  but different enum values — `phone == mobile` is `false` despite same ordinal)

#### `ScreenBreakpoints` and `RefinedBreakpoints`
- Default values verified
- Custom values verified
- `toString()` output checked
- **Gap**: No test for invalid breakpoint ordering (e.g., small > large)

#### `getDeviceType`
- Default breakpoints: watch, phone, tablet, desktop ranges covered
- Custom breakpoints: all device types covered
- Global config: tested with overrides
- Global config + custom breakpoint interaction: tested
- **Gap**: Exact boundary values (equal to breakpoint) not consistently tested
- **Gap**: No test for `getDeviceType` with `isWebOrDesktop = null` (default
  platform detection)

#### `getRefinedSize`
- Custom breakpoints: all refined sizes for mobile, tablet, desktop
- Default breakpoints: desktop and tablet ranges
- **Gap**: Default breakpoints for mobile refined sizes not tested
- **Gap**: Watch refined size only tested with custom breakpoints
- **Gap**: No test for default desktop "small" refined size

#### `getValueForScreenType` and `getValueForRefinedSize`
- All device types and refined sizes tested via widget tests
- Fallback behavior tested (e.g., extraLarge with no extraLarge value)
- **Gap**: Fallback chains not exhaustively tested (e.g., desktop -> tablet ->
  mobile cascade)

---

### Moderately Covered

#### `ResponsiveBuilder`
- Basic builder invocation verified
- SizingInformation non-null verified
- **Gap**: No test with custom breakpoints
- **Gap**: No test with custom refinedBreakpoints
- **Gap**: No test verifying localWidgetSize reflects actual constraints
- **Gap**: No test verifying screenSize matches MediaQuery

#### `ScreenTypeLayout` (all constructors)
- `.builder()`: watch, mobile, tablet, desktop, preferDesktop tested
- `.builder2()`: watch, phone, tablet, desktop, preferDesktop tested
- Deprecated constructor: mobile, watch, desktop tested
- Fallback from desktop to tablet tested for `.builder2()`
- **Gap**: No test for providing only desktop (no mobile) — potential crash
  path (see BUG-002)
- **Gap**: No test for tablet fallback in `.builder()` when only desktop and
  tablet provided
- **Gap**: Assertion test missing (assert that at least mobile or desktop is
  provided)

#### `OrientationLayoutBuilder`
- Portrait default behavior tested
- Landscape via MediaQuery tested
- Forced landscape mode tested
- **Gap**: Forced portrait mode not tested
- **Gap**: Landscape fallback to portrait (when no landscape builder) not
  tested

#### `RefinedLayoutBuilder`
- Normal, extraLarge, large, small layouts tested
- Fallback from large to normal tested
- Fallback from extraLarge when no large tested (falls through to normal)
- **Gap**: No test with custom `refinedBreakpoints`
- **Gap**: No test with `isWebOrDesktop` parameter

#### `ResponsiveApp` and Extensions
- `screenHeight` and `screenWidth` percentage calculations verified
- `sh` and `sw` aliases verified
- `setScreenSize` portrait and landscape verified
- `preferDesktop` setting verified
- **Gap**: No test for `LateInitializationError` when extensions used before
  `ResponsiveApp`
- **Gap**: No test verifying the swapped width/height in landscape is
  intentional or correct

---

### Poorly Covered

#### `ScrollTransformView`
- Single test: verifies offset propagation after drag
- **Gap**: No test for multiple children with different transforms
- **Gap**: No test for ScrollController disposal (memory leak)
- **Gap**: No test for rebuild behavior
- **Gap**: No test for empty children list

#### `ScrollTransformItem`
- Single test: verifies offset/scale application after jumpTo
- **Gap**: No test for null offsetBuilder (only scaleBuilder)
- **Gap**: No test for null scaleBuilder (only offsetBuilder)
- **Gap**: No test for both builders null
- **Gap**: No test for logOffset flag
- **Gap**: No test for negative scroll offsets

#### `device_width.dart`
- No direct unit test exists
- Indirectly tested through `getDeviceType` and `getRefinedSize`
- **Gap**: No test for `deviceWidth` function directly
- **Gap**: No test for web implementation (file doesn't even exist)

#### `ResponsiveSizingConfig` Singleton
- Singleton identity verified
- Custom breakpoint set/get verified
- **Gap**: No test verifying `setCustomBreakpoints(null)` does NOT reset
  refined breakpoints (this is BUG-005)
- **Gap**: No test for thread safety or concurrent access
- **Gap**: Reset in setUp is incomplete (doesn't reset refined breakpoints)

---

## Test Quality Issues

### 1. Duplicate Test Files
`test/helpers_test.dart` and `test/helpers/helpers_test.dart` are near-
identical. The `helpers/` version adds a few deprecated ordinal checks but
otherwise duplicates all tests. This inflates the test count and creates
maintenance burden.

**Recommendation**: Consolidate into `test/helpers_test.dart`.

### 2. Misleading Test Descriptions (2 instances)

**File**: `test/helpers_test.dart` lines 84-103

```dart
test('When global config tablet set to 550, should return mobile when width is 799', () {
  // ...
  final screenType = getDeviceType(Size(799, 1000), null, false);
  expect(screenType, DeviceScreenType.tablet);  // Says "mobile" but expects tablet
});

test('When global config watch set to 200, should return watch when width is 199', () {
  // ...
  final screenType = getDeviceType(Size(799, 1000), null, false);  // Uses 799, not 199
  expect(screenType, DeviceScreenType.tablet);  // Says "watch" but expects tablet
});
```

Both tests pass because the assertions match the actual behavior, but:
- The descriptions claim to test mobile/watch but actually test tablet
- The second test claims width 199 but actually uses 799
- The actual mobile and watch edge cases are never tested for global config

### 3. Missing Singleton State Cleanup

Several test groups modify `ResponsiveSizingConfig.instance` in their tests
but don't consistently clean up. Some groups use `setUp` to reset, some use
`tearDown`, and some don't reset at all. Since the singleton persists across
tests, this creates order-dependent test behavior.

**Files affected**: `helpers_test.dart`, `helpers/helpers_test.dart`

Groups with cleanup:
- `getRefinedSize -` has `setUp` to reset
- `getDeviceType-Config+Breakpoint` has `tearDown` to reset

Groups without cleanup:
- `getDeviceType-Config set` — modifies global config without tearDown
- `getRefinedSize - Custom break points -` — modifies global config without
  tearDown

### 4. Redundant `await await` in Test

**File**: `test/widget_builders_test.dart:161`

```dart
await await tester.pumpWidget(  // double await
```

This works because `await`-ing a non-Future returns the value, but it's a
typo that should be cleaned up.

### 5. No Negative/Edge Case Tests

The test suite lacks tests for:
- Zero-width screens (`Size(0, 0)`)
- Negative dimensions
- Very large dimensions (`Size(100000, 100000)`)
- `double.infinity` in constraints
- Rapid orientation changes
- Widget hot reload scenarios

### 6. No Integration Tests

There are no integration tests or golden tests verifying that the widgets
render correctly with actual Flutter widgets under different screen sizes.

---

## Missing Test Coverage Summary

| Component | Estimated Coverage | Priority Gaps |
|-----------|-------------------|---------------|
| `DeviceScreenType` | ~90% | phone/mobile equality edge case |
| `SizingInformation` | ~85% | Missing equality, isPhone for both phone and mobile |
| `ScreenBreakpoints` | ~80% | No validation tests |
| `RefinedBreakpoints` | ~85% | No validation tests |
| `ResponsiveSizingConfig` | ~70% | Incomplete reset, no refined breakpoint reset test |
| `getDeviceType` | ~80% | Boundary values, null isWebOrDesktop |
| `getRefinedSize` | ~70% | Default mobile sizes, watch, desktop small |
| `getValueForScreenType` | ~75% | Fallback chains |
| `getValueForRefinedSize` | ~70% | Fallback chains |
| `ResponsiveBuilder` | ~40% | Custom breakpoints, constraint verification |
| `ScreenTypeLayout` | ~65% | Null crash paths, desktop-only config |
| `OrientationLayoutBuilder` | ~60% | Portrait mode, landscape fallback |
| `RefinedLayoutBuilder` | ~55% | Custom breakpoints, isWebOrDesktop |
| `ResponsiveApp` | ~50% | Late init error, landscape swap |
| `ScrollTransformView` | ~20% | Disposal, multiple children, rebuild |
| `ScrollTransformItem` | ~25% | Null builders, logOffset, negative offsets |
| `device_width.dart` | ~30% | No direct tests |

---

## Recommendations

| # | Action | Breaking? | Notes |
|---|--------|-----------|-------|
| 1 | **Delete duplicate test file** — Remove `test/helpers/helpers_test.dart` or merge unique tests into `test/helpers_test.dart` | NON-BREAKING | Test-only change. No impact on consumers. |
| 2 | **Fix misleading test descriptions** — Correct the 2 mislabeled tests | NON-BREAKING | Test-only change. |
| 3 | **Add crash-path tests** — Test `ScreenTypeLayout` with only desktop provided, on watch/phone screens | NON-BREAKING | Test-only change. May expose BUG-002/003 failures that require source fixes. |
| 4 | **Add disposal tests** — Verify `ScrollTransformView` properly disposes its controller | NON-BREAKING | Test-only change. |
| 5 | **Add boundary tests** — Test exact breakpoint values, zero-width, extreme dimensions | NON-BREAKING | Test-only change. May reveal undocumented edge-case behaviors. |
| 6 | **Standardize state cleanup** — Use `setUp`/`tearDown` consistently in all test groups that modify singleton state | NON-BREAKING | Test-only change. |
| 7 | **Add direct tests for `device_width.dart`** — Test the function in isolation | NON-BREAKING | Test-only change. |
| 8 | **Consider golden tests** — Add visual regression tests for layout widgets | NON-BREAKING | Test-only change. |
