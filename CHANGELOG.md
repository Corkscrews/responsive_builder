## 0.9.0

### Bug Fixes

- **Fix landscape width/height swap** — `ResponsiveAppUtil.setScreenSize` no longer swaps width and height in landscape. `screenWidth`/`sw` and `screenHeight`/`sh` now correctly reflect the actual visible dimensions regardless of orientation.
- **Fix `ScrollController` disposal** — `ScrollTransformView` now properly disposes its `ScrollController`, preventing memory leaks.
- **Fix `ResponsiveAppUtil` defaults** — `width`, `height` now default to `0` and `preferDesktop` to `false` instead of using `late` variables that would crash if accessed before `ResponsiveApp` is built.
- **Fix double assignment in `getDeviceType`** — Simplified redundant `isWebOrDesktop = isWebOrDesktop ??= _isWebOrDesktop` to `isWebOrDesktop ??= _isWebOrDesktop`.

### Improvements

- **Remove `provider` dependency** — Replaced with a built-in `ScrollControllerScope` (an `InheritedNotifier`) to inject `ScrollController` into scroll transform widgets. The package now has zero third-party dependencies beyond Flutter and `universal_platform`.
- **Add breakpoint validation** — `ScreenBreakpoints` and `RefinedBreakpoints` constructors now assert correct ordering (`small < normal < large`) in debug mode. Invalid breakpoints produce a clear assertion error instead of silently returning wrong device types.
- **Add value equality** — `SizingInformation`, `ScreenBreakpoints`, and `RefinedBreakpoints` now implement `operator ==` and `hashCode` for value-based comparison.
- **Make `SizingInformation` const** — The constructor is now `const`, enabling compile-time constant instances.
- **Modernize constructors** — All widget constructors updated to `super.key` syntax; removed redundant `= null` parameter defaults.
- **Split `widget_builders.dart`** — Refactored into separate files (`typedefs.dart`, `responsive_builder.dart`, `orientation_layout_builder.dart`, `screen_type_layout.dart`, `refined_layout_builder.dart`). The original file is now a barrel export for backward compatibility.
- **Improve test coverage** — Expanded from 84 to 145 tests, covering boundary values, edge cases, fallback chains, disposal, and breakpoint validation.
- **Rewrite README** — Added table of contents, API reference tables, documented all widgets (including `RefinedLayoutBuilder` and scroll transforms), default breakpoint values, and refined breakpoint configuration.

## 0.8.9

 - Make `ScreenBreakpoints.normal` mandatory (small/normal/large) and improve device detection (watch/phone/tablet/desktop).

## 0.8.7

 - Similar to 0.8.6 with changes to the `README.md`.

## 0.8.6

 - Fix support to `WASM`.
 - Apply lint fixes and better documentation.

## 0.8.5

 - Similar to 0.8.5 with changes to the `README.md`.

## 0.8.4

 - Make `WidgetBuilder` and `WidgetBuilder2` values private.

## 0.8.3

 - Add `ScreenTypeLayout.builder2` that includes `SizingInformation`.
 - Adds comparison operators to DeviceScreenType and RefinedSize, for convenience. (https://github.com/FilledStacks/responsive_builder/pull/55)
 - Code coverage reached 100%.
 - Replace `import 'package:flutter/material.dart';` with `import 'package:flutter/widgets.dart';`.

## 0.8.2

 - Add `WASM` support (https://github.com/FilledStacks/responsive_builder/pull/65)
 - Reduced unnecessary rebuilds by using `MediaQuery` as `InheritedModel` (https://github.com/FilledStacks/responsive_builder/pull/54)
 - Fixing code sample (https://github.com/FilledStacks/responsive_builder/pull/33)

## 0.8.1

 - Correct `README.md` configuration steps.
 - Remove `example/test` folder.

## 0.8.0

 - Replace `desktop` and `tablet` with `large` and `watch` with `small`. Necessary to handle desktop and tablet sizes correctly based on its platform.
 - Add more unit tests (Coverage 98.6%).
 - Add unit test CI.

## 0.7.1

- Fixes [#53](https://github.com/FilledStacks/responsive_builder/issues/53)

## 0.7.0

- Fixes #50

## 0.6.4

- Fixes #48

## 0.6.3

- Fixes bug with preferDesktop and `getValueForScreenType`

## 0.6.2

- Fixes bug with preferDesktop where it always returns desktop UI even if there is a mobile UI.

## 0.6.1

- Adds `preferDesktop` to `ResponsiveApp` which tells the builders that if there's no layout supplied for the current size prefer the desktop over the mobileLayout. Default value is `false` to maintain mobile first behaviour.

## 0.6.0

### New Feature
Adds responsive sizing by using the `ResponsiveApp` widget at the highest level which allows:
- Using `20.screenHeight` / `number.screenHeight` shorthand to get the percentage of the Screen Height
- The same exists for the `screenWidth`
- There are also shorthand extensions for both. `screenHeight` => `sh` and `screenWidth` => `sw`

## 0.5.1

- Adds checks to ensure desktop returns as Flutter web

## 0.5.0+1

- Adds banner to readme

## 0.5.0

### New Feature
Adds the `ScrollTransform` functionality which allows you to more easily create scroll effects based on the scrolling position.

## 0.4.3

- Added small size for getValueForRefinedSize
- Adds funding link to coffee

## 0.4.2

- Added optional override property in orientation builder

## 0.4.0-nullsafety.1

- Adds null safety and correct small refined sizing

## 0.3.0

- Adds the refined sizing functionality

## 0.2.0+2

- Added `getValueForScreenType` functionality to the readme

## 0.2.0+1
- export the sizing config which I forgot to do first time.

## 0.2.0

- Adds responsive sizing config for global breakpoint setting

## 0.1.9

- Reverted the change for returning the mobile layout when break points doesn't define any.

## 0.1.8+1

- readme updates

## 0.1.8

- Changed enum naming to lowerCamelCase to follow convention
- Add a return for mobile when no breakpoints match

## 0.1.7

- Made 600 inclusive for tablet devices and 900 inclusive for desktop

## 0.1.6

- Added ScreenTypeValue builder to allow us to return different values depending on the screen type

## 0.1.4+1

Changelog styling updates

## 0.1.4

- Added optional screen break points definition to pass in to the ResponsiveBuilder or the ScreenLayoutView.

## 0.1.3

- Added shorthand bool properties to sizing information to check which device screen type is currently being show.

## 0.1.2

- Updated screen type calculation to account for being on the Web. Width was swapping with the height when it got too wide so we're checking for web explicitly and using the width of the window.

## 0.1.1

- Update the ScreenTypeLayout widget to use an incremental layout approach. If the desktop isn't supplied and we're in desktop mode we check if there's a tablet layout and show that, otherwise we show the mobile layout.

## 0.1.0

- Added initial widgets required for a clean responsive UI architecture.
