import 'package:flutter/material.dart';
import 'device_screen_type.dart';

/// Contains sizing information to make responsive choices for the current screen
class SizingInformation {
  final DeviceScreenType deviceScreenType;
  final RefinedSize refinedSize;
  final Size screenSize;
  final Size localWidgetSize;

  bool get isWatch => deviceScreenType == DeviceScreenType.watch;

  @Deprecated('Use isPhone instead')
  bool get isMobile => isPhone;

  bool get isPhone => deviceScreenType == DeviceScreenType.phone 
      // ignore: deprecated_member_use_from_same_package
      || deviceScreenType == DeviceScreenType.mobile;

  bool get isTablet => deviceScreenType == DeviceScreenType.tablet;

  bool get isDesktop => deviceScreenType == DeviceScreenType.desktop;

  // Refined

  bool get isSmall => refinedSize == RefinedSize.small;

  bool get isNormal => refinedSize == RefinedSize.normal;

  bool get isLarge => refinedSize == RefinedSize.large;

  bool get isExtraLarge => refinedSize == RefinedSize.extraLarge;

  SizingInformation({
    required this.deviceScreenType,
    required this.refinedSize,
    required this.screenSize,
    required this.localWidgetSize,
  });

  @override
  String toString() {
    return 'DeviceType:$deviceScreenType RefinedSize:$refinedSize ScreenSize:$screenSize LocalWidgetSize:$localWidgetSize';
  }
}

/// Manually define screen resolution breakpoints
///
/// Overrides the defaults
class ScreenBreakpoints {
  final double small;
  final double large;

  const ScreenBreakpoints({
    required this.small,
    required this.large,
  });

  @override
  String toString() {
    return "Large: $large, Small: $small";
  }
}

/// Manually define refined breakpoints
///
/// Overrides the defaults
class RefinedBreakpoints {
  final double mobileSmall;
  final double mobileNormal;
  final double mobileLarge;
  final double mobileExtraLarge;

  final double tabletSmall;
  final double tabletNormal;
  final double tabletLarge;
  final double tabletExtraLarge;

  final double desktopSmall;
  final double desktopNormal;
  final double desktopLarge;
  final double desktopExtraLarge;

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
  });

  @override
  String toString() {
    return "Tablet: Small - $tabletSmall Normal - $tabletNormal Large - $tabletLarge ExtraLarge - $tabletExtraLarge" +
        "\nMobile: Small - $mobileSmall Normal - $mobileNormal Large - $mobileLarge ExtraLarge - $mobileExtraLarge";
  }
}
