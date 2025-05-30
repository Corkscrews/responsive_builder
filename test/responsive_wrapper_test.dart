import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_builder/src/responsive_wrapper.dart';
import 'package:flutter/material.dart';

void main() {
  group('ResponsiveAppExtensions', () {
    setUp(() {
      // Set up the ResponsiveAppUtil dimensions for extension tests
      ResponsiveAppUtil.width = 400;
      ResponsiveAppUtil.height = 800;
    });

    test('screenHeight returns correct percentage', () {
      expect(20.screenHeight, 160); // 20% of 800
      expect(50.screenHeight, 400); // 50% of 800
    });

    test('screenWidth returns correct percentage', () {
      expect(25.screenWidth, 100); // 25% of 400
      expect(100.screenWidth, 400); // 100% of 400
    });

    test('sh and sw are shorthand for screenHeight and screenWidth', () {
      expect(10.sh, 80); // 10% of 800
      expect(10.sw, 40); // 10% of 400
    });
  });

  group('ResponsiveAppUtil', () {
    test('setScreenSize sets width and height for portrait', () {
      final constraints = BoxConstraints(maxWidth: 300, maxHeight: 600);
      ResponsiveAppUtil.setScreenSize(constraints, Orientation.portrait);
      expect(ResponsiveAppUtil.width, 300);
      expect(ResponsiveAppUtil.height, 600);
    });

    test('setScreenSize sets width and height for landscape', () {
      final constraints = BoxConstraints(maxWidth: 300, maxHeight: 600);
      ResponsiveAppUtil.setScreenSize(constraints, Orientation.landscape);
      expect(ResponsiveAppUtil.width, 600);
      expect(ResponsiveAppUtil.height, 300);
    });
  });

  group('ResponsiveApp', () {
    testWidgets('builder is called and preferDesktop is set', (tester) async {
      bool builderCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveApp(
            preferDesktop: true,
            builder: (context) {
              builderCalled = true;
              return const Text('Hello');
            },
          ),
        ),
      );
      expect(find.text('Hello'), findsOneWidget);
      expect(builderCalled, isTrue);
      expect(ResponsiveAppUtil.preferDesktop, isTrue);
    });
  });
}
