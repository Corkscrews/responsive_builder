import 'package:flutter/widgets.dart' hide WidgetBuilder;
import 'typedefs.dart';

enum OrientationLayoutBuilderMode {
  auto,
  landscape,
  portrait,
}

/// Provides a builder function for a landscape and portrait widget
class OrientationLayoutBuilder extends StatelessWidget {
  final WidgetBuilder? landscape;
  final WidgetBuilder portrait;
  final OrientationLayoutBuilderMode mode;

  const OrientationLayoutBuilder({
    super.key,
    this.landscape,
    required this.portrait,
    this.mode = OrientationLayoutBuilderMode.auto,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final orientation = MediaQuery.orientationOf(context);
        if (mode != OrientationLayoutBuilderMode.portrait &&
            (orientation == Orientation.landscape ||
                mode == OrientationLayoutBuilderMode.landscape)) {
          if (landscape != null) {
            return landscape!(context);
          }
        }

        return portrait(context);
      },
    );
  }
}
