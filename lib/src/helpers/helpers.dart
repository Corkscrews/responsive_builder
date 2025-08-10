// Removed import 'dart:io' for WASM compatibility.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:responsive_builder2/responsive_builder2.dart';
import 'package:universal_platform/universal_platform.dart';

import 'device_width.dart' if (dart.library.js_interop) 'device_width_web.dart'
    as width;

/// Determines if the current platform is web or desktop (WASM compatible)
final _isWebOrDesktop = kIsWeb ||
    UniversalPlatform.isWindows ||
    UniversalPlatform.isLinux ||
    UniversalPlatform.isMacOS;

/// Returns the [DeviceScreenType] that the application is currently running on
///
/// This function determines the device type based on the screen size and
/// optional breakpoints.
///
/// Parameters:
/// * [size] - The current screen size
/// * [breakpoint] - Optional custom breakpoints to override defaults
/// * [isWebOrDesktop] - Optional flag to force web/desktop behavior
///
/// Returns [DeviceScreenType] representing the current device type (desktop,
/// tablet, phone, or watch)
DeviceScreenType getDeviceType(Size size,
    [ScreenBreakpoints? breakpoint = null, bool? isWebOrDesktop]) {
  isWebOrDesktop = isWebOrDesktop ??= _isWebOrDesktop;
  double deviceWidth = width.deviceWidth(size, isWebOrDesktop);

  // Use provided breakpoint with middle (normal) threshold
  if (breakpoint != null) {
    // Desktop or Tablet for very large widths
    if (deviceWidth >= breakpoint.large) {
      return _desktopOrTablet(isWebOrDesktop);
    }

    // Watch for very small widths
    if (deviceWidth < breakpoint.small) {
      return DeviceScreenType.watch;
    }

    // Classify phone/tablet using normal
    if (deviceWidth < breakpoint.normal) {
      return DeviceScreenType.phone;
    }
    return DeviceScreenType.tablet;
  }

  if (deviceWidth >= ResponsiveSizingConfig.instance.breakpoints.large) {
    return _desktopOrTablet(isWebOrDesktop);
  }

  if (deviceWidth < ResponsiveSizingConfig.instance.breakpoints.small) {
    return DeviceScreenType.watch;
  }

  // Use global normal threshold
  final globalNormal = ResponsiveSizingConfig.instance.breakpoints.normal;
  if (deviceWidth < globalNormal) {
    return DeviceScreenType.phone;
  }
  return DeviceScreenType.tablet;
}

/// Helper function to determine if a large screen should be treated as desktop
/// or tablet
///
/// Returns [DeviceScreenType.desktop] if [isWebOrDesktop] is true, otherwise
/// returns [DeviceScreenType.tablet]
DeviceScreenType _desktopOrTablet(bool? isWebOrDesktop) =>
    (isWebOrDesktop ?? _isWebOrDesktop)
        ? DeviceScreenType.desktop
        : DeviceScreenType.tablet;

/// Returns the [RefinedSize] for the current device based on screen dimensions
///
/// This function provides more granular size categories (extraLarge, large,
/// normal, small)
/// within each device type (desktop, tablet, phone, watch).
///
/// Parameters:
/// * [size] - The current screen size
/// * [refinedBreakpoint] - Optional custom breakpoints for refined sizes
/// * [isWebOrDesktop] - Optional flag to force web/desktop behavior
///
/// Returns [RefinedSize] representing the current refined size category
RefinedSize getRefinedSize(
  Size size, {
  RefinedBreakpoints? refinedBreakpoint,
  bool? isWebOrDesktop,
}) {
  isWebOrDesktop = isWebOrDesktop ?? _isWebOrDesktop;
  double deviceWidth = isWebOrDesktop ? size.width : size.shortestSide;

  DeviceScreenType deviceScreenType = getDeviceType(size, null, isWebOrDesktop);

  // Replaces the defaults with the user defined definitions
  if (refinedBreakpoint != null) {
    if (deviceScreenType == DeviceScreenType.desktop) {
      if (deviceWidth >= refinedBreakpoint.desktopExtraLarge) {
        return RefinedSize.extraLarge;
      }

      if (deviceWidth >= refinedBreakpoint.desktopLarge) {
        return RefinedSize.large;
      }

      if (deviceWidth >= refinedBreakpoint.desktopNormal) {
        return RefinedSize.normal;
      }

      // Below desktopNormal threshold
      return RefinedSize.small;
    }

    if (deviceScreenType == DeviceScreenType.tablet) {
      if (deviceWidth >= refinedBreakpoint.tabletExtraLarge) {
        return RefinedSize.extraLarge;
      }

      if (deviceWidth >= refinedBreakpoint.tabletLarge) {
        return RefinedSize.large;
      }

      if (deviceWidth >= refinedBreakpoint.tabletNormal) {
        return RefinedSize.normal;
      }

      // Below tabletNormal threshold
      return RefinedSize.small;
    }

    if (deviceScreenType == DeviceScreenType.phone) {
      if (deviceWidth >= refinedBreakpoint.mobileExtraLarge) {
        return RefinedSize.extraLarge;
      }

      if (deviceWidth >= refinedBreakpoint.mobileLarge) {
        return RefinedSize.large;
      }

      if (deviceWidth >= refinedBreakpoint.mobileNormal) {
        return RefinedSize.normal;
      }

      // Below mobileNormal threshold
      return RefinedSize.small;
    }

    if (deviceScreenType == DeviceScreenType.watch) {
      return RefinedSize.normal;
    }
  }
  // If no user defined definitions are passed through use the defaults
  if (deviceScreenType == DeviceScreenType.desktop) {
    if (deviceWidth >=
        ResponsiveSizingConfig.instance.refinedBreakpoints.desktopExtraLarge) {
      return RefinedSize.extraLarge;
    }

    if (deviceWidth >=
        ResponsiveSizingConfig.instance.refinedBreakpoints.desktopLarge) {
      return RefinedSize.large;
    }

    if (deviceWidth >=
        ResponsiveSizingConfig.instance.refinedBreakpoints.desktopNormal) {
      return RefinedSize.normal;
    }
  }

  if (deviceScreenType == DeviceScreenType.tablet) {
    if (deviceWidth >=
        ResponsiveSizingConfig.instance.refinedBreakpoints.tabletExtraLarge) {
      return RefinedSize.extraLarge;
    }

    if (deviceWidth >=
        ResponsiveSizingConfig.instance.refinedBreakpoints.tabletLarge) {
      return RefinedSize.large;
    }

    if (deviceWidth >=
        ResponsiveSizingConfig.instance.refinedBreakpoints.tabletNormal) {
      return RefinedSize.normal;
    }
  }

  if (deviceScreenType == DeviceScreenType.phone) {
    if (deviceWidth >=
        ResponsiveSizingConfig.instance.refinedBreakpoints.mobileExtraLarge) {
      return RefinedSize.extraLarge;
    }

    if (deviceWidth >=
        ResponsiveSizingConfig.instance.refinedBreakpoints.mobileLarge) {
      return RefinedSize.large;
    }

    if (deviceWidth >=
        ResponsiveSizingConfig.instance.refinedBreakpoints.mobileNormal) {
      return RefinedSize.normal;
    }
  }

  return RefinedSize.small;
}

