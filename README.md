![Responsive UI in Flutter Banner](https://github.com/Corkscrews/responsive_builder/blob/master/responsive_builder2.jpg)

# responsive_builder2

A Flutter package for building readable, responsive UIs across every screen size and device type. Forked from [FilledStacks' responsive_builder](https://www.youtube.com/playlist?list=PLQQBiNtFxeyJbOkeKBe_JG36gm1V2629H) and maintained by [Corkscrews](https://github.com/Corkscrews/responsive_builder).

Build separate layouts along two axes -- **Orientation** and **Screen Type** -- so you can provide distinct UIs for combinations like Phone-Portrait, Tablet-Landscape, Desktop, and Watch without littering your code with `MediaQuery` conditionals.

![Responsive Layout Preview](https://github.com/Corkscrews/responsive_builder/blob/master/responsive_example.gif)

## Table of Contents

- [Installation](#installation)
- [Quick Start](#quick-start)
- [Widgets](#widgets)
  - [ResponsiveBuilder](#responsivebuilder)
  - [ScreenTypeLayout](#screentypelayout)
  - [OrientationLayoutBuilder](#orientationlayoutbuilder)
  - [RefinedLayoutBuilder](#refinedlayoutbuilder)
- [Helper Functions](#helper-functions)
  - [getValueForScreenType](#getvalueforscreentype)
  - [getValueForRefinedSize](#getvalueforrefinedsize)
- [Responsive Sizing Extensions](#responsive-sizing-extensions)
- [Breakpoints](#breakpoints)
  - [Default Breakpoints](#default-breakpoints)
  - [Custom Breakpoints (per widget)](#custom-breakpoints-per-widget)
  - [Global Breakpoints](#global-breakpoints)
  - [Refined Breakpoints](#refined-breakpoints)
- [Scroll Transform Effects](#scroll-transform-effects)
- [API Reference](#api-reference)
- [Contributing](#contributing)

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  responsive_builder2: ^0.8.9
```

Then import it:

```dart
import 'package:responsive_builder2/responsive_builder2.dart';
```

## Quick Start

Wrap any part of your widget tree with `ScreenTypeLayout.builder` to render a different layout per device type:

```dart
ScreenTypeLayout.builder(
  phone: (context) => const PhoneLayout(),
  tablet: (context) => const TabletLayout(),
  desktop: (context) => const DesktopLayout(),
);
```

Or use `ResponsiveBuilder` for full control via `SizingInformation`:

```dart
ResponsiveBuilder(
  builder: (context, sizingInfo) {
    if (sizingInfo.isDesktop) return const DesktopLayout();
    if (sizingInfo.isTablet) return const TabletLayout();
    return const PhoneLayout();
  },
);
```

## Widgets

### ResponsiveBuilder

The foundational builder widget. It provides a `SizingInformation` object containing everything you need to make responsive decisions:

```dart
ResponsiveBuilder(
  builder: (context, sizingInfo) {
    // sizingInfo.deviceScreenType  - watch, phone, tablet, desktop
    // sizingInfo.refinedSize       - small, normal, large, extraLarge
    // sizingInfo.screenSize        - full screen Size
    // sizingInfo.localWidgetSize   - this widget's constrained Size

    return Text('Device: ${sizingInfo.deviceScreenType}');
  },
);
```

You can also pass custom breakpoints to a specific `ResponsiveBuilder`:

```dart
ResponsiveBuilder(
  breakpoints: const ScreenBreakpoints(small: 200, normal: 500, large: 900),
  builder: (context, sizingInfo) {
    return Text('Type: ${sizingInfo.deviceScreenType}');
  },
);
```

#### SizingInformation

| Property           | Type               | Description                                    |
|--------------------|---------------------|-----------------------------------------------|
| `deviceScreenType` | `DeviceScreenType`  | watch, phone, tablet, or desktop              |
| `refinedSize`      | `RefinedSize`       | small, normal, large, or extraLarge           |
| `screenSize`       | `Size`              | The full screen dimensions                    |
| `localWidgetSize`  | `Size`              | The widget's own constrained dimensions       |
| `isWatch`          | `bool`              | Convenience getter                            |
| `isPhone`          | `bool`              | Convenience getter                            |
| `isTablet`         | `bool`              | Convenience getter                            |
| `isDesktop`        | `bool`              | Convenience getter                            |
| `isSmall`          | `bool`              | Convenience getter for refined size           |
| `isNormal`         | `bool`              | Convenience getter for refined size           |
| `isLarge`          | `bool`              | Convenience getter for refined size           |
| `isExtraLarge`     | `bool`              | Convenience getter for refined size           |

### ScreenTypeLayout

Declaratively assign a layout for each device type. Widgets are built lazily -- only the one matching the current screen type is created.

**Using builders** (recommended):

```dart
ScreenTypeLayout.builder(
  phone: (context) => Container(color: Colors.blue),
  tablet: (context) => Container(color: Colors.yellow),
  desktop: (context) => Container(color: Colors.red),
  watch: (context) => Container(color: Colors.purple),
);
```

**With sizing information** -- use `builder2` to receive a `SizingInformation` object in each builder for more granular control:

```dart
ScreenTypeLayout.builder2(
  phone: (context, sizing) => Padding(
    padding: EdgeInsets.all(sizing.isSmall ? 8 : 16),
    child: const Text('Phone'),
  ),
  tablet: (context, sizing) => const Text('Tablet'),
  desktop: (context, sizing) => const Text('Desktop'),
);
```

**Fallback behavior**: if a layout is not provided for the current device type, it falls back to the next smaller type. For example, if no `desktop` builder is supplied, the `tablet` builder is used; if that is also missing, `phone` is used.

### OrientationLayoutBuilder

Provides separate builders for portrait and landscape orientations. This is a more readable alternative to raw `OrientationBuilder` conditionals:

```dart
OrientationLayoutBuilder(
  portrait: (context) => const PortraitView(),
  landscape: (context) => const LandscapeView(),
);
```

Use the `mode` property to lock the orientation:

```dart
OrientationLayoutBuilder(
  mode: OrientationLayoutBuilderMode.portrait, // always portrait
  portrait: (context) => const PortraitView(),
  landscape: (context) => const LandscapeView(),
);
```

A common pattern is to lock phone orientation but allow tablets to rotate:

```dart
ResponsiveBuilder(
  builder: (context, sizingInfo) {
    return OrientationLayoutBuilder(
      mode: sizingInfo.isPhone
          ? OrientationLayoutBuilderMode.portrait
          : OrientationLayoutBuilderMode.auto,
      portrait: (context) => const PortraitView(),
      landscape: (context) => const LandscapeView(),
    );
  },
);
```

### RefinedLayoutBuilder

When you need more granularity than just device type, `RefinedLayoutBuilder` lets you provide layouts for four size tiers within the current device type:

```dart
RefinedLayoutBuilder(
  small: (context) => const CompactView(),
  normal: (context) => const NormalView(),
  large: (context) => const ExpandedView(),
  extraLarge: (context) => const UltraWideView(),
);
```

The `normal` builder is required; all others are optional and fall back gracefully.

## Helper Functions

### getValueForScreenType

Returns a value based on the current device type. Perfect for changing a single property without rebuilding the entire widget:

```dart
Container(
  padding: EdgeInsets.all(
    getValueForScreenType<double>(
      context: context,
      mobile: 10,
      tablet: 30,
      desktop: 60,
    ),
  ),
  child: const Text('Responsive padding'),
)
```

Conditionally show or hide widgets:

```dart
if (getValueForScreenType<bool>(
  context: context,
  mobile: false,
  tablet: true,
))
  const SideNavigation(),
```

### getValueForRefinedSize

Same concept, but based on refined size categories instead of device type:

```dart
final fontSize = getValueForRefinedSize<double>(
  context: context,
  small: 12,
  normal: 16,
  large: 20,
  extraLarge: 24,
);
```

## Responsive Sizing Extensions

For percentage-based sizing relative to the screen dimensions, wrap your app with `ResponsiveApp`:

```dart
ResponsiveApp(
  builder: (context) => MaterialApp(
    home: const MyHomePage(),
  ),
)
```

Then use the extensions on any `num`:

```dart
SizedBox(
  width: 50.screenWidth,   // 50% of screen width
  height: 30.screenHeight, // 30% of screen height
)

// Shorthand aliases
SizedBox(
  width: 50.sw,
  height: 30.sh,
)
```

| Extension      | Shorthand | Description                          |
|----------------|-----------|--------------------------------------|
| `screenWidth`  | `sw`      | Percentage of the screen width       |
| `screenHeight` | `sh`      | Percentage of the screen height      |

The `preferDesktop` flag on `ResponsiveApp` controls the default layout preference when a specific layout is not provided:

```dart
ResponsiveApp(
  preferDesktop: true,
  builder: (context) => MaterialApp(...),
)
```

## Breakpoints

### Default Breakpoints

The package uses these defaults to classify device types (in logical pixels):

| Device Type | Width Range          |
|-------------|----------------------|
| Watch       | < 300                |
| Phone       | 300 -- 599           |
| Tablet      | 600 -- 949           |
| Desktop     | >= 950               |

> On mobile platforms, the `shortestSide` of the screen is used for classification (so rotating a phone does not change its device type). On web and desktop platforms, the actual width is used.

### Custom Breakpoints (per widget)

Override breakpoints for a specific widget:

```dart
ScreenTypeLayout.builder(
  breakpoints: const ScreenBreakpoints(
    small: 200,
    normal: 500,
    large: 900,
  ),
  phone: (context) => const PhoneLayout(),
  tablet: (context) => const TabletLayout(),
  desktop: (context) => const DesktopLayout(),
);
```

Breakpoints are validated in debug mode -- the values must satisfy `small < normal < large`.

### Global Breakpoints

Set breakpoints once for the entire app:

```dart
void main() {
  ResponsiveSizingConfig.instance.setCustomBreakpoints(
    const ScreenBreakpoints(small: 200, normal: 550, large: 1000),
  );
  runApp(const MyApp());
}
```

Per-widget breakpoints will override global ones when provided.

### Refined Breakpoints

Refined breakpoints provide a second level of granularity within each device type. The defaults are:

| Category | Small | Normal | Large | Extra Large |
|----------|-------|--------|-------|-------------|
| Mobile   | 320   | 375    | 414   | 480         |
| Tablet   | 600   | 768    | 850   | 900         |
| Desktop  | 950   | 1920   | 3840  | 4096        |

Override them globally alongside screen breakpoints:

```dart
ResponsiveSizingConfig.instance.setCustomBreakpoints(
  const ScreenBreakpoints(small: 200, normal: 550, large: 1000),
  customRefinedBreakpoints: const RefinedBreakpoints(
    mobileSmall: 280,
    mobileNormal: 350,
    mobileLarge: 420,
    mobileExtraLarge: 500,
    tabletSmall: 550,
    tabletNormal: 700,
    tabletLarge: 850,
    tabletExtraLarge: 950,
    desktopSmall: 1000,
    desktopNormal: 1400,
    desktopLarge: 1920,
    desktopExtraLarge: 2560,
  ),
);
```

## Scroll Transform Effects

Create scroll-driven animations with `ScrollTransformView` and `ScrollTransformItem`:

```dart
ScrollTransformView(
  children: [
    ScrollTransformItem(
      builder: (scrollOffset) => Container(
        height: 200,
        color: Colors.blue,
        child: Text('Offset: $scrollOffset'),
      ),
      // Parallax: moves at half the scroll speed
      offsetBuilder: (scrollOffset) => Offset(0, -scrollOffset * 0.5),
    ),
    ScrollTransformItem(
      builder: (scrollOffset) => Container(
        height: 300,
        color: Colors.red,
      ),
      // Scale down as user scrolls
      scaleBuilder: (scrollOffset) => (1 - scrollOffset * 0.001).clamp(0.5, 1.0),
    ),
  ],
)
```

| Property        | Type                                    | Description                              |
|-----------------|-----------------------------------------|------------------------------------------|
| `builder`       | `Widget Function(double scrollOffset)`  | **Required.** Builds the child widget    |
| `offsetBuilder` | `Offset Function(double scrollOffset)?` | Optional translation transform           |
| `scaleBuilder`  | `double Function(double scrollOffset)?` | Optional scale transform                 |

## API Reference

### Widgets

| Widget                      | Description                                              |
|-----------------------------|----------------------------------------------------------|
| `ResponsiveBuilder`         | Builder with full `SizingInformation`                    |
| `ScreenTypeLayout.builder`  | Declarative layout per device type                       |
| `ScreenTypeLayout.builder2` | Layout per device type with `SizingInformation`          |
| `OrientationLayoutBuilder`  | Separate builders for portrait / landscape               |
| `RefinedLayoutBuilder`      | Layout per refined size (small, normal, large, XL)       |
| `ResponsiveApp`             | Wrapper enabling responsive sizing extensions            |
| `ScrollTransformView`       | Scrollable view with transform effects                   |
| `ScrollTransformItem`       | Child widget with scroll-driven transforms               |

### Helper Functions

| Function                  | Description                                           |
|---------------------------|-------------------------------------------------------|
| `getDeviceType`           | Returns `DeviceScreenType` for a given `Size`         |
| `getRefinedSize`          | Returns `RefinedSize` for a given `Size`              |
| `getValueForScreenType`   | Returns a value based on device type                  |
| `getValueForRefinedSize`  | Returns a value based on refined size                 |

### Enums

| Enum               | Values                                |
|--------------------|---------------------------------------|
| `DeviceScreenType` | `watch`, `phone`, `tablet`, `desktop` |
| `RefinedSize`      | `small`, `normal`, `large`, `extraLarge` |

### Data Classes

| Class               | Description                                         |
|---------------------|-----------------------------------------------------|
| `SizingInformation` | Screen type, refined size, screen and widget sizes   |
| `ScreenBreakpoints` | Custom breakpoints: `small`, `normal`, `large`       |
| `RefinedBreakpoints`| Granular breakpoints per device category             |

## Contributing

1. Fork it
2. Create your feature branch: `git checkout -b feature/my-feature`
3. Commit your changes: `git commit -am 'Add my feature'`
4. Push to the branch: `git push origin feature/my-feature`
5. Submit a pull request
