import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_builder/responsive_builder.dart';

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
      expect(breakpoints.large, 600);
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
      const custom = ScreenBreakpoints(small: 111, large: 999);
      config.setCustomBreakpoints(custom);
      expect(config.breakpoints.small, 111);
      expect(config.breakpoints.large, 999);
    });

    test('setCustomBreakpoints sets custom refined breakpoints', () {
      final config = ResponsiveSizingConfig.instance;
      const customRefined = RefinedBreakpoints(
        desktopExtraLarge: 1,
        desktopLarge: 2,
        desktopNormal: 3,
        desktopSmall: 4,
        tabletExtraLarge: 5,
        tabletLarge: 6,
        tabletNormal: 7,
        tabletSmall: 8,
        mobileExtraLarge: 9,
        mobileLarge: 10,
        mobileNormal: 11,
        mobileSmall: 12,
      );
      config.setCustomBreakpoints(null,
          customRefinedBreakpoints: customRefined);
      final refined = config.refinedBreakpoints;
      expect(refined.desktopExtraLarge, 1);
      expect(refined.desktopLarge, 2);
      expect(refined.desktopNormal, 3);
      expect(refined.desktopSmall, 4);
      expect(refined.tabletExtraLarge, 5);
      expect(refined.tabletLarge, 6);
      expect(refined.tabletNormal, 7);
      expect(refined.tabletSmall, 8);
      expect(refined.mobileExtraLarge, 9);
      expect(refined.mobileLarge, 10);
      expect(refined.mobileNormal, 11);
      expect(refined.mobileSmall, 12);
    });
  });
}
