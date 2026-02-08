import 'package:flutter/widgets.dart';
import 'scroll_controller_scope.dart';
import 'scroll_transform_item.dart';

/// A widget that creates a scrollable view with transformable children.
///
/// This widget provides a scrollable container that enables scroll-based
/// transformations on its children. It uses a [ScrollController] to track
/// scroll position and provides it to child [ScrollTransformItem] widgets
/// through a [ScrollControllerScope].
///
/// Example:
/// ```dart
/// ScrollTransformView(
///   children: [
///     ScrollTransformItem(
///       offsetBuilder: (offset) => Offset(0, offset * 0.5),
///       builder: (offset) => MyWidget(),
///     ),
///     // More transform items...
///   ],
/// )
/// ```
class ScrollTransformView extends StatefulWidget {
  /// The list of [ScrollTransformItem] widgets to be displayed in the scroll
  /// view.
  ///
  /// Each child will receive scroll position updates and can apply its own
  /// transformations based on the scroll offset.
  final List<ScrollTransformItem> children;

  /// Creates a new [ScrollTransformView].
  ///
  /// The [children] parameter is required and must not be null.
  const ScrollTransformView({
    super.key,
    required this.children,
  });

  @override
  State<ScrollTransformView> createState() => _ScrollTransformViewState();
}

class _ScrollTransformViewState extends State<ScrollTransformView> {
  /// The controller that manages scroll position and notifies listeners.
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: ScrollControllerScope(
        controller: scrollController,
        child: Column(
          children: widget.children,
        ),
      ),
    );
  }
}
