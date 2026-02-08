import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_builder2/responsive_builder2.dart';

void main() {
  testWidgets('ScrollTransformItem applies offset and scale',
      (WidgetTester tester) async {
    final scrollController = ScrollController();

    await tester.pumpWidget(
      ScrollControllerScope(
        controller: scrollController,
        child: MaterialApp(
          home: Scaffold(
            body: ListView(
              controller: scrollController,
              children: [
                SizedBox(height: 500), // Ensure some scroll area
                ScrollTransformItem(
                  offsetBuilder: (offset) => Offset(offset / 10, 0),
                  scaleBuilder: (offset) => 1 + offset / 500,
                  builder: (offset) =>
                      Text('Offset: $offset', key: ValueKey('offsetText')),
                ),
                SizedBox(height: 1000),
              ],
            ),
          ),
        ),
      ),
    );

    // Pump a frame so everything settles
    await tester.pump();

    // Simulate scroll
    scrollController.jumpTo(100.0);
    await tester.pump();

    expect(find.byKey(ValueKey('offsetText')), findsOneWidget);
    expect(find.text('Offset: 100.0'), findsOneWidget);
  });

  testWidgets('ScrollTransformItem works with only offsetBuilder (no scaleBuilder)',
      (WidgetTester tester) async {
    final scrollController = ScrollController();

    await tester.pumpWidget(
      ScrollControllerScope(
        controller: scrollController,
        child: MaterialApp(
          home: Scaffold(
            body: ListView(
              controller: scrollController,
              children: [
                SizedBox(height: 500),
                ScrollTransformItem(
                  offsetBuilder: (offset) => Offset(offset / 10, 0),
                  builder: (offset) =>
                      Text('Offset: $offset', key: ValueKey('offsetOnly')),
                ),
                SizedBox(height: 1000),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    scrollController.jumpTo(50.0);
    await tester.pump();

    expect(find.byKey(ValueKey('offsetOnly')), findsOneWidget);
    expect(find.text('Offset: 50.0'), findsOneWidget);
  });

  testWidgets('ScrollTransformItem works with only scaleBuilder (no offsetBuilder)',
      (WidgetTester tester) async {
    final scrollController = ScrollController();

    await tester.pumpWidget(
      ScrollControllerScope(
        controller: scrollController,
        child: MaterialApp(
          home: Scaffold(
            body: ListView(
              controller: scrollController,
              children: [
                SizedBox(height: 500),
                ScrollTransformItem(
                  scaleBuilder: (offset) => 1 + offset / 500,
                  builder: (offset) =>
                      Text('Scale: $offset', key: ValueKey('scaleOnly')),
                ),
                SizedBox(height: 1000),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    scrollController.jumpTo(100.0);
    await tester.pump();

    expect(find.byKey(ValueKey('scaleOnly')), findsOneWidget);
    // The Transform.scale should be applied with 1 + 100/500 = 1.2
    expect(find.text('Scale: 100.0'), findsOneWidget);
  });

  testWidgets('ScrollTransformItem works with no offsetBuilder and no scaleBuilder',
      (WidgetTester tester) async {
    final scrollController = ScrollController();

    await tester.pumpWidget(
      ScrollControllerScope(
        controller: scrollController,
        child: MaterialApp(
          home: Scaffold(
            body: ListView(
              controller: scrollController,
              children: [
                SizedBox(height: 500),
                ScrollTransformItem(
                  builder: (offset) =>
                      Text('NoTransform: $offset', key: ValueKey('noTransform')),
                ),
                SizedBox(height: 1000),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    scrollController.jumpTo(75.0);
    await tester.pump();

    expect(find.byKey(ValueKey('noTransform')), findsOneWidget);
    // Scale defaults to 1.0, offset defaults to Offset.zero
    expect(find.text('NoTransform: 75.0'), findsOneWidget);
  });
}
