import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_builder2/responsive_builder2.dart';

void main() {
  setUp(() {
    // Reset singleton state before each test
    ResponsiveSizingConfig.instance.setCustomBreakpoints(null);
  });

  group('ResponsiveSizingConfig', () {
    test('singleton instance returns the same object', () {
      final instance1 = ResponsiveSizingConfig.instance;
      final instance2 = ResponsiveSizingConfig.instance;
      expect(instance1, same(instance2));
    });

    test('default breakpoints are returned if not set', () {
      final config = ResponsiveSizingConfig.instance;
      final breakpoints = config.breakpoints;
      expect(breakpoints.small, 300);
      expect(breakpoints.large, 950);
      expect(breakpoints.normal, 600);
    });

    test('default refined breakpoints are returned if not set', () {
      final config = ResponsiveSizingConfig.instance;
      final refined = config.refinedBreakpoints;
      expect(refined.desktopExtraLarge, 4096);
      expect(refined.desktopLarge, 3840);
      expect(refined.desktopNormal, 1920);
      expect(refined.desktopSmall, 950);
      expect(refined.tabletExtraLarge, 900);
      expect(refined.tabletLarge, 850);
      expect(refined.tabletNormal, 768);
      expect(refined.tabletSmall, 600);
      expect(refined.mobileExtraLarge, 480);
      expect(refined.mobileLarge, 414);
      expect(refined.mobileNormal, 375);
      expect(refined.mobileSmall, 320);
    });

    test('setCustomBreakpoints sets custom breakpoints', () {
      final config = ResponsiveSizingConfig.instance;
      const custom = ScreenBreakpoints(small: 111, normal: 555, large: 999);
      config.setCustomBreakpoints(custom);
      expect(config.breakpoints.small, 111);
      expect(config.breakpoints.large, 999);
    });

    test('setCustomBreakpoints(null) resets screen breakpoints to defaults', () {
      final config = ResponsiveSizingConfig.instance;
      const custom = ScreenBreakpoints(small: 111, normal: 555, large: 999);
      config.setCustomBreakpoints(custom);
      expect(config.breakpoints.small, 111);

      // Calling with null should reset to defaults
      config.setCustomBreakpoints(null);
      expect(config.breakpoints.small, 300);
      expect(config.breakpoints.normal, 600);
      expect(config.breakpoints.large, 950);
    });

    test('setCustomBreakpoints(null) does NOT reset refined breakpoints', () {
      final config = ResponsiveSizingConfig.instance;
      const customRefined = RefinedBreakpoints(
        desktopExtraLarge: 5000,
        desktopLarge: 4000,
        desktopNormal: 2000,
      );
      config.setCustomBreakpoints(null,
          customRefinedBreakpoints: customRefined);
      expect(config.refinedBreakpoints.desktopExtraLarge, 5000);

      // Setting screen breakpoints to null should NOT reset refined breakpoints
      config.setCustomBreakpoints(null);
      expect(config.refinedBreakpoints.desktopExtraLarge, 5000,
          reason:
              'Refined breakpoints should not be reset when only screen breakpoints are set to null');
    });

    test('setCustomBreakpoints sets custom refined breakpoints', () {
      final config = ResponsiveSizingConfig.instance;
      const customRefined = RefinedBreakpoints(
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
      config.setCustomBreakpoints(null,
          customRefinedBreakpoints: customRefined);
      final refined = config.refinedBreakpoints;
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
    });
  });

  group('ScreenBreakpoints validation', () {
    test('throws assertion error when small >= normal', () {
      expect(
        () => ScreenBreakpoints(small: 600, normal: 300, large: 950),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws assertion error when normal >= large', () {
      expect(
        () => ScreenBreakpoints(small: 300, normal: 950, large: 600),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws assertion error when small is negative', () {
      expect(
        () => ScreenBreakpoints(small: -1, normal: 300, large: 600),
        throwsA(isA<AssertionError>()),
      );
    });

    test('accepts valid breakpoints with small == 0', () {
      // small = 0 is valid (disables watch category)
      final bp = ScreenBreakpoints(small: 0, normal: 300, large: 600);
      expect(bp.small, 0);
    });
  });

  group('RefinedBreakpoints validation', () {
    test('throws assertion error when mobile breakpoints are not ordered', () {
      expect(
        () => RefinedBreakpoints(
          mobileSmall: 400,
          mobileNormal: 300, // inverted
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws assertion error when tablet breakpoints are not ordered', () {
      expect(
        () => RefinedBreakpoints(
          tabletSmall: 800,
          tabletNormal: 700, // inverted
          tabletLarge: 850,
          tabletExtraLarge: 900,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws assertion error when desktop breakpoints are not ordered', () {
      expect(
        () => RefinedBreakpoints(
          desktopSmall: 2000,
          desktopNormal: 1920, // inverted
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('accepts valid refined breakpoints', () {
      final rb = RefinedBreakpoints(
        mobileSmall: 200,
        mobileNormal: 300,
        mobileLarge: 400,
        mobileExtraLarge: 500,
        tabletSmall: 600,
        tabletNormal: 700,
        tabletLarge: 800,
        tabletExtraLarge: 900,
        desktopSmall: 1000,
        desktopNormal: 1100,
        desktopLarge: 1200,
        desktopExtraLarge: 1300,
      );
      expect(rb.mobileSmall, 200);
      expect(rb.desktopExtraLarge, 1300);
    });
  });
}
