import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
// Replace this import with the actual path to your widget

void main() {
  testWidgets('ScrollTransformItem applies offset and scale', (WidgetTester tester) async {
    final scrollController = ScrollController();

    await tester.pumpWidget(
      ChangeNotifierProvider<ScrollController>.value(
        value: scrollController,
        child: MaterialApp(
          home: Scaffold(
            body: ListView(
              controller: scrollController,
              children: [
                SizedBox(height: 500), // Ensure some scroll area
                ScrollTransformItem(
                  offsetBuilder: (offset) => Offset(offset / 10, 0),
                  scaleBuilder: (offset) => 1 + offset / 500,
                  builder: (offset) => Text('Offset: $offset', key: ValueKey('offsetText')),
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
}
