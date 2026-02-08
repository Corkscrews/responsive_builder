// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_builder2/src/sizing_information.dart';
import 'package:responsive_builder2/src/device_screen_type.dart';
import 'package:flutter/material.dart';

void main() {
  group('SizingInformation', () {
    test('constructor and property getters', () {
      final info = SizingInformation(
        deviceScreenType: DeviceScreenType.phone,
        refinedSize: RefinedSize.large,
        screenSize: const Size(400, 800),
        localWidgetSize: const Size(200, 400),
      );
      expect(info.deviceScreenType, DeviceScreenType.phone);
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

    test('isMobile is true when deviceScreenType == DeviceScreenType.mobile',
        () {
      final info = SizingInformation(
        deviceScreenType: DeviceScreenType.mobile,
        refinedSize: RefinedSize.normal,
        screenSize: const Size(375, 667),
        localWidgetSize: const Size(200, 400),
      );
      expect(info.deviceScreenType, DeviceScreenType.mobile);
      expect(info.isMobile, isTrue);
      expect(info.isPhone, isTrue);
      expect(info.isTablet, isFalse);
      expect(info.isDesktop, isFalse);
      expect(info.isWatch, isFalse);
    });

    test('isWatch is true when deviceScreenType is watch', () {
      final info = SizingInformation(
        deviceScreenType: DeviceScreenType.watch,
        refinedSize: RefinedSize.small,
        screenSize: const Size(200, 200),
        localWidgetSize: const Size(200, 200),
      );
      expect(info.isWatch, isTrue);
      expect(info.isPhone, isFalse);
      expect(info.isTablet, isFalse);
      expect(info.isDesktop, isFalse);
    });

    test('isPhone is true when deviceScreenType is phone', () {
      final info = SizingInformation(
        deviceScreenType: DeviceScreenType.phone,
        refinedSize: RefinedSize.normal,
        screenSize: const Size(375, 667),
        localWidgetSize: const Size(375, 667),
      );
      expect(info.isPhone, isTrue);
      expect(info.isMobile, isTrue);
      expect(info.isWatch, isFalse);
      expect(info.isTablet, isFalse);
      expect(info.isDesktop, isFalse);
    });

    test('isTablet is true when deviceScreenType is tablet', () {
      final info = SizingInformation(
        deviceScreenType: DeviceScreenType.tablet,
        refinedSize: RefinedSize.normal,
        screenSize: const Size(768, 1024),
        localWidgetSize: const Size(768, 1024),
      );
      expect(info.isTablet, isTrue);
      expect(info.isWatch, isFalse);
      expect(info.isPhone, isFalse);
      expect(info.isDesktop, isFalse);
    });

    test('isDesktop is true when deviceScreenType is desktop', () {
      final info = SizingInformation(
        deviceScreenType: DeviceScreenType.desktop,
        refinedSize: RefinedSize.extraLarge,
        screenSize: const Size(1920, 1080),
        localWidgetSize: const Size(1920, 1080),
      );
      expect(info.isDesktop, isTrue);
      expect(info.isWatch, isFalse);
      expect(info.isPhone, isFalse);
      expect(info.isTablet, isFalse);
    });

    test('isSmall is true when refinedSize is small', () {
      final info = SizingInformation(
        deviceScreenType: DeviceScreenType.phone,
        refinedSize: RefinedSize.small,
        screenSize: const Size(320, 568),
        localWidgetSize: const Size(320, 568),
      );
      expect(info.isSmall, isTrue);
      expect(info.isNormal, isFalse);
      expect(info.isLarge, isFalse);
      expect(info.isExtraLarge, isFalse);
    });

    test('isNormal is true when refinedSize is normal', () {
      final info = SizingInformation(
        deviceScreenType: DeviceScreenType.phone,
        refinedSize: RefinedSize.normal,
        screenSize: const Size(375, 667),
        localWidgetSize: const Size(375, 667),
      );
      expect(info.isNormal, isTrue);
      expect(info.isSmall, isFalse);
      expect(info.isLarge, isFalse);
      expect(info.isExtraLarge, isFalse);
    });

    test('isExtraLarge is true when refinedSize is extraLarge', () {
      final info = SizingInformation(
        deviceScreenType: DeviceScreenType.desktop,
        refinedSize: RefinedSize.extraLarge,
        screenSize: const Size(4096, 2160),
        localWidgetSize: const Size(4096, 2160),
      );
      expect(info.isExtraLarge, isTrue);
      expect(info.isSmall, isFalse);
      expect(info.isNormal, isFalse);
      expect(info.isLarge, isFalse);
    });

    test('equality: two identical instances are equal', () {
      final a = SizingInformation(
        deviceScreenType: DeviceScreenType.tablet,
        refinedSize: RefinedSize.large,
        screenSize: const Size(800, 1200),
        localWidgetSize: const Size(400, 600),
      );
      final b = SizingInformation(
        deviceScreenType: DeviceScreenType.tablet,
        refinedSize: RefinedSize.large,
        screenSize: const Size(800, 1200),
        localWidgetSize: const Size(400, 600),
      );
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('equality: same instance is equal to itself', () {
      final info = SizingInformation(
        deviceScreenType: DeviceScreenType.phone,
        refinedSize: RefinedSize.normal,
        screenSize: const Size(375, 667),
        localWidgetSize: const Size(375, 667),
      );
      expect(info, equals(info));
    });

    test('inequality: different deviceScreenType', () {
      final a = SizingInformation(
        deviceScreenType: DeviceScreenType.phone,
        refinedSize: RefinedSize.normal,
        screenSize: const Size(375, 667),
        localWidgetSize: const Size(375, 667),
      );
      final b = SizingInformation(
        deviceScreenType: DeviceScreenType.tablet,
        refinedSize: RefinedSize.normal,
        screenSize: const Size(375, 667),
        localWidgetSize: const Size(375, 667),
      );
      expect(a, isNot(equals(b)));
    });

    test('inequality: different refinedSize', () {
      final a = SizingInformation(
        deviceScreenType: DeviceScreenType.phone,
        refinedSize: RefinedSize.small,
        screenSize: const Size(375, 667),
        localWidgetSize: const Size(375, 667),
      );
      final b = SizingInformation(
        deviceScreenType: DeviceScreenType.phone,
        refinedSize: RefinedSize.large,
        screenSize: const Size(375, 667),
        localWidgetSize: const Size(375, 667),
      );
      expect(a, isNot(equals(b)));
    });

    test('inequality: different screenSize', () {
      final a = SizingInformation(
        deviceScreenType: DeviceScreenType.phone,
        refinedSize: RefinedSize.normal,
        screenSize: const Size(375, 667),
        localWidgetSize: const Size(375, 667),
      );
      final b = SizingInformation(
        deviceScreenType: DeviceScreenType.phone,
        refinedSize: RefinedSize.normal,
        screenSize: const Size(414, 736),
        localWidgetSize: const Size(375, 667),
      );
      expect(a, isNot(equals(b)));
    });

    test('inequality: different localWidgetSize', () {
      final a = SizingInformation(
        deviceScreenType: DeviceScreenType.phone,
        refinedSize: RefinedSize.normal,
        screenSize: const Size(375, 667),
        localWidgetSize: const Size(375, 667),
      );
      final b = SizingInformation(
        deviceScreenType: DeviceScreenType.phone,
        refinedSize: RefinedSize.normal,
        screenSize: const Size(375, 667),
        localWidgetSize: const Size(200, 400),
      );
      expect(a, isNot(equals(b)));
    });

    test('inequality: compared with a different type returns false', () {
      final info = SizingInformation(
        deviceScreenType: DeviceScreenType.phone,
        refinedSize: RefinedSize.normal,
        screenSize: const Size(375, 667),
        localWidgetSize: const Size(375, 667),
      );
      expect(info == 'not a SizingInformation', isFalse);
      expect(info == 42, isFalse);
    });

    test('hashCode is consistent for equal instances', () {
      final a = SizingInformation(
        deviceScreenType: DeviceScreenType.desktop,
        refinedSize: RefinedSize.extraLarge,
        screenSize: const Size(1920, 1080),
        localWidgetSize: const Size(960, 540),
      );
      final b = SizingInformation(
        deviceScreenType: DeviceScreenType.desktop,
        refinedSize: RefinedSize.extraLarge,
        screenSize: const Size(1920, 1080),
        localWidgetSize: const Size(960, 540),
      );
      expect(a.hashCode, equals(b.hashCode));
      // hashCode should be stable across multiple calls
      expect(a.hashCode, equals(a.hashCode));
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
      const breakpoints =
          ScreenBreakpoints(small: 300, normal: 700, large: 1200);
      expect(breakpoints.small, 300);
      expect(breakpoints.normal, 700);
      expect(breakpoints.large, 1200);
      expect(breakpoints.toString(), contains('Large: 1200'));
      expect(breakpoints.toString(), contains('Normal: 700'));
      expect(breakpoints.toString(), contains('Small: 300'));
    });

    test('toString returns exact format', () {
      const breakpoints =
          ScreenBreakpoints(small: 300, normal: 700, large: 1200);
      expect(
        breakpoints.toString(),
        'Large: 1200.0, Normal: 700.0, Small: 300.0',
      );
    });

    test('equality: two identical instances are equal', () {
      const a = ScreenBreakpoints(small: 300, normal: 700, large: 1200);
      const b = ScreenBreakpoints(small: 300, normal: 700, large: 1200);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('equality: same instance is equal to itself', () {
      const breakpoints =
          ScreenBreakpoints(small: 300, normal: 700, large: 1200);
      expect(breakpoints, equals(breakpoints));
    });

    test('inequality: different small value', () {
      const a = ScreenBreakpoints(small: 300, normal: 700, large: 1200);
      const b = ScreenBreakpoints(small: 350, normal: 700, large: 1200);
      expect(a, isNot(equals(b)));
    });

    test('inequality: different normal value', () {
      const a = ScreenBreakpoints(small: 300, normal: 700, large: 1200);
      const b = ScreenBreakpoints(small: 300, normal: 800, large: 1200);
      expect(a, isNot(equals(b)));
    });

    test('inequality: different large value', () {
      const a = ScreenBreakpoints(small: 300, normal: 700, large: 1200);
      const b = ScreenBreakpoints(small: 300, normal: 700, large: 1400);
      expect(a, isNot(equals(b)));
    });

    test('inequality: compared with a different type returns false', () {
      const breakpoints =
          ScreenBreakpoints(small: 300, normal: 700, large: 1200);
      expect(breakpoints == 'not a ScreenBreakpoints', isFalse);
    });

    test('hashCode is consistent for equal instances', () {
      const a = ScreenBreakpoints(small: 300, normal: 700, large: 1200);
      const b = ScreenBreakpoints(small: 300, normal: 700, large: 1200);
      expect(a.hashCode, equals(b.hashCode));
      expect(a.hashCode, equals(a.hashCode));
    });

    test('hashCode differs for different instances', () {
      const a = ScreenBreakpoints(small: 300, normal: 700, large: 1200);
      const b = ScreenBreakpoints(small: 400, normal: 800, large: 1600);
      expect(a.hashCode, isNot(equals(b.hashCode)));
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

    test('toString returns full format with all fields', () {
      const refined = RefinedBreakpoints();
      final str = refined.toString();
      expect(str, contains('Tablet: Small - 600.0'));
      expect(str, contains('Normal - 768.0'));
      expect(str, contains('Large - 850.0'));
      expect(str, contains('ExtraLarge - 900.0'));
      expect(str, contains('Mobile: Small - 320.0'));
      expect(str, contains('Normal - 375.0'));
      expect(str, contains('Large - 414.0'));
      expect(str, contains('ExtraLarge - 480.0'));
    });

    test('equality: two identical instances are equal', () {
      const a = RefinedBreakpoints();
      const b = RefinedBreakpoints();
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('equality: same instance is equal to itself', () {
      const refined = RefinedBreakpoints();
      expect(refined, equals(refined));
    });

    test('equality: two instances with same custom values are equal', () {
      const a = RefinedBreakpoints(
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
      const b = RefinedBreakpoints(
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
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('inequality: different mobileSmall', () {
      const a = RefinedBreakpoints(mobileSmall: 300);
      const b = RefinedBreakpoints(mobileSmall: 310);
      expect(a, isNot(equals(b)));
    });

    test('inequality: different mobileNormal', () {
      const a = RefinedBreakpoints(mobileNormal: 375);
      const b = RefinedBreakpoints(mobileNormal: 380);
      expect(a, isNot(equals(b)));
    });

    test('inequality: different mobileLarge', () {
      const a = RefinedBreakpoints(mobileLarge: 414);
      const b = RefinedBreakpoints(mobileLarge: 420);
      expect(a, isNot(equals(b)));
    });

    test('inequality: different mobileExtraLarge', () {
      const a = RefinedBreakpoints(mobileExtraLarge: 480);
      const b = RefinedBreakpoints(mobileExtraLarge: 500);
      expect(a, isNot(equals(b)));
    });

    test('inequality: different tabletSmall', () {
      const a = RefinedBreakpoints(tabletSmall: 600);
      const b = RefinedBreakpoints(tabletSmall: 610);
      expect(a, isNot(equals(b)));
    });

    test('inequality: different tabletNormal', () {
      const a = RefinedBreakpoints(tabletNormal: 768);
      const b = RefinedBreakpoints(tabletNormal: 780);
      expect(a, isNot(equals(b)));
    });

    test('inequality: different tabletLarge', () {
      const a = RefinedBreakpoints(tabletLarge: 850);
      const b = RefinedBreakpoints(tabletLarge: 860);
      expect(a, isNot(equals(b)));
    });

    test('inequality: different tabletExtraLarge', () {
      const a = RefinedBreakpoints(tabletExtraLarge: 900);
      const b = RefinedBreakpoints(tabletExtraLarge: 910);
      expect(a, isNot(equals(b)));
    });

    test('inequality: different desktopSmall', () {
      const a = RefinedBreakpoints(desktopSmall: 950);
      const b = RefinedBreakpoints(desktopSmall: 960);
      expect(a, isNot(equals(b)));
    });

    test('inequality: different desktopNormal', () {
      const a = RefinedBreakpoints(desktopNormal: 1920);
      const b = RefinedBreakpoints(desktopNormal: 1930);
      expect(a, isNot(equals(b)));
    });

    test('inequality: different desktopLarge', () {
      const a = RefinedBreakpoints(desktopLarge: 3840);
      const b = RefinedBreakpoints(desktopLarge: 3850);
      expect(a, isNot(equals(b)));
    });

    test('inequality: different desktopExtraLarge', () {
      const a = RefinedBreakpoints(desktopExtraLarge: 4096);
      const b = RefinedBreakpoints(desktopExtraLarge: 4100);
      expect(a, isNot(equals(b)));
    });

    test('inequality: compared with a different type returns false', () {
      const refined = RefinedBreakpoints();
      expect(refined == 'not a RefinedBreakpoints', isFalse);
    });

    test('hashCode is consistent for equal instances', () {
      const a = RefinedBreakpoints();
      const b = RefinedBreakpoints();
      expect(a.hashCode, equals(b.hashCode));
      expect(a.hashCode, equals(a.hashCode));
    });

    test('hashCode differs for different instances', () {
      const a = RefinedBreakpoints(mobileSmall: 300);
      const b = RefinedBreakpoints(mobileSmall: 310);
      expect(a.hashCode, isNot(equals(b.hashCode)));
    });
  });
}
