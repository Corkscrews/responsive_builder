# Test Coverage Analysis

**Package**: responsive_builder2 v0.8.9  
**Date**: 2026-02-08  
**Total Tests**: 137 (all passing)  
**Test Files**: 9  
**Status**: All 7 actionable recommendations applied (1 skipped as low priority)

---

## Changes Applied

| # | Action | Status |
|---|--------|--------|
| 1 | **Delete duplicate test file** — Removed `test/helpers_test.dart` | DONE (earlier) |
| 2 | **Fix misleading test descriptions** — Fixed 2 mislabeled tests in `getDeviceType-Config set` | DONE |
| 3 | **Add crash-path tests** — `ScreenTypeLayout` with only desktop on watch/phone screens | DONE |
| 4 | **Add disposal tests** — `ScrollTransformView` controller disposal verification | DONE |
| 5 | **Add boundary tests** — Exact breakpoint values, zero-width, extreme dimensions, platform behavior | DONE |
| 6 | **Standardize state cleanup** — Added `tearDown` to all groups modifying singleton state | DONE |
| 7 | **Add direct tests for `device_width.dart`** — 10 tests covering all scenarios | DONE |
| 8 | **Consider golden tests** — Deferred (low priority, complex setup) | SKIPPED |

### Test Count Growth: 84 → 137 (53 new tests)

---

## Test File Inventory

| File | Tests | What it covers |
|------|-------|---------------|
| `device_screen_type_test.dart` | 3 | Enum ordinals and comparison operators |
| `sizing_information_test.dart` | 5 | Data classes, breakpoint constructors, toString |
| `responsive_sizing_config_test.dart` | 7 | Singleton, default/custom breakpoints, null reset behavior |
| `helpers/helpers_test.dart` | ~63 | getDeviceType, getRefinedSize, getValueForScreenType/RefinedSize, boundary/edge cases, fallback chains |
| `helpers/device_width_test.dart` | 10 | Direct device_width function tests (mobile, desktop, edge cases) |
| `widget_builders_test.dart` | ~43 | ResponsiveBuilder, OrientationLayoutBuilder, ScreenTypeLayout, RefinedLayoutBuilder, crash paths |
| `responsive_wrapper_test.dart` | 8 | Extensions, ResponsiveAppUtil, ResponsiveApp widget, default values |
| `scroll/scroll_transform_view_test.dart` | 3 | Scroll offset propagation, disposal, multiple children |
| `scroll/scroll_transform_item_test.dart` | 4 | Offset and scale transforms, null builders |

---

## Coverage Assessment by Component

### Well-Covered

#### `DeviceScreenType` and `RefinedSize` enums
- Ordinal values verified for all enum members (including deprecated)
- Comparison operators (`>`, `>=`, `<`, `<=`) tested
- Cross-references between deprecated and new values verified
- **Remaining gap**: No test for equality between `phone` and `mobile` (same
  ordinal but different enum values — `phone == mobile` is `false`)

#### `ScreenBreakpoints` and `RefinedBreakpoints`
- Default values verified
- Custom values verified
- `toString()` output checked
- **Remaining gap**: No test for invalid breakpoint ordering (e.g., small > large)

#### `getDeviceType`
- Default breakpoints: watch, phone, tablet, desktop ranges covered
- Custom breakpoints: all device types covered
- Global config: tested with overrides
- Global config + custom breakpoint interaction: tested
- **[NEW]** Exact boundary values tested (299, 300, 599, 600, 949, 950)
- **[NEW]** Edge cases tested (zero-width, very large, platform-specific width)
- **[FIXED]** Misleading test descriptions corrected
- **[FIXED]** Tests now actually verify the stated behavior (mobile, watch)

#### `getRefinedSize`
- Custom breakpoints: all refined sizes for mobile, tablet, desktop
- Default breakpoints: desktop and tablet ranges
- **[NEW]** Default mobile refined sizes (small, normal, large, extraLarge) tested
- **[NEW]** Default desktop "small" refined size tested
- **[NEW]** Watch refined size with default breakpoints tested

#### `getValueForScreenType` and `getValueForRefinedSize`
- All device types and refined sizes tested via widget tests
- Fallback behavior tested (e.g., extraLarge with no extraLarge value)
- **[NEW]** Complete fallback chains tested:
  - desktop → tablet → mobile
  - tablet → mobile
  - watch → mobile
  - extraLarge → large → normal
  - large → normal
  - small → normal

#### `device_width.dart`
- **[NEW]** Direct unit tests covering:
  - Web/desktop returns full width
  - Mobile returns shortestSide
  - Portrait and landscape on both platforms
  - Zero dimensions
  - Very large dimensions
  - Equal width and height

---

### Moderately Covered → Well-Covered

#### `ResponsiveBuilder`
- Basic builder invocation verified
- SizingInformation non-null verified
- **[NEW]** Custom breakpoints test verifying correct device type
- **[NEW]** screenSize matches MediaQuery size verification
- **Remaining gap**: No test for custom refinedBreakpoints
- **Remaining gap**: No test verifying localWidgetSize reflects actual constraints

#### `ScreenTypeLayout` (all constructors)
- `.builder()`: watch, mobile, tablet, desktop, preferDesktop tested
- `.builder2()`: watch, phone, tablet, desktop, preferDesktop tested
- Deprecated constructor: mobile, watch, desktop tested
- Fallback from desktop to tablet tested for `.builder2()`
- **[NEW]** Crash-path tests: desktop-only on desktop, phone, and watch screens
- **[NEW]** Crash-path tests for `.builder2()` on phone and watch screens

