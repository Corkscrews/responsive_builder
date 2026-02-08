import 'package:flutter/widgets.dart';
import 'scroll_controller_scope.dart';

/// A widget that applies scroll-based transformations to its child.
///
/// This widget allows you to create dynamic scroll effects by transforming
/// (scaling and/or translating) its child based on the scroll offset. It uses
/// a [ScrollController] from the widget tree (provided via
/// [ScrollControllerScope]) to track scroll position.
///
/// Example:
/// ```dart
/// ScrollTransformItem(
///   offsetBuilder: (offset) => Offset(0, offset * 0.5),
///   scaleBuilder: (offset) => 1.0 - (offset * 0.001),
///   builder: (offset) => MyWidget(),
/// )
/// ```
class ScrollTransformItem extends StatelessWidget {
  /// Optional function that calculates the translation offset based on scroll
  ///  position.
  ///
  /// If not provided, no translation will be applied.
  final Offset Function(double scrollOffset)? offsetBuilder;

  /// Optional function that calculates the scale factor based on scroll
  /// position.
  ///
  /// If not provided, no scaling will be applied (scale = 1.0).
  final double Function(double scrollOffset)? scaleBuilder;

  /// Required function that builds the child widget based on scroll position.
  final Widget Function(double scrollOffset) builder;

  /// Whether to log the current scroll offset to the console.
  ///
  /// Useful for debugging scroll effects.
  final bool logOffset;

  /// Creates a new [ScrollTransformItem].
  ///
  /// The [builder] parameter is required and must not be null.
  /// [offsetBuilder] and [scaleBuilder] are optional.
  const ScrollTransformItem({
    super.key,
    required this.builder,
    this.offsetBuilder,
    this.scaleBuilder,
    this.logOffset = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = ScrollControllerScope.of(context);
    final builtOffset = offsetBuilder?.call(controller.offset);
    return Transform.scale(
      scale: scaleBuilder?.call(controller.offset) ?? 1,
      child: Transform.translate(
        offset: builtOffset ?? Offset.zero,
        child: builder(controller.offset),
      ),
    );
  }
}
