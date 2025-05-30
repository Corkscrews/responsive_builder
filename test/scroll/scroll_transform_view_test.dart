import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_builder/src/scroll/scroll_transform_item.dart';
import 'package:responsive_builder/src/scroll/scroll_transform_view.dart';

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
  testWidgets('ScrollTransformView passes offset to children and updates on scroll',
      (WidgetTester tester) async {
    // Widget under test with a ScrollTransformItem inside the ScrollTransformView
    final testWidget = MaterialApp(
      home: Scaffold(
        body: ScrollTransformView(
          children: [
            ScrollTransformItem(
              offsetBuilder: (offset) => Offset(offset / 5, 0),
              scaleBuilder: (offset) => 1 + offset / 200,
              builder: (offset) => Text('Offset: $offset', key: ValueKey('offsetText')),
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
    final offsetValue = double.tryParse(textWidget.data!.replaceAll('Offset: ', ''));

    // Assert the offset was updated due to scroll
    expect(offsetValue, greaterThan(0.0));
  });
}