#### `OrientationLayoutBuilder`
- Portrait default behavior tested
- Landscape via MediaQuery tested
- Forced landscape mode tested
- **[NEW]** Forced portrait mode tested (portrait even in landscape orientation)
- **[NEW]** Landscape fallback to portrait tested (no landscape builder provided)

#### `ResponsiveApp` and Extensions
- `screenHeight` and `screenWidth` percentage calculations verified
- `sh` and `sw` aliases verified
- `setScreenSize` portrait and landscape verified
- `preferDesktop` setting verified
- **[NEW]** Default values test (width=0, height=0 before initialization)
- **[NEW]** preferDesktop default value test

#### `ResponsiveSizingConfig` Singleton
- Singleton identity verified
- Custom breakpoint set/get verified
- **[NEW]** `setCustomBreakpoints(null)` resets screen breakpoints to defaults
- **[NEW]** `setCustomBreakpoints(null)` does NOT reset refined breakpoints (BUG-005)
- **[FIXED]** All test groups now clean up singleton state via `tearDown`

---

### Moderately Covered (improved from Poorly Covered)

#### `ScrollTransformView`
- Offset propagation after drag verified
- **[NEW]** Disposal test: verifies controller disposes without errors
- **[NEW]** Multiple children with different transforms test
- **Remaining gap**: No test for rebuild behavior
- **Remaining gap**: No test for empty children list

#### `ScrollTransformItem`
- Offset/scale application after jumpTo verified
- **[NEW]** Null scaleBuilder test (only offsetBuilder)
- **[NEW]** Null offsetBuilder test (only scaleBuilder)
- **[NEW]** Both builders null test (defaults: scale=1.0, offset=Offset.zero)
- **Remaining gap**: No test for logOffset flag
- **Remaining gap**: No test for negative scroll offsets

#### `RefinedLayoutBuilder`
- Normal, extraLarge, large, small layouts tested
- Fallback from large to normal tested
- Fallback from extraLarge when no large tested
- **Remaining gap**: No test with custom `refinedBreakpoints`
- **Remaining gap**: No test with `isWebOrDesktop` parameter

---

## Test Quality Issues Status

### 1. Duplicate Test Files — **RESOLVED**
`test/helpers_test.dart` was deleted. `test/helpers/helpers_test.dart` is
the canonical file.

### 2. Misleading Test Descriptions — **RESOLVED**
Both tests in `getDeviceType-Config set` group were fixed:
- "should return mobile when width is 799" → now tests phone with width 400
- "should return watch when width is 199" → now uses Size(199, 1000) and
  expects watch

### 3. Missing Singleton State Cleanup — **RESOLVED**
Added `tearDown` to all groups that modify `ResponsiveSizingConfig.instance`:
- `getDeviceType-Config set` — now has `tearDown`
- `getRefinedSize - Custom break points -` — now has `tearDown`

### 4. Redundant `await await` in Test — **NOT PRESENT**
The double `await` was not found in the current codebase.

### 5. No Negative/Edge Case Tests — **PARTIALLY RESOLVED**
Added tests for:
- ✅ Zero-width screens (`Size(0, 0)`)
- ✅ Very large dimensions (`Size(100000, 100000)`)
- ✅ Exact boundary values
- ⬜ Negative dimensions (not applicable — `Size` uses positive doubles)
- ⬜ `double.infinity` in constraints
- ⬜ Rapid orientation changes
- ⬜ Widget hot reload scenarios

### 6. No Integration Tests — **UNCHANGED**
Golden/integration tests deferred as low priority.

---

## Updated Missing Test Coverage Summary

| Component | Previous Coverage | Updated Coverage | Key Improvements |
|-----------|------------------|-----------------|-----------------|
| `DeviceScreenType` | ~90% | ~90% | — |
| `SizingInformation` | ~85% | ~85% | — |
| `ScreenBreakpoints` | ~80% | ~80% | — |
| `RefinedBreakpoints` | ~85% | ~85% | — |
| `ResponsiveSizingConfig` | ~70% | ~90% | Null reset tests, cleanup |
| `getDeviceType` | ~80% | ~95% | Boundaries, edge cases, fix misleading tests |
| `getRefinedSize` | ~70% | ~90% | Default mobile/desktop/watch sizes |
| `getValueForScreenType` | ~75% | ~95% | Full fallback chains |
| `getValueForRefinedSize` | ~70% | ~90% | Full fallback chains |
| `ResponsiveBuilder` | ~40% | ~65% | Custom breakpoints, screenSize |
| `ScreenTypeLayout` | ~65% | ~85% | Crash paths (desktop-only) |
| `OrientationLayoutBuilder` | ~60% | ~90% | Portrait mode, landscape fallback |
| `RefinedLayoutBuilder` | ~55% | ~55% | — |
| `ResponsiveApp` | ~50% | ~70% | Default values |
| `ScrollTransformView` | ~20% | ~60% | Disposal, multiple children |
| `ScrollTransformItem` | ~25% | ~70% | Null builders |
| `device_width.dart` | ~30% | ~95% | Direct tests (10 scenarios) |

---

## Remaining Recommendations

| # | Action | Priority |
|---|--------|----------|
| 1 | Add `RefinedLayoutBuilder` tests with custom `refinedBreakpoints` and `isWebOrDesktop` | Medium |
| 2 | Add `ResponsiveBuilder` test verifying `localWidgetSize` reflects constraints | Low |
| 3 | Add `ScrollTransformItem` test for `logOffset` flag | Low |
| 4 | Consider golden/integration tests for visual regression | Low |
| 5 | Test `double.infinity` in constraints edge case | Low |
