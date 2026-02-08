# Bugs and Issues Report

**Package**: responsive_builder2 v0.8.8  
**Date**: 2026-02-08  
**Status**: All 117 tests passing (may mask issues below)

### Breaking Change Legend

| Tag | Meaning |
|-----|---------|
| **NON-BREAKING** | Fix is purely additive or internal; no consumer code changes needed |
| **BEHAVIORAL** | Existing behavior changes; consumers relying on the old (buggy) behavior may be affected |
| **API-BREAKING** | Public API signature changes; consumer code must be updated to compile |

---

## Critical Severity

### BUG-001: Missing `device_width_web.dart` — Web/WASM builds will fail

**File**: `lib/src/helpers/helpers.dart:8-9`  
**Type**: Build-breaking on web targets

The conditional import references a file that does not exist:

```dart
import 'device_width.dart' if (dart.library.js_interop) 'device_width_web.dart'
    as width;
```

Only `lib/src/helpers/device_width.dart` exists in the project. There is no
`device_width_web.dart` anywhere in the repository. When compiling for web
(where `dart.library.js_interop` is true), Dart will attempt to resolve
`device_width_web.dart` and fail with a compilation error.

**Impact**: The package cannot be compiled for web or WASM targets despite the
README claiming WASM support.

**Fix**: Create `lib/src/helpers/device_width_web.dart` with a web-specific
implementation, or remove the conditional import if the behavior is identical
across platforms.

**Breaking Change**: **NON-BREAKING** — Adding the missing file is purely
additive. If the conditional import is removed instead, it is also non-breaking
since the existing `device_width.dart` would be used on all platforms.

---

### BUG-002: `ScreenTypeLayout` can return null Widget, causing runtime crash

**File**: `lib/src/widget_builders.dart:236-238, 243-296`  
**Type**: Runtime null-pointer crash

The `build()` method force-unwraps the return value of both handler methods:

```dart
return _usingBuilder2()
    ? _handleWidgetBuilder2(context, sizingInformation)!  // force-unwrap
    : _handleWidgetBuilder(context, sizingInformation)!;  // force-unwrap
```

Both `_handleWidgetBuilder` and `_handleWidgetBuilder2` return `Widget?` and can
return `null` in several scenarios:

- **`_handleWidgetBuilder`** (line 267): Returns `_mobile?.call(context)` — if
  `_mobile` is null, returns null.
- **`_handleWidgetBuilder2`** (line 295): Returns
  `_phone2?.call(context, sizingInformation)` — if `_phone2` is null, returns
  null.

**Crash scenario**: Use `ScreenTypeLayout.builder(desktop: ...)` without
providing a `mobile` builder, on a watch-sized screen. The assertion in the
constructor only checks that mobile OR desktop is provided, so providing only
desktop is valid — but on a watch screen, neither desktop, tablet, nor mobile
matches, and `_mobile` is null, so `null` is returned and force-unwrapped.

Similarly, `_handleWidgetBuilder` with `preferDesktop = true` calls
`_mobile!(context)` (line 246) without checking null when `_desktop` is null —
this will crash if only `_mobile` was not provided.

**Fix**: Change both methods to return `Widget` (non-nullable). Add fallback
logic: always return the first available builder as a last resort, or throw a
descriptive error.

**Breaking Change**: **NON-BREAKING** — The methods are private. The fix
changes internal logic only. Code paths that previously crashed will now render
a fallback widget instead. No consumer API changes needed.

---

### BUG-003: `preferDesktop` causes null crash in `_handleWidgetBuilder`

**File**: `lib/src/widget_builders.dart:245-246`  
**Type**: Runtime crash

```dart
if (ResponsiveAppUtil.preferDesktop) {
  return _desktop?.call(context) ?? _mobile!(context);  // _mobile can be null
}
```

When `preferDesktop` is true and `_desktop` is null, the code falls back to
`_mobile!(context)`. But `_mobile` can be null when using
`ScreenTypeLayout.builder(desktop: ...)` without a mobile builder. The `!`
force-unwrap will throw `Null check operator used on a null value`.

