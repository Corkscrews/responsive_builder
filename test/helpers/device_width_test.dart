import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_builder2/src/helpers/device_width.dart';

void main() {
  group('deviceWidth', () {
    test('returns full width when isWebOrDesktop is true', () {
      final result = deviceWidth(Size(1200, 800), true);
      expect(result, 1200);
    });

    test('returns shortestSide when isWebOrDesktop is false', () {
      final result = deviceWidth(Size(1200, 800), false);
      expect(result, 800); // shortestSide of (1200, 800) is 800
    });

    test('returns shortestSide for portrait on mobile', () {
      final result = deviceWidth(Size(400, 800), false);
      expect(result, 400); // shortestSide of (400, 800) is 400
    });

    test('returns shortestSide for landscape on mobile', () {
      final result = deviceWidth(Size(800, 400), false);
      expect(result, 400); // shortestSide of (800, 400) is 400
    });

    test('returns width for landscape on desktop', () {
      final result = deviceWidth(Size(800, 400), true);
      expect(result, 800);
    });

    test('handles zero dimensions', () {
      final result = deviceWidth(Size(0, 0), false);
      expect(result, 0);
    });

    test('handles zero dimensions on desktop', () {
      final result = deviceWidth(Size(0, 0), true);
      expect(result, 0);
    });

    test('handles very large dimensions on mobile', () {
      final result = deviceWidth(Size(100000, 50000), false);
      expect(result, 50000); // shortestSide
    });

    test('handles very large dimensions on desktop', () {
      final result = deviceWidth(Size(100000, 50000), true);
      expect(result, 100000); // full width
    });

    test('handles equal width and height', () {
      final result = deviceWidth(Size(500, 500), false);
      expect(result, 500); // shortestSide == width == height
    });
  });
}
