import 'package:responsive_builder2/responsive_builder2.dart';

/// A singleton configuration class that manages breakpoints for responsive
/// layouts.
///
/// This class provides a centralized way to configure and access breakpoints
/// used for determining device types (mobile, tablet, desktop) and refined size
/// categories (small, normal, large, extraLarge). It uses the singleton pattern
/// to ensure consistent breakpoint values throughout the app.
///
/// Example:
/// ```dart
/// // Configure custom breakpoints
/// ResponsiveSizingConfig.instance.setCustomBreakpoints(
///   ScreenBreakpoints(small: 320, large: 768),
///   customRefinedBreakpoints: RefinedBreakpoints(
///     mobileSmall: 320,
///     mobileNormal: 375,
///     // ... other breakpoints
///   ),
/// );
///
/// // Access breakpoints
/// final breakpoints = ResponsiveSizingConfig.instance.breakpoints;
/// final rb = ResponsiveSizingConfig.instance.refinedBreakpoints;
/// ```
class ResponsiveSizingConfig {
  static ResponsiveSizingConfig? _instance;

  /// Returns the singleton instance of [ResponsiveSizingConfig].
  ///
  /// Creates a new instance if one doesn't exist.
  static ResponsiveSizingConfig get instance {
    if (_instance == null) {
      _instance = ResponsiveSizingConfig();
    }
    return _instance!;
  }

  /// Default breakpoints for determining device types.
  ///
  /// These values are used when no custom breakpoints are set:
  /// * [large]: 600 logical pixels - devices above this width are considered
  /// tablets/desktops
  /// * [small]: 300 logical pixels - devices below this width are considered
  /// mobile
  static const ScreenBreakpoints _defaultBreakPoints = ScreenBreakpoints(
    large: 600,
    small: 300,
  );

  /// Custom breakpoints that override the defaults when set.
  ScreenBreakpoints? _customBreakPoints;

  /// Default breakpoints for refined size categories.
  ///
  /// These values define the boundaries for different size categories across
  /// device types. All values are in logical pixels:
  ///
  /// Desktop breakpoints:
  /// * [desktopExtraLarge]: 4096px - 4K displays
  /// * [desktopLarge]: 3840px - Large desktop displays
  /// * [desktopNormal]: 1920px - Standard desktop displays
  /// * [desktopSmall]: 950px - Small desktop displays
  ///
  /// Tablet breakpoints:
  /// * [tabletExtraLarge]: 900px - Large tablets
  /// * [tabletLarge]: 850px - Standard tablets
  /// * [tabletNormal]: 768px - Small tablets
  /// * [tabletSmall]: 600px - Mini tablets
  ///
  /// Mobile breakpoints:
  /// * [mobileExtraLarge]: 480px - Large phones
  /// * [mobileLarge]: 414px - Standard phones
  /// * [mobileNormal]: 375px - Small phones
  /// * [mobileSmall]: 320px - Mini phones
  static const RefinedBreakpoints _defaultRefinedBreakPoints =
      RefinedBreakpoints(
    // Desktop
    desktopExtraLarge: 4096,
    desktopLarge: 3840,
    desktopNormal: 1920,
    desktopSmall: 950,
    // Tablet
    tabletExtraLarge: 900,
    tabletLarge: 850,
    tabletNormal: 768,
    tabletSmall: 600,
    // Mobile
    mobileExtraLarge: 480,
    mobileLarge: 414,
    mobileNormal: 375,
    mobileSmall: 320,
  );

  /// Custom refined breakpoints that override the defaults when set.
  RefinedBreakpoints? _customRefinedBreakPoints;

  /// Sets custom breakpoints for device types and refined size categories.
  ///
  /// Parameters:
  /// * [customBreakpoints]: Optional custom breakpoints for device types
  /// * [customRefinedBreakpoints]: Optional custom breakpoints for refined
  /// size categories
  ///
  /// If either parameter is null, the corresponding default breakpoints will
  /// be used.
  void setCustomBreakpoints(
    ScreenBreakpoints? customBreakpoints, {
    RefinedBreakpoints? customRefinedBreakpoints,
  }) {
    _customBreakPoints = customBreakpoints;
    if (customRefinedBreakpoints != null) {
      _customRefinedBreakPoints = customRefinedBreakpoints;
    }
  }

  /// Returns the current breakpoints for device types.
  ///
  /// Returns custom breakpoints if set, otherwise returns default breakpoints.
  ScreenBreakpoints get breakpoints =>
      _customBreakPoints ?? _defaultBreakPoints;

  /// Returns the current breakpoints for refined size categories.
  ///
  /// Returns custom breakpoints if set, otherwise returns default breakpoints.
  RefinedBreakpoints get refinedBreakpoints =>
      _customRefinedBreakPoints ?? _defaultRefinedBreakPoints;
}
