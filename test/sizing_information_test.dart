import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_builder/src/sizing_information.dart';
import 'package:responsive_builder/src/device_screen_type.dart';
import 'package:flutter/material.dart';

void main() {
  group('SizingInformation', () {
    test('constructor and property getters', () {
      final info = SizingInformation(
        deviceScreenType: DeviceScreenType.mobile,
        refinedSize: RefinedSize.large,
        screenSize: const Size(400, 800),
        localWidgetSize: const Size(200, 400),
      );
      expect(info.deviceScreenType, DeviceScreenType.mobile);
      expect(info.refinedSize, RefinedSize.large);
      expect(info.screenSize, const Size(400, 800));
      expect(info.localWidgetSize, const Size(200, 400));
      expect(info.isMobile, isTrue);
      expect(info.isTablet, isFalse);
      expect(info.isDesktop, isFalse);
      expect(info.isWatch, isFalse);
      expect(info.isLarge, isTrue);
      expect(info.isExtraLarge, isFalse);
      expect(info.isNormal, isFalse);
      expect(info.isSmall, isFalse);
    });

    test('toString returns expected format', () {
      final info = SizingInformation(
        deviceScreenType: DeviceScreenType.desktop,
        refinedSize: RefinedSize.extraLarge,
        screenSize: const Size(1920, 1080),
        localWidgetSize: const Size(960, 540),
      );
      final str = info.toString();
      expect(str, contains('DeviceType:DeviceScreenType.desktop'));
      expect(str, contains('RefinedSize:RefinedSize.extraLarge'));
      expect(str, contains('ScreenSize:Size(1920.0, 1080.0)'));
      expect(str, contains('LocalWidgetSize:Size(960.0, 540.0)'));
    });
  });

  group('ScreenBreakpoints', () {
    test('constructor and toString', () {
      const breakpoints = ScreenBreakpoints(small: 300, large: 1200);
      expect(breakpoints.small, 300);
      expect(breakpoints.large, 1200);
      expect(breakpoints.toString(), contains('Large: 1200'));
      expect(breakpoints.toString(), contains('Small: 300'));
    });
  });

  group('RefinedBreakpoints', () {
    test('default values', () {
      const refined = RefinedBreakpoints();
      expect(refined.mobileSmall, 320);
      expect(refined.mobileNormal, 375);
      expect(refined.mobileLarge, 414);
      expect(refined.mobileExtraLarge, 480);
      expect(refined.tabletSmall, 600);
      expect(refined.tabletNormal, 768);
      expect(refined.tabletLarge, 850);
      expect(refined.tabletExtraLarge, 900);
      expect(refined.desktopSmall, 950);
      expect(refined.desktopNormal, 1920);
      expect(refined.desktopLarge, 3840);
      expect(refined.desktopExtraLarge, 4096);
    });

    test('custom values and toString', () {
      const refined = RefinedBreakpoints(
        mobileSmall: 100,
        mobileNormal: 200,
        mobileLarge: 300,
        mobileExtraLarge: 400,
        tabletSmall: 500,
        tabletNormal: 600,
        tabletLarge: 700,
        tabletExtraLarge: 800,
        desktopSmall: 900,
        desktopNormal: 1000,
        desktopLarge: 1100,
        desktopExtraLarge: 1200,
      );
      expect(refined.mobileSmall, 100);
      expect(refined.mobileNormal, 200);
      expect(refined.mobileLarge, 300);
      expect(refined.mobileExtraLarge, 400);
      expect(refined.tabletSmall, 500);
      expect(refined.tabletNormal, 600);
      expect(refined.tabletLarge, 700);
      expect(refined.tabletExtraLarge, 800);
      expect(refined.desktopSmall, 900);
      expect(refined.desktopNormal, 1000);
      expect(refined.desktopLarge, 1100);
      expect(refined.desktopExtraLarge, 1200);
      expect(refined.toString(), contains('Tablet: Small - 500'));
      expect(refined.toString(), contains('Mobile: Small - 100'));
    });
  });
}
