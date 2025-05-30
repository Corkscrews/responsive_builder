import 'dart:math';

import 'package:flutter/material.dart';

String getRandomMessage() {
  const messages = [
    "The great secret of true success, of true happiness, is this: the man or woman who asks for no return, the perfectly unselfish person, is the most successful.\n\n-Swami Vivekananda",
    "Each tear is a poet, a healer, a teacher.\n\n-Rune Lazuli",
    "If you want to become fearless, choose love.\n\n-Rune Lazuli",
    "Live quietly in the moment and see the beauty of all before you. The future will take care of itself...\n\n-Paramhansa Yogananda",
    "The only way to do great work is to love what you do.\n\n-Steve Jobs",
  ];
  final random = Random();
  return messages[random.nextInt(messages.length)];
}

class ContentWidget extends StatefulWidget {
  const ContentWidget({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  late String message;

  @override
  void initState() {
    super.initState();
    message = getRandomMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;
              double contentWidth = width < 400 ? width : width * 0.5;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: contentWidth,
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.labelMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
