import 'package:flutter/widgets.dart';

/// A widget that wraps your app to enable responsive sizing functionality.
///
/// This widget provides the foundation for responsive design by tracking
/// screen dimensions and orientation. It should be placed at the root of your
/// widget tree to enable the responsive sizing extensions throughout your app.
///
/// Example:
/// ```dart
/// ResponsiveApp(
///   builder: (context) => MyApp(),
///   preferDesktop: false,
/// )
/// ```
class ResponsiveApp extends StatelessWidget {
  /// The builder function that creates the main widget tree
  final Widget Function(BuildContext) builder;

  /// Controls the default layout preference when a specific layout is not
  /// provided. When true, desktop layouts will be preferred over mobile
  /// layouts.
  final bool preferDesktop;

  const ResponsiveApp({
    super.key,
    required this.builder,
    this.preferDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        ResponsiveAppUtil.setScreenSize(constraints, orientation);
        ResponsiveAppUtil.preferDesktop = preferDesktop;
        return builder(context);
      });
    });
  }
}

/// Extension methods for numeric values to calculate responsive dimensions.
///
/// These extensions provide convenient ways to calculate dimensions as
/// percentages of the screen size. They are useful for creating layouts that
/// scale proportionally with the screen size.
extension ResponsiveAppExtensions on num {
  /// Calculates a percentage of the screen height.
  ///
  /// Returns the value as a percentage of the current screen height.
  /// For example, `20.screenHeight` returns 20% of the screen height.
  double get screenHeight => (this / 100) * ResponsiveAppUtil.height;

  /// Calculates a percentage of the screen width.
  ///
  /// Returns the value as a percentage of the current screen width.
  /// For example, `20.screenWidth` returns 20% of the screen width.
  double get screenWidth => (this / 100) * ResponsiveAppUtil.width;

  /// Shorthand alias for [screenHeight]
  double get sh => screenHeight;

  /// Shorthand alias for [screenWidth]
  double get sw => screenWidth;
}

/// Utility class for managing responsive app dimensions and preferences.
///
/// This class maintains the current screen dimensions and layout preferences
/// for use throughout the app. It is used internally by the responsive
/// extensions and should not be accessed directly in most cases.
///
/// TODO: Replace with ValueNotifier for better state management
class ResponsiveAppUtil {
  /// The current screen height in logical pixels
  static double height = 0;

  /// The current screen width in logical pixels
  static double width = 0;

  /// Whether to prefer desktop layouts over mobile layouts
  static bool preferDesktop = false;

  /// Updates the stored screen dimensions based on the current constraints
  /// and orientation.
  ///
  /// This method should be called whenever the screen size or orientation
  /// changes. Width and height are taken directly from the constraints,
  /// since Flutter's [LayoutBuilder] already provides dimensions that
  /// reflect the actual layout (width is the horizontal extent, height is
  /// the vertical extent, regardless of orientation).
  static void setScreenSize(
    BoxConstraints constraints,
    Orientation orientation,
  ) {
    width = constraints.maxWidth;
    height = constraints.maxHeight;
  }
}
