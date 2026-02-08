// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_builder2/responsive_builder2.dart';
import 'package:flutter/material.dart';

void main() {
  group('ResponsiveBuilder', () {
    testWidgets('provides SizingInformation to builder', (tester) async {
      SizingInformation? info;
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveBuilder(
            builder: (context, sizingInformation) {
              info = sizingInformation;
              return const Text('RB');
            },
          ),
        ),
      );
      expect(find.text('RB'), findsOneWidget);
      expect(info, isNotNull);
      expect(info!.screenSize, isA<Size>());
    });
  });

  group('OrientationLayoutBuilder', () {
    testWidgets('calls portrait builder by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: OrientationLayoutBuilder(
            portrait: (_) => const Text('Portrait'),
          ),
        ),
      );
      expect(find.text('Portrait'), findsOneWidget);
    });

    testWidgets('calls landscape builder when orientation is landscape',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 400)),
            child: OrientationLayoutBuilder(
              portrait: (_) => const Text('Portrait'),
              landscape: (_) => const Text('Landscape'),
            ),
          ),
        ),
      );
      // The widget will use landscape if width > height
      expect(find.text('Landscape'), findsOneWidget);
    });

    testWidgets(
        'calls landscape builder when mode is landscape regardless of orientation',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
                size: Size(400, 800)), // Portrait orientation
            child: OrientationLayoutBuilder(
              mode: OrientationLayoutBuilderMode.landscape,
              portrait: (_) => const Text('Portrait'),
              landscape: (_) => const Text('Landscape'),
            ),
          ),
        ),
      );
      // Should use landscape builder even though orientation is portrait
      expect(find.text('Landscape'), findsOneWidget);
    });
  });

  group('ScreenTypeLayout.builder', () {
    testWidgets('shows mobile layout by default', (tester) async {
      // This test confirms that the fallback to mobile layout is working.
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenTypeLayout.builder(
            isWebOrDesktop: false,
            mobile: (_) => const Text('Mobile'),
          ),
        ),
      );
      expect(find.text('Mobile'), findsOneWidget);
    });

    testWidgets('shows watch layout when width is very small', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(200, 800)),
            child: ScreenTypeLayout.builder(
              isWebOrDesktop: false,
              watch: (_) => const Text('Watch'),
              mobile: (_) => const Text('Mobile'),
              tablet: (_) => const Text('Tablet'),
              desktop: (_) => const Text('Desktop'),
            ),
          ),
        ),
      );
      expect(find.text('Watch'), findsOneWidget);
    });

    testWidgets('shows mobile layout when width is in mobile range',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: ScreenTypeLayout.builder(
              isWebOrDesktop: false,
              watch: (_) => const Text('Watch'),
              mobile: (_) => const Text('Mobile'),
              tablet: (_) => const Text('Tablet'),
              desktop: (_) => const Text('Desktop'),
            ),
          ),
        ),
      );
      expect(find.text('Mobile'), findsOneWidget);
    });

    testWidgets('shows tablet layout when width is in tablet range',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(2064, 2752)),
            child: ScreenTypeLayout.builder(
              isWebOrDesktop: false,
              watch: (_) => const Text('Watch'),
              mobile: (_) => const Text('Mobile'),
              tablet: (_) => const Text('Tablet'),
              desktop: (_) => const Text('Desktop'),
            ),
          ),
        ),
      );
      expect(find.text('Tablet'), findsOneWidget);
    });

    testWidgets('shows desktop layout when width is in desktop range',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1200, 800)),
            child: ScreenTypeLayout.builder(
              isWebOrDesktop: true,
              watch: (_) => const Text('Watch'),
              mobile: (_) => const Text('Mobile'),
              tablet: (_) => const Text('Tablet'),
              desktop: (_) => const Text('Desktop'),
            ),
          ),
        ),
      );
      expect(find.text('Desktop'), findsOneWidget);
    });

    testWidgets(
        'shows desktop layout when preferDesktop is true and both mobile and desktop are supplied',
        (tester) async {
      // Set preferDesktop to true
      ResponsiveAppUtil.preferDesktop = true;
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: ScreenTypeLayout.builder(
              isWebOrDesktop: true,
              watch: (_) => const Text('Watch'),
              mobile: (_) => const Text('Mobile'),
              tablet: (_) => const Text('Tablet'),
              desktop: (_) => const Text('Desktop'),
            ),
          ),
        ),
      );
      expect(find.text('Desktop'), findsOneWidget);
      // Reset preferDesktop to false for other tests
      ResponsiveAppUtil.preferDesktop = false;
    });
  });

  group('ScreenTypeLayout.builder2', () {
    testWidgets('shows mobile layout by default', (tester) async {
      // This test confirms that the fallback to mobile layout is working.
      SizingInformation? info;
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenTypeLayout.builder2(
            isWebOrDesktop: false,
            phone: (_, sizing) {
              info = sizing;
              return const Text('Phone2');
            },
          ),
        ),
      );
      expect(find.text('Phone2'), findsOneWidget, reason: 'Phone2 not found');
      expect(info, isNotNull, reason: 'info is null');
      expect(info!.isTablet, isTrue, reason: 'info is not tablet');
    });

    testWidgets('shows watch layout when width is very small', (tester) async {
      SizingInformation? info;
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(200, 800)),
            child: ScreenTypeLayout.builder2(
              isWebOrDesktop: false,
              watch: (_, sizing) {
                info = sizing;
                return const Text('Watch2');
              },
              phone: (context, _) => const Text('Phone2'),
              tablet: (context, _) => const Text('Tablet2'),
              desktop: (context, _) => const Text('Desktop2'),
            ),
          ),
        ),
      );
      expect(find.text('Watch2'), findsOneWidget, reason: 'Watch2 not found');
      expect(info, isNotNull, reason: 'info is null');
      expect(info!.deviceScreenType.toString(), contains('watch'),
          reason: 'info is not watch');
    });

    testWidgets('shows mobile layout when width is in mobile range',
        (tester) async {
      SizingInformation? info;
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: ScreenTypeLayout.builder2(
              isWebOrDesktop: false,
              watch: (context, _) => const Text('Watch2'),
              phone: (_, sizing) {
                info = sizing;
                return const Text('Phone2');
              },
              tablet: (context, _) => const Text('Tablet2'),
              desktop: (context, _) => const Text('Desktop2'),
            ),
          ),
        ),
      );
      expect(find.text('Phone2'), findsOneWidget, reason: 'Phone2 not found');
      expect(info, isNotNull, reason: 'info is null');
      expect(info!.isPhone, isTrue, reason: 'info is not phone');
    });

    testWidgets('shows tablet layout when width is in tablet range',
        (tester) async {
      SizingInformation? info;
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(2064, 2752)),
            child: ScreenTypeLayout.builder2(
              isWebOrDesktop: false,
              watch: (context, _) => const Text('Watch2'),
              phone: (context, _) => const Text('Phone2'),
              tablet: (_, sizing) {
                info = sizing;
                return const Text('Tablet2');
              },
              desktop: (context, _) => const Text('Desktop2'),
            ),
          ),
        ),
      );
      expect(find.text('Tablet2'), findsOneWidget, reason: 'Tablet2 not found');
      expect(info, isNotNull, reason: 'info is null');
      expect(info!.isTablet, isTrue, reason: 'info is not tablet');
    });

    testWidgets('shows desktop layout when width is in desktop range',
        (tester) async {
      SizingInformation? info;
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1200, 800)),
            child: ScreenTypeLayout.builder2(
              isWebOrDesktop: true,
              watch: (context, _) => const Text('Watch2'),
              phone: (context, _) => const Text('Phone2'),
              tablet: (context, _) => const Text('Tablet2'),
              desktop: (_, sizing) {
                info = sizing;
                return const Text('Desktop2');
              },
            ),
          ),
        ),
      );
      expect(find.text('Desktop2'), findsOneWidget,
          reason: 'Desktop2 not found');
      expect(info, isNotNull, reason: 'info is null');
      expect(info!.isDesktop, isTrue, reason: 'info is not desktop');
    });

    testWidgets('shows tablet layout when width is in desktop range',
        (tester) async {
      SizingInformation? info;
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1200, 800)),
            child: ScreenTypeLayout.builder2(
              isWebOrDesktop: true,
              watch: (context, _) => const Text('Watch2'),
              phone: (context, _) => const Text('Phone2'),
              tablet: (_, sizing) {
                info = sizing;
                return const Text('Tablet2');
              },
            ),
          ),
        ),
      );
      expect(find.text('Tablet2'), findsOneWidget,
          reason: 'Desktop2 not found');
      expect(info, isNotNull, reason: 'info is null');
      expect(info!.isDesktop, isTrue, reason: 'info is not desktop');
    });

    testWidgets(
        'shows desktop layout when preferDesktop is true and both mobile and desktop are supplied',
        (tester) async {
      ResponsiveAppUtil.preferDesktop = true;
      SizingInformation? info;
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: ScreenTypeLayout.builder2(
              isWebOrDesktop: true,
              watch: (context, _) => const Text('Watch2'),
              phone: (context, _) => const Text('Phone2'),
              tablet: (context, _) => const Text('Tablet2'),
              desktop: (_, sizing) {
                info = sizing;
                return const Text('Desktop2');
              },
            ),
          ),
        ),
      );
      expect(find.text('Desktop2'), findsOneWidget,
          reason: 'Desktop2 not found');
      expect(info, isNotNull, reason: 'info is null');
      // Despite being a phone, it's rendering the desktop layout
      expect(info!.isDesktop, isFalse, reason: 'info is not desktop');
      expect(info!.isPhone, isTrue, reason: 'info is not phone');
      ResponsiveAppUtil.preferDesktop = false;
    });

    testWidgets(
        'shows desktop layout when preferDesktop is true and both mobile and desktop are supplied',
        (tester) async {
      ResponsiveAppUtil.preferDesktop = true;
      SizingInformation? info;
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: ScreenTypeLayout.builder2(
              isWebOrDesktop: true,
              phone: (_, sizing) {
                info = sizing;
                return const Text('Phone2');
              },
            ),
          ),
        ),
      );
      expect(find.text('Phone2'), findsOneWidget, reason: 'Phone2 not found');
      expect(info, isNotNull, reason: 'info is null');
      // Despite being a phone, it's rendering the desktop layout
      expect(info!.isDesktop, isFalse, reason: 'info is not desktop');
      expect(info!.isPhone, isTrue, reason: 'info is not phone');
      ResponsiveAppUtil.preferDesktop = false;
    });
  });

  group('ScreenTypeLayout (Deprecated)', () {
    testWidgets('shows mobile layout by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenTypeLayout(
            mobile: const Text('Mobile'),
          ),
        ),
      );
      expect(find.text('Mobile'), findsOneWidget);
    });

    testWidgets('shows watch layout when width is very small', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(200, 800)),
            child: ScreenTypeLayout(
              watch: const Text('Watch'),
              mobile: const Text('Mobile'),
              tablet: const Text('Tablet'),
              desktop: const Text('Desktop'),
            ),
          ),
        ),
      );
      expect(find.text('Watch'), findsOneWidget);
    });

    testWidgets('shows mobile layout when width is in mobile range',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: ScreenTypeLayout(
              watch: const Text('Watch'),
              mobile: const Text('Mobile'),
              tablet: const Text('Tablet'),
              desktop: const Text('Desktop'),
            ),
          ),
        ),
      );
      expect(find.text('Mobile'), findsOneWidget);
    });

    testWidgets('shows desktop layout when width is large', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1200, 800)),
            child: ScreenTypeLayout(
              watch: const Text('Watch'),
              mobile: const Text('Mobile'),
              tablet: const Text('Tablet'),
              desktop: const Text('Desktop'),
            ),
          ),
        ),
      );
      expect(find.text('Desktop'), findsOneWidget);
    });
  });

  group('ScreenTypeLayout.builder - crash paths', () {
    testWidgets(
        'shows desktop layout when only desktop is provided on desktop screen',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1200, 800)),
            child: ScreenTypeLayout.builder(
              isWebOrDesktop: true,
              desktop: (_) => const Text('Desktop'),
            ),
          ),
        ),
      );
      expect(find.text('Desktop'), findsOneWidget);
    });

    testWidgets(
        'shows desktop fallback when only desktop is provided on phone screen',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: ScreenTypeLayout.builder(
              isWebOrDesktop: false,
              desktop: (_) => const Text('Desktop'),
            ),
          ),
        ),
      );
      // With BUG-002/003 fix, should fall back to desktop as the only available builder
      expect(find.text('Desktop'), findsOneWidget);
    });

    testWidgets(
        'shows desktop fallback when only desktop is provided on watch screen',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(200, 800)),
            child: ScreenTypeLayout.builder(
              isWebOrDesktop: false,
              desktop: (_) => const Text('Desktop'),
            ),
          ),
        ),
      );
      // Should fall back to desktop as the only available builder
      expect(find.text('Desktop'), findsOneWidget);
    });
  });

  group('ScreenTypeLayout.builder2 - crash paths', () {
    testWidgets(
        'shows desktop fallback when only desktop is provided on phone screen',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: ScreenTypeLayout.builder2(
              isWebOrDesktop: false,
              desktop: (_, sizing) => const Text('Desktop2'),
            ),
          ),
        ),
      );
      expect(find.text('Desktop2'), findsOneWidget);
    });

    testWidgets(
        'shows desktop fallback when only desktop is provided on watch screen',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(200, 800)),
            child: ScreenTypeLayout.builder2(
              isWebOrDesktop: false,
              desktop: (_, sizing) => const Text('Desktop2'),
            ),
          ),
        ),
      );
      expect(find.text('Desktop2'), findsOneWidget);
    });
  });

  group('OrientationLayoutBuilder - additional coverage', () {
    testWidgets(
        'calls portrait builder when mode is portrait regardless of orientation',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
                size: Size(800, 400)), // Landscape orientation
            child: OrientationLayoutBuilder(
              mode: OrientationLayoutBuilderMode.portrait,
              portrait: (_) => const Text('Portrait'),
              landscape: (_) => const Text('Landscape'),
            ),
          ),
        ),
      );
      // Should use portrait builder even though orientation is landscape
      expect(find.text('Portrait'), findsOneWidget);
    });

    testWidgets(
        'calls portrait builder when landscape orientation but no landscape builder',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
                size: Size(800, 400)), // Landscape orientation
            child: OrientationLayoutBuilder(
              portrait: (_) => const Text('Portrait'),
              // No landscape builder provided
            ),
          ),
        ),
      );
      // Should fall back to portrait builder
      expect(find.text('Portrait'), findsOneWidget);
    });
  });

  group('ResponsiveBuilder - additional coverage', () {
    testWidgets('provides correct SizingInformation with custom breakpoints',
        (tester) async {
      SizingInformation? info;
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(500, 800)),
            child: ResponsiveBuilder(
              isWebOrDesktop: false,
              breakpoints: const ScreenBreakpoints(
                  small: 200, normal: 400, large: 800),
              builder: (context, sizingInformation) {
                info = sizingInformation;
                return const Text('Custom');
              },
            ),
          ),
        ),
      );
      expect(find.text('Custom'), findsOneWidget);
      expect(info, isNotNull);
      // Width 500 with breakpoints small=200, normal=400, large=800
      // shortestSide of (500, 800) = 500, and 400 <= 500 < 800 = tablet
      expect(info!.isTablet, isTrue);
    });

    testWidgets('screenSize matches MediaQuery size', (tester) async {
      SizingInformation? info;
      const testSize = Size(375, 812);
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: testSize),
            child: ResponsiveBuilder(
              isWebOrDesktop: false,
              builder: (context, sizingInformation) {
                info = sizingInformation;
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(info, isNotNull);
      expect(info!.screenSize, testSize);
    });
  });

  group('RefinedLayoutBuilder', () {
    testWidgets('shows normal layout by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RefinedLayoutBuilder(
            normal: (_) => const Text('Normal'),
          ),
        ),
      );
      expect(find.text('Normal'), findsOneWidget);
    });

    testWidgets('shows extraLarge layout when width is very large',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(4096, 1024)),
            child: RefinedLayoutBuilder(
              extraLarge: (_) => const Text('ExtraLarge'),
              normal: (_) => const Text('Normal'),
            ),
          ),
        ),
      );
      expect(find.text('ExtraLarge'), findsOneWidget);
    });

    testWidgets('shows large layout when width is large', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(2048, 1024)),
            child: RefinedLayoutBuilder(
              isWebOrDesktop: false,
              large: (_) => const Text('Large'),
              normal: (_) => const Text('Normal'),
            ),
          ),
        ),
      );
      expect(find.text('Large'), findsOneWidget);
    });

    testWidgets(
        'shows normal layout when width is large but no large builder is provided',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(2048, 1024)),
            child: RefinedLayoutBuilder(
              isWebOrDesktop: false,
              normal: (_) => const Text('Normal'),
            ),
          ),
        ),
      );
      expect(find.text('Normal'), findsOneWidget);
    });

    testWidgets('shows small layout when width is small', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(300, 600)),
            child: RefinedLayoutBuilder(
              small: (_) => const Text('Small'),
              normal: (_) => const Text('Normal'),
            ),
          ),
        ),
      );
      expect(find.text('Small'), findsOneWidget);
    });

    testWidgets('shows normal layout when width is large and large is null',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(414, 800)),
            child: RefinedLayoutBuilder(
              isWebOrDesktop: false,
              normal: (_) => const Text('Normal'),
            ),
          ),
        ),
      );
      expect(find.text('Normal'), findsOneWidget);
    });

    testWidgets(
        'shows normal layout when width is extra large and large is null',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(851, 512)),
            child: RefinedLayoutBuilder(
              isWebOrDesktop: false,
              normal: (_) => const Text('Normal'),
            ),
          ),
        ),
      );
      expect(find.text('Normal'), findsOneWidget);
    });
  });
}
