import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_builder2/src/scroll/scroll_transform_item.dart';
import 'package:responsive_builder2/src/scroll/scroll_transform_view.dart';

class DummyScrollTransformItem extends ScrollTransformItem {
  DummyScrollTransformItem({
    required Offset Function(double) offsetBuilder,
    required double Function(double) scaleBuilder,
    required Widget Function(double) builder,
  }) : super(
          offsetBuilder: offsetBuilder,
          scaleBuilder: scaleBuilder,
          builder: builder,
        );
}

void main() {
  testWidgets(
      'ScrollTransformView passes offset to children and updates on scroll',
      (WidgetTester tester) async {
    // Widget under test with a ScrollTransformItem inside the ScrollTransformView
    final testWidget = MaterialApp(
      home: Scaffold(
        body: ScrollTransformView(
          children: [
            ScrollTransformItem(
              offsetBuilder: (offset) => Offset(offset / 5, 0),
              scaleBuilder: (offset) => 1 + offset / 200,
              builder: (offset) =>
                  Text('Offset: $offset', key: ValueKey('offsetText')),
            ),
            // Add spacing to enable scrolling
            ScrollTransformItem(
              offsetBuilder: (_) => Offset.zero,
              scaleBuilder: (_) => 1.0,
              builder: (_) => SizedBox(height: 1000),
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(testWidget);

    // Scroll the view
    final scrollable = find.byType(Scrollable);
    await tester.drag(scrollable, const Offset(0, -200));
    await tester.pumpAndSettle();

    // Find and verify updated child text after scroll
    final textFinder = find.byKey(ValueKey('offsetText'));
    expect(textFinder, findsOneWidget);

    final textWidget = tester.widget<Text>(textFinder);
    final offsetValue =
        double.tryParse(textWidget.data!.replaceAll('Offset: ', ''));

    // Assert the offset was updated due to scroll
    expect(offsetValue, greaterThan(0.0));
  });

  testWidgets(
      'ScrollTransformView disposes ScrollController without errors',
      (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ScrollTransformView(
            children: [
              ScrollTransformItem(
                builder: (offset) => SizedBox(height: 500),
              ),
            ],
          ),
        ),
      ),
    );

    // Pump a frame to settle
    await tester.pumpAndSettle();

    // Remove the widget from the tree, triggering dispose
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // If no error is thrown, disposal was successful
    // Flutter test framework will catch "A ScrollController was used after
    // being disposed" errors automatically
  });

  testWidgets(
      'ScrollTransformView handles multiple children with different transforms',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ScrollTransformView(
            children: [
              ScrollTransformItem(
                offsetBuilder: (offset) => Offset(offset, 0),
                builder: (offset) =>
                    Text('Item1: $offset', key: ValueKey('item1')),
              ),
              ScrollTransformItem(
                offsetBuilder: (offset) => Offset(0, offset),
                scaleBuilder: (offset) => 1 + offset / 1000,
                builder: (offset) =>
                    Text('Item2: $offset', key: ValueKey('item2')),
              ),
              ScrollTransformItem(
                builder: (_) => SizedBox(height: 1000),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(ValueKey('item1')), findsOneWidget);
    expect(find.byKey(ValueKey('item2')), findsOneWidget);
  });
}
