import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder2/responsive_builder2.dart';

// Author: https://github.com/fastogt/responsive_builder/tree/master
import 'device_width.dart' if (dart.library.js_interop) 'device_width_web.dart'
    as width;

final _isWebOrDesktop =
    kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS;

/// Returns the [DeviceScreenType] that the application is currently running on
DeviceScreenType getDeviceType(Size size,
    [ScreenBreakpoints? breakpoint = null, bool? isWebOrDesktop]) {
  isWebOrDesktop = isWebOrDesktop ??= _isWebOrDesktop;
  double deviceWidth = width.deviceWidth(size, isWebOrDesktop);

  // Replaces the defaults with the user defined definitions
  if (breakpoint != null) {
    if (deviceWidth > breakpoint.large) {
      return _desktopOrTablet(isWebOrDesktop);
    }

    if (deviceWidth < breakpoint.small) {
      return DeviceScreenType.watch;
    }
  }

  if (deviceWidth >= ResponsiveSizingConfig.instance.breakpoints.large) {
    return _desktopOrTablet(isWebOrDesktop);
  }

  if (deviceWidth < ResponsiveSizingConfig.instance.breakpoints.small) {
    return DeviceScreenType.watch;
  }

  return DeviceScreenType.mobile;
}

// coverage:ignore-start
DeviceScreenType _desktopOrTablet(bool? isWebOrDesktop) =>
    (isWebOrDesktop ?? _isWebOrDesktop)
        ? DeviceScreenType.desktop
        : DeviceScreenType.tablet;
// coverage:ignore-end

/// Returns the [RefindedSize] for each device that the application is currently running on
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
    }

    if (deviceScreenType == DeviceScreenType.mobile) {
      if (deviceWidth >= refinedBreakpoint.mobileExtraLarge) {
        return RefinedSize.extraLarge;
      }

      if (deviceWidth >= refinedBreakpoint.mobileLarge) {
        return RefinedSize.large;
      }

      if (deviceWidth >= refinedBreakpoint.mobileNormal) {
        return RefinedSize.normal;
      }
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

  if (deviceScreenType == DeviceScreenType.mobile) {
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

/// Will return one of the values passed in for the device it's running on
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
    // If no desktop layout is supplied we want to check if we have the size below it and display that
    if (tablet != null) return tablet;
  }

  if (deviceScreenType == DeviceScreenType.tablet) {
    if (tablet != null) return tablet;
  }

  if (deviceScreenType == DeviceScreenType.watch && watch != null) {
    return watch;
  }

  if (deviceScreenType == DeviceScreenType.mobile) {
    if (mobile != null) return mobile;
  }

  // If none of the layouts above are supplied we use the prefered layout based on the flag
  final buildDesktopLayout = ResponsiveAppUtil.preferDesktop && desktop != null;

  return buildDesktopLayout ? desktop : mobile;
}

/// Will return one of the values passed in for the refined size
T getValueForRefinedSize<T>({
  required BuildContext context,
  required T normal,
  T? large,
  T? extraLarge,
  T? small,
}) {
  RefinedSize refinedSize = getRefinedSize(MediaQuery.sizeOf(context));
  // If we're at extra large size
  if (refinedSize == RefinedSize.extraLarge) {
    // If we have supplied the extra large layout then display that
    if (extraLarge != null) return extraLarge;
    // If no extra large layout is supplied we want to check if we have the size below it and display that
    if (large != null) return large;
  }

  if (refinedSize == RefinedSize.large) {
    // If we have supplied the large layout then display that
    if (large != null) return large;
    // If no large layout is supplied we want to check if we have the size below it and display that
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

  // If none of the layouts above are supplied or we're on the normal size layout then we show the normal layout
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