The same issue exists in `_handleWidgetBuilder2` (line 273-274):
```dart
return _desktop2?.call(context, sizingInformation) ??
    _phone2!(context, sizingInformation);  // _phone2 can be null
```

**Fix**: Use safe calls with proper fallback chains.

**Breaking Change**: **NON-BREAKING** — Same as BUG-002. Internal fix that
turns a crash into a graceful fallback. No public API changes.

---

## High Severity

### BUG-004: `ResponsiveAppUtil` late variables crash before initialization

**File**: `lib/src/responsive_wrapper.dart:77-80`  
**Type**: Runtime crash (`LateInitializationError`)

```dart
static late double height;
static late double width;
```

If any code uses `screenHeight`, `screenWidth`, `sh`, or `sw` extensions before
`ResponsiveApp` widget is built (or if `ResponsiveApp` is not used at all),
accessing these throws a `LateInitializationError`.

There is no guard, default value, or helpful error message.

**Fix**: Initialize with default values (`static double height = 0;
static double width = 0;`), or use a nullable type with a descriptive assertion.

**Breaking Change**: **BEHAVIORAL** — If using default `0` values: code that
previously crashed with `LateInitializationError` will now silently return `0`
for `screenWidth`/`screenHeight` before `ResponsiveApp` builds. This is safer
but could mask initialization ordering bugs in consumer code. If using a
nullable type (`double?`): **API-BREAKING** — consumers accessing `width`/
`height` directly would need null checks.

---

### BUG-005: `setCustomBreakpoints(null)` does not reset refined breakpoints

**File**: `lib/src/responsive_sizing_config.dart:84-90`  
**Type**: Inconsistent state

```dart
void setCustomBreakpoints(
  ScreenBreakpoints? customBreakpoints, {
  RefinedBreakpoints? customRefinedBreakpoints,
}) {
  _customBreakPoints = customBreakpoints;
  if (customRefinedBreakpoints != null) {
    _customRefinedBreakpoints = customRefinedBreakpoints;
  }
}
```

When calling `setCustomBreakpoints(null)` to reset breakpoints (as done in test
`tearDown` blocks), `_customBreakPoints` is set to null, but
`_customRefinedBreakpoints` is never cleared because
`customRefinedBreakpoints` defaults to `null` and the `if` block is skipped.

This means once custom refined breakpoints are set, there is no way to reset
them back to defaults without restarting the app.

**Fix**: Always assign both values unconditionally:
```dart
_customBreakPoints = customBreakpoints;
_customRefinedBreakpoints = customRefinedBreakpoints;
```

**Breaking Change**: **BEHAVIORAL** — Consumers who set custom refined
breakpoints and later call `setCustomBreakpoints(null)` expecting refined
breakpoints to persist will see them reset to defaults. However, this is almost
certainly unintentional on their part (the current behavior is a bug, not a
feature). Very low risk of real-world impact.

---

### BUG-006: `ResponsiveAppUtil.setScreenSize` swaps width/height in landscape

**File**: `lib/src/responsive_wrapper.dart:92-101`  
**Type**: Counterintuitive behavior / potential semantic bug

```dart
if (orientation == Orientation.portrait) {
  width = constraints.maxWidth;
  height = constraints.maxHeight;
} else {
  width = constraints.maxHeight;   // shorter dimension
  height = constraints.maxWidth;   // longer dimension
}
```

In landscape mode, `constraints.maxWidth` is the longer dimension (landscape
width) and `constraints.maxHeight` is the shorter dimension. The code
**reverses** them, making `ResponsiveAppUtil.width` always represent the shorter
edge and `height` the longer edge.

This means `20.screenWidth` returns 20% of the **shorter** edge regardless of
orientation, which is semantically incorrect. Users expect `screenWidth` to
return a percentage of the actual visible width.

**Impact**: Any app using `screenWidth`/`sw` or `screenHeight`/`sh` extensions
in landscape mode gets wrong values.

