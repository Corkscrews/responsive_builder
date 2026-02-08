import 'package:flutter/widgets.dart';
import 'device_screen_type.dart';

/// Contains sizing information to make responsive choices for the current
/// screen.
///
/// This class provides information about the current device's screen
/// characteristics including device type (watch, phone, tablet, desktop),
/// refined size categories, and both screen and local widget dimensions.
/// Use this information to make responsive layout decisions in your app.
class SizingInformation {
  /// The type of device screen (watch, phone, tablet, desktop)
  final DeviceScreenType deviceScreenType;

  /// The refined size category (small, normal, large, extraLarge)
  final RefinedSize refinedSize;

  /// The total screen dimensions
  final Size screenSize;

  /// The dimensions of the local widget's constraints
  final Size localWidgetSize;

  /// Returns true if the device is a watch
  bool get isWatch => deviceScreenType == DeviceScreenType.watch;

  @Deprecated('Use isPhone instead')
  bool get isMobile => isPhone;

  /// Returns true if the device is a phone
  bool get isPhone =>
      deviceScreenType == DeviceScreenType.phone ||
      // ignore: deprecated_member_use_from_same_package
      deviceScreenType == DeviceScreenType.mobile;

  /// Returns true if the device is a tablet
  bool get isTablet => deviceScreenType == DeviceScreenType.tablet;

  /// Returns true if the device is a desktop
  bool get isDesktop => deviceScreenType == DeviceScreenType.desktop;

  /// Returns true if the refined size is small
  bool get isSmall => refinedSize == RefinedSize.small;

  /// Returns true if the refined size is normal
  bool get isNormal => refinedSize == RefinedSize.normal;

  /// Returns true if the refined size is large
  bool get isLarge => refinedSize == RefinedSize.large;

  /// Returns true if the refined size is extra large
  bool get isExtraLarge => refinedSize == RefinedSize.extraLarge;

