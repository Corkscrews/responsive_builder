import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_builder2/responsive_builder2.dart';

void main() {
  group('getDeviceType-Defaults', () {
    test('When on device with width between 600 and 300 should return mobile',
        () async {
      final screenType = getDeviceType(Size(599, 800), null, false);
      // ignore: deprecated_member_use_from_same_package
      expect(screenType.ordinal, DeviceScreenType.mobile.ordinal);
      expect(screenType, DeviceScreenType.phone);
    });

    test('When on device with width between 600 and 950 should return tablet',
        () async {
      final screenType = getDeviceType(Size(949, 1200), null, false);
      expect(screenType, DeviceScreenType.tablet);
    });

    test('When on device with width higher than 950 should return desktop',
        () async {
      final screenType = getDeviceType(Size(1000, 1200), null, true);
      expect(screenType, DeviceScreenType.desktop);
    });

    test('When on device with width lower than 300 should return watch',
        () async {
      final screenType = getDeviceType(Size(299, 1200), null, false);
      expect(screenType, DeviceScreenType.watch);
    });
  });

  group('getDeviceType-Custom Breakpoint', () {
    test(
        'given break point with desktop at 1200 and width at 1201 should return desktop',
        () {
      final breakPoint = ScreenBreakpoints(small: 300, normal: 550, large: 1200);
      final screenType = getDeviceType(Size(1201, 1400), breakPoint);
      expect(screenType, DeviceScreenType.desktop);
    });

    test(
        'given break point with tablet at 550 and width at 1199 should return tablet',
        () {
      final breakPoint = ScreenBreakpoints(small: 300, normal: 550, large: 1200);
      final screenType = getDeviceType(Size(1199, 1400), breakPoint, false);
      expect(screenType, DeviceScreenType.tablet);
    });

    test(
        'given break point with watch at 150 and width at 149 should return watch',
        () {
      final breakPoint = ScreenBreakpoints(small: 150, normal: 550, large: 1200);
      final screenType = getDeviceType(Size(149, 340), breakPoint);
      expect(screenType, DeviceScreenType.watch);
    });

    test(
        'given break point with desktop 1200, tablet 550, should return mobile if width is under 550 above 150',
        () {
      final breakPoint = ScreenBreakpoints(small: 150, normal: 550, large: 1200);
      final screenType = getDeviceType(Size(549, 800), breakPoint);
      // ignore: deprecated_member_use_from_same_package
      expect(screenType.ordinal, DeviceScreenType.mobile.ordinal);
      expect(screenType, DeviceScreenType.phone);
    });
  });

  group('getDeviceType-Config set', () {
    tearDown(() => ResponsiveSizingConfig.instance.setCustomBreakpoints(null));

    test(
        'When global config desktop set to 800, should return desktop when width is 801',
        () {
      ResponsiveSizingConfig.instance
          .setCustomBreakpoints(ScreenBreakpoints(small: 200, normal: 600, large: 800));

      final screenType = getDeviceType(Size(801, 1000));
      expect(screenType, DeviceScreenType.desktop);
    });
    test(
        'When global config tablet set to 550, should return tablet when width is 799',
        () {
      ResponsiveSizingConfig.instance
          .setCustomBreakpoints(ScreenBreakpoints(small: 200, normal: 550, large: 1000));

      final screenType = getDeviceType(Size(799, 1000), null, false);
      expect(screenType, DeviceScreenType.tablet);
    });
    test(
        'When global config normal set to 550, should return phone when width is 400',
        () {
      ResponsiveSizingConfig.instance
          .setCustomBreakpoints(ScreenBreakpoints(small: 200, normal: 550, large: 1000));

      final screenType = getDeviceType(Size(400, 1000), null, false);
      expect(screenType, DeviceScreenType.phone);
    });

    test(
        'When global config watch set to 200, should return watch when width is 199',
        () {
      ResponsiveSizingConfig.instance
          .setCustomBreakpoints(ScreenBreakpoints(small: 200, normal: 550, large: 1000));

      final screenType = getDeviceType(Size(199, 1000), null, false);
      expect(screenType, DeviceScreenType.watch);
    });
  });

  group('getDeviceType-Config+Breakpoint', () {
    tearDown(() => ResponsiveSizingConfig.instance.setCustomBreakpoints(null));
    test(
        'When global config desktop set to 1000, should return desktop when custom breakpoint desktop is 800 and width is 801',
        () {
      ResponsiveSizingConfig.instance
          .setCustomBreakpoints(ScreenBreakpoints(small: 200, normal: 600, large: 1000));
      final breakPoint = ScreenBreakpoints(small: 200, normal: 500, large: 750);
      final screenType = getDeviceType(Size(801, 1000), breakPoint);
      expect(screenType, DeviceScreenType.desktop);
    });
    test(
        'When global config tablet set to 600, should return tablet when custom breakpoint tablet is 800 and width is 801',
        () {
      ResponsiveSizingConfig.instance
          .setCustomBreakpoints(ScreenBreakpoints(small: 200, normal: 600, large: 1000));
      final breakPoint = ScreenBreakpoints(small: 200, normal: 800, large: 1200);
      final screenType = getDeviceType(Size(801, 1000), breakPoint, false);
      expect(screenType, DeviceScreenType.tablet);
    });
    test(
        'When global config is set tablet 600, desktop 800, should return mobile if custom breakpoint has range of 200, 300 and width is 201',
        () {
      ResponsiveSizingConfig.instance
          .setCustomBreakpoints(ScreenBreakpoints(small: 200, normal: 600, large: 1000));
      final breakPoint = ScreenBreakpoints(small: 200, normal: 250, large: 300);
      final screenType = getDeviceType(Size(201, 500), breakPoint);
      // ignore: deprecated_member_use_from_same_package
      expect(screenType.ordinal, DeviceScreenType.mobile.ordinal);
      expect(screenType, DeviceScreenType.phone);
    });
    test(
        'When global config watch set to 200, should return watch if custom breakpoint watch is 400 and width is 399',
        () {
      ResponsiveSizingConfig.instance
          .setCustomBreakpoints(ScreenBreakpoints(small: 200, normal: 600, large: 1000));
      final breakPoint = ScreenBreakpoints(small: 400, normal: 700, large: 800);
      final screenType = getDeviceType(Size(399, 1000), breakPoint);
      expect(screenType, DeviceScreenType.watch);
    });
  });

  group('getRefinedSize - Custom break points -', () {
    tearDown(() => ResponsiveSizingConfig.instance.setCustomBreakpoints(null));

    test(
        'When called with mobile size in small range, should return RefinedSize.small',
        () {
      ResponsiveSizingConfig.instance
          .setCustomBreakpoints(ScreenBreakpoints(small: 200, normal: 600, large: 1000));
      final breakPoint = RefinedBreakpoints(
        mobileSmall: 300,
        mobileNormal: 370,
        mobileLarge: 440,
        mobileExtraLarge: 520,
      );
      final refinedSize = getRefinedSize(
        Size(301, 1000),
        refinedBreakpoint: breakPoint,
        isWebOrDesktop: true,
      );
      expect(refinedSize, RefinedSize.small);
    });

    test(
        'When called with mobile size in normal range, should return RefinedSize.normal',
        () {
      ResponsiveSizingConfig.instance
          .setCustomBreakpoints(ScreenBreakpoints(small: 200, normal: 600, large: 1000));
      final breakPoint = RefinedBreakpoints(
        mobileSmall: 300,
        mobileNormal: 370,
        mobileLarge: 440,
        mobileExtraLarge: 520,
      );
      final refinedSize = getRefinedSize(
        Size(371, 1000),
        refinedBreakpoint: breakPoint,
        isWebOrDesktop: true,
      );
      expect(refinedSize, RefinedSize.normal);
    });

    test(
        'When called with mobile size in large range, should return RefinedSize.large',
        () {
      ResponsiveSizingConfig.instance
          .setCustomBreakpoints(ScreenBreakpoints(small: 200, normal: 600, large: 1000));
      final breakPoint = RefinedBreakpoints(
        mobileSmall: 300,
        mobileNormal: 370,
        mobileLarge: 440,
        mobileExtraLarge: 520,
      );
      final refinedSize = getRefinedSize(
        Size(441, 1000),
        refinedBreakpoint: breakPoint,
        isWebOrDesktop: true,
      );
      expect(refinedSize, RefinedSize.large);
    });

    test(
        'When called with mobile size in extraLarge range, should return RefinedSize.extraLarge',
        () {
      ResponsiveSizingConfig.instance
          .setCustomBreakpoints(ScreenBreakpoints(small: 200, normal: 600, large: 1000));
      final breakPoint = RefinedBreakpoints(
        mobileSmall: 300,
        mobileNormal: 370,
        mobileLarge: 440,
        mobileExtraLarge: 520,
      );
      final refinedSize = getRefinedSize(
        Size(521, 1000),
        refinedBreakpoint: breakPoint,
        isWebOrDesktop: true,
      );
      expect(refinedSize, RefinedSize.extraLarge);
    });

    test(
        'When called with desktop size in small range, should return RefinedSize.small',
        () {
      ResponsiveSizingConfig.instance
          .setCustomBreakpoints(ScreenBreakpoints(small: 200, normal: 600, large: 1000));
      final breakPoint = RefinedBreakpoints(
          tabletSmall: 850,
          tabletNormal: 900,
          tabletLarge: 950,
          tabletExtraLarge: 1000);
      final refinedSize = getRefinedSize(
        Size(851, 1000),
        refinedBreakpoint: breakPoint,
        isWebOrDesktop: true,
      );
      expect(refinedSize, RefinedSize.small);
    });

    test(
        'When called with desktop size in normal range, should return RefinedSize.normal',
        () {
      ResponsiveSizingConfig.instance
          .setCustomBreakpoints(ScreenBreakpoints(small: 200, normal: 600, large: 1000));
      final breakPoint = RefinedBreakpoints(
          tabletSmall: 850,
          tabletNormal: 900,
          tabletLarge: 950,
          tabletExtraLarge: 1000);
      final refinedSize = getRefinedSize(
        Size(901, 1000),
        refinedBreakpoint: breakPoint,
        isWebOrDesktop: false,
      );
      expect(refinedSize, RefinedSize.normal);
    });

    test(
        'When called with desktop size in large range, should return RefinedSize.large',
        () {
      ResponsiveSizingConfig.instance
          .setCustomBreakpoints(ScreenBreakpoints(small: 200, normal: 600, large: 1000));
      final breakPoint = RefinedBreakpoints(
          tabletSmall: 850,
          tabletNormal: 900,
          tabletLarge: 950,
          tabletExtraLarge: 1000);
      final refinedSize = getRefinedSize(
        Size(951, 1000),
        refinedBreakpoint: breakPoint,
        isWebOrDesktop: false,
      );
      expect(refinedSize, RefinedSize.large);
    });

    test(
        'When called with desktop size in extraLarge range, should return RefinedSize.extraLarge',
        () {
      ResponsiveSizingConfig.instance
          .setCustomBreakpoints(ScreenBreakpoints(small: 200, normal: 600, large: 1000));
      final breakPoint = RefinedBreakpoints(
          tabletSmall: 850,
          tabletNormal: 900,
          tabletLarge: 950,
          tabletExtraLarge: 1000);
      final refinedSize = getRefinedSize(
        Size(1001, 1000),
        refinedBreakpoint: breakPoint,
        isWebOrDesktop: false,
      );
      expect(refinedSize, RefinedSize.extraLarge);
    });
  });

  group('getRefinedSize -', () {
    setUp(() => ResponsiveSizingConfig.instance.setCustomBreakpoints(null));
    test(
        'When called with desktop size in extra large range, should return RefinedSize.extraLarge',
        () {
      final refinedSize =
          getRefinedSize(Size(4097, 1000), isWebOrDesktop: true);
      expect(refinedSize, RefinedSize.extraLarge);
    });
    test(
        'When called with desktop size in large range, should return RefinedSize.large',
        () {
      final refinedSize =
          getRefinedSize(Size(3840, 1000), isWebOrDesktop: true);
      expect(refinedSize, RefinedSize.large);
    });
    test(
        'When called with desktop size in normal range, should return RefinedSize.normal',
        () {
      final refinedSize =
          getRefinedSize(Size(1921, 1000), isWebOrDesktop: true);
      expect(refinedSize, RefinedSize.normal);
    });

    test(
        'When called with tablet size in extra large range, should return RefinedSize.extraLarge',
        () {
      final refinedSize =
          getRefinedSize(Size(901, 1000), isWebOrDesktop: false);
      expect(refinedSize, RefinedSize.extraLarge);
    });
    test(
        'When called with tablet size in large range, should return RefinedSize.large',
        () {
      final refinedSize =
          getRefinedSize(Size(851, 1000), isWebOrDesktop: false);
      expect(refinedSize, RefinedSize.large);
    });
    test(
        'When called with tablet size in normal range, should return RefinedSize.normal',
        () {
      final refinedSize =
          getRefinedSize(Size(769, 1000), isWebOrDesktop: false);
      expect(refinedSize, RefinedSize.normal);
    });
  });

  group('getDeviceType-Boundary values', () {
    test('Should return watch when width is exactly at small breakpoint boundary (299)',
        () {
      final screenType = getDeviceType(Size(299, 800), null, false);
      expect(screenType, DeviceScreenType.watch);
    });

    test('Should return phone when width is exactly at small breakpoint (300)',
        () {
      final screenType = getDeviceType(Size(300, 800), null, false);
      expect(screenType, DeviceScreenType.phone);
    });

    test('Should return phone when width is just below normal breakpoint (599)',
        () {
      final screenType = getDeviceType(Size(599, 800), null, false);
      expect(screenType, DeviceScreenType.phone);
    });

    test('Should return tablet when width is exactly at normal breakpoint (600)',
        () {
      final screenType = getDeviceType(Size(600, 800), null, false);
      expect(screenType, DeviceScreenType.tablet);
    });

    test('Should return tablet when width is just below large breakpoint (949)',
        () {
      final screenType = getDeviceType(Size(949, 800), null, false);
      expect(screenType, DeviceScreenType.tablet);
    });

    test('Should return desktop when width is exactly at large breakpoint (950) on desktop',
        () {
      final screenType = getDeviceType(Size(950, 800), null, true);
      expect(screenType, DeviceScreenType.desktop);
    });

    test('Should return tablet when width is exactly at large breakpoint (950) on mobile',
        () {
      final screenType = getDeviceType(Size(950, 800), null, false);
      expect(screenType, DeviceScreenType.tablet);
    });
  });

  group('getDeviceType-Edge cases', () {
    test('Should handle zero-width screen', () {
      final screenType = getDeviceType(Size(0, 0), null, false);
      expect(screenType, DeviceScreenType.watch);
    });

    test('Should handle very large screen dimensions', () {
      final screenType = getDeviceType(Size(100000, 100000), null, true);
      expect(screenType, DeviceScreenType.desktop);
    });

    test('Should use shortestSide on mobile platform', () {
      // On mobile (isWebOrDesktop=false), deviceWidth = size.shortestSide
      // Size(1200, 400).shortestSide = 400, which is phone range
      final screenType = getDeviceType(Size(1200, 400), null, false);
      expect(screenType, DeviceScreenType.phone);
    });

    test('Should use width on desktop platform', () {
      // On desktop (isWebOrDesktop=true), deviceWidth = size.width = 1200
      final screenType = getDeviceType(Size(1200, 400), null, true);
      expect(screenType, DeviceScreenType.desktop);
    });
  });

  group('getRefinedSize - Default mobile sizes', () {
    setUp(() => ResponsiveSizingConfig.instance.setCustomBreakpoints(null));

    test('Should return small for mobile in small range', () {
      // mobileSmall = 320, mobileNormal = 375
      // Width 320, shortestSide = 320 (since 320 < 800)
      final refinedSize =
          getRefinedSize(Size(320, 800), isWebOrDesktop: false);
      expect(refinedSize, RefinedSize.small);
    });

    test('Should return normal for mobile in normal range', () {
      // mobileNormal = 375, mobileLarge = 414
      final refinedSize =
          getRefinedSize(Size(375, 800), isWebOrDesktop: false);
      expect(refinedSize, RefinedSize.normal);
    });

    test('Should return large for mobile in large range', () {
      // mobileLarge = 414, mobileExtraLarge = 480
      final refinedSize =
          getRefinedSize(Size(414, 800), isWebOrDesktop: false);
      expect(refinedSize, RefinedSize.large);
    });

    test('Should return extraLarge for mobile in extraLarge range', () {
      // mobileExtraLarge = 480
      final refinedSize =
          getRefinedSize(Size(480, 800), isWebOrDesktop: false);
      expect(refinedSize, RefinedSize.extraLarge);
    });
  });

  group('getRefinedSize - Default desktop small', () {
    setUp(() => ResponsiveSizingConfig.instance.setCustomBreakpoints(null));

    test('Should return small for desktop in small range', () {
      // desktopSmall = 950, desktopNormal = 1920
      // On desktop, deviceWidth = size.width = 1000
      final refinedSize =
          getRefinedSize(Size(1000, 800), isWebOrDesktop: true);
      expect(refinedSize, RefinedSize.small);
    });
  });

  group('getRefinedSize - Watch', () {
    setUp(() => ResponsiveSizingConfig.instance.setCustomBreakpoints(null));

    test('Should return small for watch with default breakpoints', () {
      // Watch is width < 300 (shortestSide for mobile)
      final refinedSize =
          getRefinedSize(Size(200, 200), isWebOrDesktop: false);
      expect(refinedSize, RefinedSize.small);
    });
  });

  group('getValueForScreenType-Fallback chains', () {
    testWidgets('desktop falls back to tablet when no desktop value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(1200, 800)),
            child: Builder(
              builder: (context) {
                expect(
                  getValueForScreenType(
                    context: context,
                    isWebOrDesktop: true,
                    mobile: 'mobile',
                    tablet: 'tablet',
                  ),
                  'tablet',
                );
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('desktop falls back to mobile when no desktop or tablet value',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(1200, 800)),
            child: Builder(
              builder: (context) {
                expect(
                  getValueForScreenType(
                    context: context,
                    isWebOrDesktop: true,
                    mobile: 'mobile',
                  ),
                  'mobile',
                );
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('tablet falls back to mobile when no tablet value',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(700, 800)),
            child: Builder(
              builder: (context) {
                expect(
                  getValueForScreenType(
                    context: context,
                    isWebOrDesktop: false,
                    mobile: 'mobile',
                  ),
                  'mobile',
                );
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('watch falls back to mobile when no watch value',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(200, 800)),
            child: Builder(
              builder: (context) {
                expect(
                  getValueForScreenType(
                    context: context,
                    isWebOrDesktop: false,
                    mobile: 'mobile',
                  ),
                  'mobile',
                );
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });
  });

  group('getValueForRefinedSize-Fallback chains', () {
    testWidgets('extraLarge falls back to large when no extraLarge value',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(4100, 1000)),
            child: Builder(
              builder: (context) {
                expect(
                  getValueForRefinedSize(
                    context: context,
                    normal: 'normal',
                    large: 'large',
                  ),
                  'large',
                );
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('extraLarge falls back to normal when no extraLarge or large value',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(4100, 1000)),
            child: Builder(
              builder: (context) {
                expect(
                  getValueForRefinedSize(
                    context: context,
                    normal: 'normal',
                  ),
                  'normal',
                );
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('large falls back to normal when no large value',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(3850, 1000)),
            child: Builder(
              builder: (context) {
                expect(
                  getValueForRefinedSize(
                    context: context,
                    normal: 'normal',
                  ),
                  'normal',
                );
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('small falls back to normal when no small value',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(1000, 1000)),
            child: Builder(
              builder: (context) {
                expect(
                  getValueForRefinedSize(
                    context: context,
                    normal: 'normal',
                  ),
                  'normal',
                );
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });
  });

  group('getValueForScreenType', () {
    testWidgets('returns correct value for each device type', (tester) async {
      // Helper to test with a given size and isWebOrDesktop flag
      Future<void> testWithSize({
        required Size size,
        required bool isWebOrDesktop,
        required String expected,
      }) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(size: size),
              child: Builder(
                builder: (context) {
                  expect(
                    getValueForScreenType(
                      context: context,
                      isWebOrDesktop: isWebOrDesktop,
                      mobile: 'mobile',
                      tablet: 'tablet',
                      desktop: 'desktop',
                      watch: 'watch',
                    ),
                    expected,
                  );
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      }

      // Simulate mobile (width < 600)
      await testWithSize(
        size: const Size(375, 800),
        isWebOrDesktop: false,
        expected: 'mobile',
      );

      // Simulate tablet (width >= 600 && < 950)
      await testWithSize(
        size: const Size(700, 800),
        isWebOrDesktop: false,
        expected: 'tablet',
      );

      // Simulate desktop (width >= 950)
      await testWithSize(
        size: const Size(1200, 800),
        isWebOrDesktop: true,
        expected: 'desktop',
      );

      // Simulate watch (width < 300)
      await testWithSize(
        size: const Size(200, 800),
        isWebOrDesktop: false,
        expected: 'watch',
      );
    });
  });

  group('getValueForRefinedSize', () {
    testWidgets('returns correct value for each refined size', (tester) async {
      Future<void> testWithSize({
        required WidgetTester tester,
        required Size size,
        required String expected,
        String? normal,
        String? large,
        String? extraLarge,
        String? small,
      }) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(size: size),
              child: Builder(
                builder: (context) {
                  expect(
                    getValueForRefinedSize(
                      context: context,
                      normal: normal ?? 'normal',
                      large: large,
                      extraLarge: extraLarge,
                      small: small,
                    ),
                    expected,
                  );
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      }

      await testWithSize(
        tester: tester,
        size: const Size(4100, 1000),
        expected: 'extraLarge',
        extraLarge: 'extraLarge',
        large: 'large',
      );
      await testWithSize(
        tester: tester,
        size: const Size(3850, 1000),
        expected: 'large',
        large: 'large',
        normal: 'normal',
      );
      await testWithSize(
        tester: tester,
        size: const Size(2000, 1000),
        expected: 'normal',
        normal: 'normal',
      );
      await testWithSize(
        tester: tester,
        size: const Size(1000, 1000),
        expected: 'small',
        small: 'small',
      );
      await testWithSize(
        tester: tester,
        size: const Size(4100, 1000),
        expected: 'normal',
        normal: 'normal',
      );
    });
  });

  group('ScreenTypeValueBuilder', () {
    testWidgets('getValueForType returns correct value', (tester) async {
      Future<void> testWithSize({
        required Size size,
        required bool isWebOrDesktop,
        required String expected,
      }) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(size: size),
              child: Builder(
                builder: (context) {
                  final builder = ScreenTypeValueBuilder<String>();
                  expect(
                    // ignore: deprecated_member_use_from_same_package
                    builder.getValueForType(
                      context: context,
                      isWebOrDesktop: isWebOrDesktop,
                      mobile: 'mobile',
                      tablet: 'tablet',
                      desktop: 'desktop',
                      watch: 'watch',
                    ),
                    expected,
                  );
                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      }

      // Simulate mobile (width < 600)
      await testWithSize(
        size: const Size(375, 800),
        isWebOrDesktop: false,
        expected: 'mobile',
      );

      // Simulate tablet (width >= 600 && < 950)
      await testWithSize(
        size: const Size(700, 800),
        isWebOrDesktop: false,
        expected: 'tablet',
      );

      // Simulate desktop (width >= 950)
      await testWithSize(
        size: const Size(1200, 800),
        isWebOrDesktop: true,
        expected: 'desktop',
      );

      // Simulate watch (width < 300)
      await testWithSize(
        size: const Size(200, 800),
        isWebOrDesktop: false,
        expected: 'watch',
      );
    });
  });
}