**Fix**: Do not swap. Use `width = constraints.maxWidth` and
`height = constraints.maxHeight` in both orientations.

**Breaking Change**: **BEHAVIORAL** — Any consumer app that uses
`screenWidth`/`sw` or `screenHeight`/`sh` in landscape will see different
values after this fix. Apps that inadvertently depended on the swapped values
(e.g., using `screenWidth` knowing it returns the shorter dimension) will
break visually. This is a correctness fix but should be documented in a
changelog. Consider a **minor version bump** or feature flag.

---

### BUG-007: `ScrollTransformView` does not dispose `ScrollController`

**File**: `lib/src/scroll/scroll_transform_view.dart:44-59`  
**Type**: Memory/resource leak

```dart
class _ScrollTransformViewState extends State<ScrollTransformView> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) { ... }
  // Missing: @override void dispose() { scrollController.dispose(); super.dispose(); }
}
```

The `ScrollController` is created in the state but never disposed. This leaks
the controller and its attached scroll listeners, potentially causing
"ScrollController was used after being disposed" errors or memory leaks.

**Fix**: Add a `dispose()` override that calls `scrollController.dispose()`.

**Breaking Change**: **NON-BREAKING** — Adding `dispose()` is purely an
internal lifecycle improvement. No public API changes. Consumers will not
notice any difference except fewer memory leaks.

---

## Medium Severity

### BUG-008: `getRefinedSize` uses inconsistent width calculation

**File**: `lib/src/helpers/helpers.dart:80-81`  
**Type**: Logic inconsistency

```dart
double deviceWidth = isWebOrDesktop ? size.width : size.shortestSide;
```

This duplicates the logic of `device_width.dart` inline instead of using the
imported `width.deviceWidth()` function. If the `deviceWidth()` function is
updated for web (via the conditional import), `getRefinedSize` would still use
the hardcoded logic and produce inconsistent results.

Meanwhile, `getDeviceType` correctly uses `width.deviceWidth(size, isWebOrDesktop)`.

**Fix**: Use `width.deviceWidth(size, isWebOrDesktop)` consistently.

**Breaking Change**: **NON-BREAKING** on native platforms (behavior identical
today). **BEHAVIORAL** on web if a `device_width_web.dart` is later created
with different logic — at that point `getRefinedSize` would start using the
web-specific width, potentially changing refined size results on web. This is
the correct behavior and fixing a latent inconsistency.

---

### BUG-009: `WidgetBuilder` typedef shadows Flutter's built-in type

**File**: `lib/src/widget_builders.dart:8`  
**Type**: Name collision

```dart
typedef WidgetBuilder = Widget Function(BuildContext);
```

Flutter's `widgets.dart` already exports a `WidgetBuilder` typedef with the
same signature. This shadow can cause confusion and potential issues when both
the package and Flutter's type are in scope, especially when using the type
in external code.

**Fix**: Rename to `ResponsiveWidgetBuilder` or remove the typedef and use
Flutter's built-in `WidgetBuilder`.

