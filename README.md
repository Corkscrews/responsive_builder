![Responsive UI in Flutter Banner](https://github.com/Corkscrews/responsive_builder/blob/master/responsive_builder2.jpg)

# responsive_builder2

The responsive builder package contains widgets that allows you to create a readable responsive UI. The package is inspired by the [Responsive UI Flutter series](https://www.youtube.com/playlist?list=PLQQBiNtFxeyJbOkeKBe_JG36gm1V2629H) originally created by FilledStacks and forked by Corkscrews.

It aims to provide you with widgets that make it easy to build different UI's along two different Axis. Orientation x ScreenType. This means you can have a separate layout for Mobile - Landscape, Mobile - Portrait, Tablet - Landscape and Tablet-Portrait.

![Responsive Layout Preview](https://github.com/Corkscrews/responsive_builder/blob/master/responsive_example.gif)

## Installation

Add responsive_builder as dependency to your pubspec file.

```
responsive_builder2: ^0.8.7
```

## Usage

This package provides two main widgets for building responsive UIs: `ResponsiveBuilder` and `ScreenTypeLayout.builder2`.

- `ResponsiveBuilder` gives you a builder function with a `SizingInformation` object, which contains details like the current `DeviceScreenType`, `screenSize`, and `localWidgetSize`. This allows you to make fine-grained responsive decisions at any widget level.

- `ScreenTypeLayout.builder2` is a more advanced option that also provides a `SizingInformation` object to each builder for different device types (mobile, tablet, desktop, watch). This makes it easy to define separate layouts for each device type, while still having access to all sizing information for granular control.

Use these widgets to easily adapt your UI to different screen sizes and device types, from the overall view down to individual widgets.

### ScreenTypeLayout.builder2

If you want even more control and need access to the current sizing information (such as device type, screen size, and refined size) in your builder, you can use the new `ScreenTypeLayout.builder2`. This variant provides a `SizingInformation` object to each builder, allowing you to make more granular responsive decisions.

```dart
// import the package
import 'package:responsive_builder2/responsive_builder2.dart';

// Construct and pass in a widget builder per screen type, with sizing info
ScreenTypeLayout.builder2(
  phone: (BuildContext context, SizingInformation sizing) => Container(
    color: sizing.isPhone ? Colors.blue : Colors.grey,
    child: Text('Phone, Width: \\${sizing.screenSize.width}'),
  ),
  tablet: (BuildContext context, SizingInformation sizing) => Container(
    color: Colors.yellow,
    child: Text('Tablet, Refined: \\${sizing.refinedSize}'),
  ),
  desktop: (BuildContext context, SizingInformation sizing) => Container(
    color: Colors.red,
    child: Text('Desktop, Size: \\${sizing.screenSize}'),
  ),
  watch: (BuildContext context, SizingInformation sizing) => Container(
    color: Colors.purple,
    child: Text('Watch'),
  ),
);
```

## ScreenTypeLayout (Deprecated)

This widget is similar to the Orientation Layout Builder in that it takes in Widgets that are named and displayed for different screen types.

```dart
// import the package
import 'package:responsive_builder2/responsive_builder2.dart';

// Construct and pass in a widget per screen type
ScreenTypeLayout(
  mobile: Container(color:Colors.blue),
  tablet: Container(color: Colors.yellow),
  desktop: Container(color: Colors.red),
  watch: Container(color: Colors.purple),
);
```

If you don't want to build all the widgets at once, you can use the widget builder. A widget for the right type of screen will be created only when needed.

```dart
// Construct and pass in a widget builder per screen type
ScreenTypeLayout.builder(
  mobile: (BuildContext context) => Container(color:Colors.blue),
  tablet: (BuildContext context) => Container(color:Colors.yellow),
  desktop: (BuildContext context) => Container(color:Colors.red),
  watch: (BuildContext context) => Container(color:Colors.purple),
);
```

The `SizingInformation` parameter provides:
- `deviceScreenType`: The current device type (mobile, tablet, desktop, watch)
- `refinedSize`: A more granular size classification (small, normal, large, extraLarge)
- `screenSize`: The overall screen size
- `localWidgetSize`: The size of the widget being built

This allows you to build highly dynamic and responsive UIs based on detailed device and layout information.

### Responsive Builder

The `ResponsiveBuilder` is used as any other builder widget.

```dart
// import the package
import 'package:responsive_builder2/responsive_builder2.dart';

// Use the widget
ResponsiveBuilder(
    builder: (context, sizingInformation) {
      // Check the sizing information here and return your UI
          if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
          return Container(color:Colors.blue);
        }

        if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
          return Container(color:Colors.red);
        }

        if (sizingInformation.deviceScreenType == DeviceScreenType.watch) {
          return Container(color:Colors.yellow);
        }

        return Container(color:Colors.purple);
      },
    },
  );
}
```

This will return different colour containers depending on which device it's being shown on. A simple way to test this is to either run your code on Flutter web and resize the window or add the [device_preview](https://pub.dev/packages/device_preview) package and view on different devices.

## Orientation Layout Builder

This widget can be seen as a duplicate of the `OrientationBuilder` that comes with Flutter, but the point of this library is to help you produce a readable responsive UI code base. As mentioned in the [follow along tutorial](https://youtu.be/udsysUj-X4w) I didn't want responsive code riddled with conditionals around orientation, `MediaQuery` or Renderbox sizes. That's why I created this builder.

The usage is easy. Provide a builder function that returns a UI for each of the orientations.

```dart
// import the package
import 'package:responsive_builder2/responsive_builder2.dart';

// Return a widget function per orientation
OrientationLayoutBuilder(
  portrait: (context) => Container(color: Colors.green),
  landscape: (context) => Container(color: Colors.pink),
),
```

This will return a different coloured container when you swap orientations for your device. In a more readable manner than checking the orientation with a conditional.

Sometimes you want your app to stay in a certain orientation. use `mode` property in `OrientationLayoutBuilder` to enforce this.

```dart
OrientationLayoutBuilder(
  /// default mode is 'auto'
  mode: info.isPhone
    ? OrientationLayoutBuilderMode.portrait
    : OrientationLayoutBuilderMode.auto,
  ...
),
```

## Custom Screen Breakpoints

If you wish to define your own custom break points you can do so by supplying either the `ScreenTypeLayout` or `ResponsiveBuilder` widgets with a `breakpoints` argument.

```dart
// import the package
import 'package:responsive_builder2/responsive_builder2.dart';

//ScreenTypeLayout with custom breakpoints supplied
ScreenTypeLayout(
  breakpoints: ScreenBreakpoints(
    tablet: 600,
    desktop: 950,
    watch: 300
  ),
  mobile: Container(color:Colors.blue),
  tablet: Container(color: Colors.yellow),
  desktop: Container(color: Colors.red),
  watch: Container(color: Colors.purple),
);
```

To get a more in depth run through of this package I would highly recommend [watching this tutorial](https://youtu.be/udsysUj-X4w) where I show you how it was built and how to use it.

## Global Screen Breakpoints

If you want to set the breakpoints for the responsive builders once you can call the line below before the app starts, or wherever you see fit.

```dart
void main() {
  ResponsiveSizingConfig.instance.setCustomBreakpoints(
    ScreenBreakpoints(large: 550, small: 200),
  );
  runApp(MyApp());
}
```

This will then reflect the screen types based on what you have set here. You can then still pass in custom break points per `ScreenTypeLayout` if you wish that will override these values for that specific `ScreenTypeLayout` builder.

## Screen Type specific values

Sometimes you don't want to write an entire new UI just to change one value. Say for instance you want your padding on mobile to be 10, on the tablet 30 and desktop 60. Instead of re-writing UI you can use the `getValueForScreenType` function. This is a generic function that will return your value based on the screen type you're on. Take this example below.

```dart
Container(
  padding: EdgeInsets.all(10),
  child: Text('Best Responsive Package'),
)
```

What if you ONLY want to update the padding based on the device screen size. You could do.

```dart
var deviceType = getDeviceType(MediaQuery.sizeOf(context));
var paddingValue = 0;
switch(deviceType) {
  case DeviceScreenType.desktop:
    paddingValue = 60;
    break;
  case DeviceScreenType.tablet:
    paddingValue = 30;
    break;
  case DeviceScreenType.mobile:
    paddingValue = 10;
    break;
}
Container(
  padding: EdgeInsets.all(paddingValue),
  child: Text('Best Responsive Package'),
)
```

Ooooorrrr, you can use shorthand for that.

```dart
Container(
  padding: EdgeInsets.all(getValueForScreenType<double>(
                context: context,
                mobile: 10,
                tablet: 30,
                desktop: 60,
              )),
  child: Text('Best Responsive Package'),
)
```

It will return the value you give it for the DeviceScreen you're viewing the app on. For instance you want to hide a widget on mobile and not on tablet?

```dart
getValueForScreenType<bool>(
    context: context,
    mobile: false,
    tablet: true,
  ) ? MyWidget() : Container()
```

That will return true on tablet devices and false on mobile.

## Responsive Sizing

In addition to providing specific layouts per device type there's also the requirement to size items based on the screen width or height. To use this functionality we added some responsive extensions. To use this wrap your Material or Cupertino App with the `ResponsiveApp` widget. 

```dart
ResponsiveApp(
  builder: (context) => MaterialApp(
    ...
  )
)
```

This is required to use the following functionality. 

### Responsive Sizing

To use the responsive sizing all you need to do is the following. 

```dart
import 'package:responsive_builder2/responsive_builder2.dart';

SizedBox(height: 30.screenHeight); // Or sh for shorthand
Text('respond to width', style: TextStyle(fontSize: 10.sw));
```

Use the number you want as the percentage and call the `screenHeight` or `screenWidth` extension. These also have shorthand extensions `sh` and `sw`.

## Contribution

1. Fork it!
2. Create your feature branch: `git checkout -b feature/newFeature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin feature/newFeature`
5. Submit a pull request.
