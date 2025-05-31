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
  });

  group('ScreenTypeLayout', () {
    testWidgets('shows mobile layout by default', (tester) async {
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

    testWidgets('shows mobile layout when width is in mobile range', (tester) async {
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

    testWidgets('shows tablet layout when width is in tablet range', (tester) async {
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

    testWidgets('shows desktop layout when width is in desktop range', (tester) async {
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

    testWidgets('shows desktop layout when preferDesktop is true and both mobile and desktop are supplied', (tester) async {
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

  group('ScreenTypeLayout (Deprecated)', () {
    testWidgets('shows mobile layout by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          // ignore: deprecated_member_use_from_same_package
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
            // ignore: deprecated_member_use_from_same_package
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

    testWidgets('shows mobile layout when width is in mobile range', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            // ignore: deprecated_member_use_from_same_package
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
            // ignore: deprecated_member_use_from_same_package
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

    testWidgets('shows extraLarge layout when width is very large', (tester) async {
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

    testWidgets('shows normal layout when width is large but no large builder is provided', (tester) async {
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

    testWidgets('shows normal layout when width is large and large is null', (tester) async {
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