**Breaking Change**: **API-BREAKING** — If renamed, any consumer code that
imports and uses `WidgetBuilder` from this package will fail to compile.
If removed (using Flutter's built-in), the signature is identical so code using
the type implicitly will continue to work, but explicit imports of
`WidgetBuilder` from this package will break. Either way, requires a **minor or
major version bump** depending on adoption.

---

### BUG-010: `getValueForScreenType` has redundant null check

**File**: `lib/src/helpers/helpers.dart:191`  
**Type**: Dead code / logic issue

```dart
if (deviceScreenType == DeviceScreenType.phone) {
  if (mobile != null) return mobile;  // `mobile` is required T, never null
}
```

The `mobile` parameter is `required T mobile` — it is non-nullable (assuming T
is non-nullable). The `if (mobile != null)` check is always true and misleading.
More importantly, if `T` is a nullable type, this check masks the fact that the
phone branch might not return a value, falling through to the final fallback.

**Fix**: Remove the redundant null check: `return mobile;`

**Breaking Change**: **NON-BREAKING** — Purely a code cleanup. The runtime
behavior is identical since the check was always true for non-nullable `T`.

---

### BUG-011: `getDeviceType` uses `??=` where `??` is sufficient

**File**: `lib/src/helpers/helpers.dart:31`  
**Type**: Minor code defect

```dart
isWebOrDesktop = isWebOrDesktop ??= _isWebOrDesktop;
```

The `??=` operator already assigns, so `isWebOrDesktop = isWebOrDesktop ??= x`
performs a double assignment. Should be simply:

```dart
isWebOrDesktop ??= _isWebOrDesktop;
```

**Breaking Change**: **NON-BREAKING** — Purely a code cleanup. Identical
runtime behavior.

---

## Low Severity

### BUG-012: No validation on `ScreenBreakpoints` values

**File**: `lib/src/sizing_information.dart:77-94`  
**Type**: Missing input validation

`ScreenBreakpoints` accepts any values without validating that
`small < normal < large`. Invalid breakpoints like
`ScreenBreakpoints(small: 1000, normal: 500, large: 200)` produce nonsensical
device type classifications with no error or warning.

**Fix**: Add assertions in the constructor:
```dart
assert(small < normal, 'small must be less than normal');
assert(normal < large, 'normal must be less than large');
```

**Breaking Change**: **BEHAVIORAL** (debug mode only) — Assertions only fire
in debug mode. Consumer code that passes invalid breakpoints (e.g.,
`small > large`) will now get an assertion error in debug builds instead of
silently producing wrong results. Release builds are unaffected. Very low risk
since invalid breakpoints are always a bug.

---

### BUG-013: `preferDesktop` global static state is not thread-safe

**File**: `lib/src/responsive_wrapper.dart:82-83`  
**Type**: Race condition / design flaw

`ResponsiveAppUtil.preferDesktop` is set during `ResponsiveApp.build()`. If
multiple `ResponsiveApp` widgets exist in the tree (e.g., in different routes or
overlays), the last one to build wins, affecting all `ScreenTypeLayout` widgets
globally.

**Fix**: Use `InheritedWidget` or `Provider` to scope `preferDesktop` to a
subtree instead of global state.

**Breaking Change**: **API-BREAKING** — Replacing `ResponsiveAppUtil` static
fields with an `InheritedWidget` changes how consumers access `preferDesktop`.
Any code directly reading/writing `ResponsiveAppUtil.preferDesktop` would need
updating. This is a significant refactor best suited for a **major version
bump**. A non-breaking intermediate step would be to keep the static API but
add an `InheritedWidget` alternative.

---

## Test Issues

### TEST-001: Misleading test descriptions with wrong inputs

**File**: `test/helpers_test.dart:84-103` and `test/helpers/helpers_test.dart`  
**Type**: Tests passing but not testing what they claim

Two tests have descriptions that do not match their actual assertions:

1. **Line 84-93**: Description says "should return mobile when width is 799"
   but the test expects `DeviceScreenType.tablet` and uses width 799 — which is
   indeed tablet range. The description is wrong.

2. **Line 95-103**: Description says "should return watch when width is 199"
   but the test uses `Size(799, 1000)` (width 799, not 199) and expects
   `DeviceScreenType.tablet`. Both the description and the test input are wrong.

**Impact**: These tests pass but do not validate the behavior described. The
actual watch and mobile edge cases for custom config are never tested.

---

### TEST-002: Duplicate test files

**Files**: `test/helpers_test.dart` and `test/helpers/helpers_test.dart`  
**Type**: Maintenance burden

These two files are near-identical copies of the same tests with minor
differences (the `helpers/` version adds deprecated ordinal assertions). Both
run in CI, inflating the test count (117 tests) and making maintenance harder.

**Fix**: Consolidate into a single file.

**Breaking Change**: **NON-BREAKING** — Test-only change. No impact on
consumers or the public API.