/// Returns a value based on the current device screen type
///
/// This function selects the appropriate value from the provided options based
/// on the current device type (desktop, tablet, phone, watch). It follows a
/// fallback pattern where if a value for the current device type isn't provided,
/// it will use the next best option.
///
/// Parameters:
/// * [context] - The build context
/// * [isWebOrDesktop] - Optional flag to force web/desktop behavior
/// * [mobile] - Required value for mobile devices
/// * [tablet] - Optional value for tablet devices
/// * [desktop] - Optional value for desktop devices
/// * [watch] - Optional value for watch devices
///
/// Returns the appropriate value for the current device type
T getValueForScreenType<T>({
  required BuildContext context,
  bool? isWebOrDesktop,
  required T mobile,
  T? tablet,
  T? desktop,
  T? watch,
}) {
  DeviceScreenType deviceScreenType =
      getDeviceType(MediaQuery.sizeOf(context), null, isWebOrDesktop);
  // If we're at desktop size
  if (deviceScreenType == DeviceScreenType.desktop) {
    // If we have supplied the desktop layout then display that
    if (desktop != null) return desktop;
    // If no desktop layout is supplied we want to check if we have the size
    // below it and display that
    if (tablet != null) return tablet;
  }

  if (deviceScreenType == DeviceScreenType.tablet) {
    if (tablet != null) return tablet;
  }

  if (deviceScreenType == DeviceScreenType.watch && watch != null) {
    return watch;
  }

  if (deviceScreenType == DeviceScreenType.phone) {
    if (mobile != null) return mobile;
  }

  // If none of the layouts above are supplied we use the prefered layout based
  // on the flag
  final buildDesktopLayout = ResponsiveAppUtil.preferDesktop && desktop != null;

  return buildDesktopLayout ? desktop : mobile;
}

/// Returns a value based on the current refined screen size
///
/// This function selects the appropriate value from the provided options based
/// on the current refined size (extraLarge, large, normal, small). It follows a
/// fallback pattern where if a value for the current size isn't provided, it
/// will use the next best option.
///
/// Parameters:
/// * [context] - The build context
/// * [small] - Optional value for small screens
/// * [normal] - Required value for normal screens
/// * [large] - Optional value for large screens
/// * [extraLarge] - Optional value for extra large screens
///
/// Returns the appropriate value for the current refined size
/// Will return one of the values passed in for the refined size
T getValueForRefinedSize<T>({
  required BuildContext context,
  T? small,
  required T normal,
  T? large,
  T? extraLarge,
}) {
  RefinedSize refinedSize = getRefinedSize(MediaQuery.sizeOf(context));
  // If we're at extra large size
  if (refinedSize == RefinedSize.extraLarge) {
    // If we have supplied the extra large layout then display that
    if (extraLarge != null) return extraLarge;
    // If no extra large layout is supplied we want to check if we have the
    // size below it and display that
    if (large != null) return large;
  }

  if (refinedSize == RefinedSize.large) {
    // If we have supplied the large layout then display that
    if (large != null) return large;
    // If no large layout is supplied we want to check if we have the size
    // below it and display that
    if (normal != null) return normal;
  }

  // No need to verify normal size, it's the default
  // if (refinedSize == RefinedSize.normal) {
  //   // If we have supplied the normal layout then display that
  //   if (normal != null) return normal;
  // }

  if (refinedSize == RefinedSize.small) {
    // If we have supplied the small layout then display that
    if (small != null) return small;
  }

  // If none of the layouts above are supplied or we're on the normal size
  // layout then we show the normal layout
  return normal;
}

class ScreenTypeValueBuilder<T> {
  @Deprecated('Use better named global function getValueForScreenType')
  T getValueForType({
    required BuildContext context,
    bool? isWebOrDesktop,
    required T mobile,
    T? tablet,
    T? desktop,
    T? watch,
  }) {
    return getValueForScreenType(
      context: context,
      isWebOrDesktop: isWebOrDesktop,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      watch: watch,
    );
  }
}