  /// Creates a new [SizingInformation] instance.
  ///
  /// All parameters are required:
  /// * [deviceScreenType]: The type of device screen
  /// * [refinedSize]: The refined size category
  /// * [screenSize]: The total screen dimensions
  /// * [localWidgetSize]: The dimensions of the local widget's constraints
  const SizingInformation({
    required this.deviceScreenType,
    required this.refinedSize,
    required this.screenSize,
    required this.localWidgetSize,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SizingInformation &&
          runtimeType == other.runtimeType &&
          deviceScreenType == other.deviceScreenType &&
          refinedSize == other.refinedSize &&
          screenSize == other.screenSize &&
          localWidgetSize == other.localWidgetSize;

  @override
  int get hashCode => Object.hash(
        deviceScreenType,
        refinedSize,
        screenSize,
        localWidgetSize,
      );

  @override
  String toString() {
    return 'DeviceType:$deviceScreenType RefinedSize:$refinedSize '
        'ScreenSize:$screenSize LocalWidgetSize:$localWidgetSize';
  }
}

/// Manually define screen resolution breakpoints for device type detection.
///
/// This class allows you to override the default breakpoints used to determine
/// whether a device should be considered a watch, phone, tablet, or desktop.
/// The breakpoints are defined in logical pixels.
///
/// Behavior with three-tier classification when [normal] is provided:
/// - width < [small]                 => watch
/// - [small] <= width < [normal]     => phone
/// - [normal] <= width < [large]     => tablet
/// - width >= [large]                => desktop or tablet (based on platform)
///
/// If [normal] is null, legacy two-tier behavior is used:
/// - width < [small]                 => watch
/// - [small] <= width < [large]      => phone
/// - width >= [large]                => desktop or tablet (based on platform)
class ScreenBreakpoints {
  /// The breakpoint below which a device is considered a watch
  final double small;

  /// The breakpoint between phone and tablet.
  ///
  /// Values greater than or equal to [normal] and less than [large]
  /// will be considered tablet.
  final double normal;

  /// The breakpoint above which a device is considered large (tablet/desktop)
  final double large;

  /// Creates a new [ScreenBreakpoints] instance.
  ///
  /// [small], [normal] and [large] are required and should be specified in
  /// logical pixels. Values must satisfy `small < normal < large` and all
  /// must be non-negative.
  const ScreenBreakpoints({
    required this.small,
    required this.normal,
    required this.large,
  })  : assert(small >= 0, 'small must be non-negative'),
        assert(normal >= 0, 'normal must be non-negative'),
        assert(large >= 0, 'large must be non-negative'),
        assert(small < normal, 'small must be less than normal'),
        assert(normal < large, 'normal must be less than large');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScreenBreakpoints &&
          runtimeType == other.runtimeType &&
          small == other.small &&
          normal == other.normal &&
          large == other.large;

  @override
  int get hashCode => Object.hash(small, normal, large);

  @override
  String toString() {
    return 'Large: $large, Normal: $normal, Small: $small';
  }
}

/// Manually define refined breakpoints for more granular size categories.
///
/// This class allows you to override the default breakpoints used to determine
/// the refined size categories (small, normal, large, extraLarge) for different
/// device types. All breakpoints are defined in logical pixels.
///
/// Default values are provided for common device sizes:
/// * Mobile: 320-480px
/// * Tablet: 600-900px
/// * Desktop: 950-4096px
class RefinedBreakpoints {
  /// Mobile device breakpoints
  final double mobileSmall;
  final double mobileNormal;
  final double mobileLarge;
  final double mobileExtraLarge;

  /// Tablet device breakpoints
  final double tabletSmall;
  final double tabletNormal;
  final double tabletLarge;
  final double tabletExtraLarge;

  /// Desktop device breakpoints
  final double desktopSmall;
  final double desktopNormal;
  final double desktopLarge;
  final double desktopExtraLarge;

  /// Creates a new [RefinedBreakpoints] instance.
  ///
  /// All parameters are optional and default to common device sizes.
  /// Values should be specified in logical pixels. Within each device
  /// category, values must satisfy `small < normal < large < extraLarge`.
  const RefinedBreakpoints({
    this.mobileSmall = 320,
    this.mobileNormal = 375,
    this.mobileLarge = 414,
    this.mobileExtraLarge = 480,
    this.tabletSmall = 600,
    this.tabletNormal = 768,
    this.tabletLarge = 850,
    this.tabletExtraLarge = 900,
    this.desktopSmall = 950,
    this.desktopNormal = 1920,
    this.desktopLarge = 3840,
    this.desktopExtraLarge = 4096,
  })  : assert(mobileSmall < mobileNormal,
            'mobileSmall must be less than mobileNormal'),
        assert(mobileNormal < mobileLarge,
            'mobileNormal must be less than mobileLarge'),
        assert(mobileLarge < mobileExtraLarge,
            'mobileLarge must be less than mobileExtraLarge'),
        assert(tabletSmall < tabletNormal,
            'tabletSmall must be less than tabletNormal'),
        assert(tabletNormal < tabletLarge,
            'tabletNormal must be less than tabletLarge'),
        assert(tabletLarge < tabletExtraLarge,
            'tabletLarge must be less than tabletExtraLarge'),
        assert(desktopSmall < desktopNormal,
            'desktopSmall must be less than desktopNormal'),
        assert(desktopNormal < desktopLarge,
            'desktopNormal must be less than desktopLarge'),
        assert(desktopLarge < desktopExtraLarge,
            'desktopLarge must be less than desktopExtraLarge');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RefinedBreakpoints &&
          runtimeType == other.runtimeType &&
          mobileSmall == other.mobileSmall &&
          mobileNormal == other.mobileNormal &&
          mobileLarge == other.mobileLarge &&
          mobileExtraLarge == other.mobileExtraLarge &&
          tabletSmall == other.tabletSmall &&
          tabletNormal == other.tabletNormal &&
          tabletLarge == other.tabletLarge &&
          tabletExtraLarge == other.tabletExtraLarge &&
          desktopSmall == other.desktopSmall &&
          desktopNormal == other.desktopNormal &&
          desktopLarge == other.desktopLarge &&
          desktopExtraLarge == other.desktopExtraLarge;

  @override
  int get hashCode => Object.hash(
        mobileSmall,
        mobileNormal,
        mobileLarge,
        mobileExtraLarge,
        tabletSmall,
        tabletNormal,
        tabletLarge,
        tabletExtraLarge,
        desktopSmall,
        desktopNormal,
        desktopLarge,
        desktopExtraLarge,
      );

  @override
  String toString() {
    return 'Tablet: Small - $tabletSmall '
        'Normal - $tabletNormal '
        'Large - $tabletLarge '
        'ExtraLarge - $tabletExtraLarge '
        'Mobile: Small - $mobileSmall '
        'Normal - $mobileNormal '
        'Large - $mobileLarge '
        'ExtraLarge - $mobileExtraLarge';
  }
}
