import 'package:flutter/widgets.dart';

/// An [InheritedNotifier] that provides a [ScrollController] to descendant
/// widgets.
///
/// This widget is used internally by [ScrollTransformView] to share the
/// [ScrollController] with [ScrollTransformItem] children. It automatically
/// notifies dependents when the scroll position changes, since
/// [ScrollController] extends [ChangeNotifier].
///
/// You can also use this widget directly to provide a [ScrollController] to
/// [ScrollTransformItem] widgets without using [ScrollTransformView]:
///
/// ```dart
/// ScrollControllerScope(
///   controller: myScrollController,
///   child: Column(
///     children: [
///       ScrollTransformItem(
///         builder: (offset) => Text('Offset: $offset'),
///       ),
///     ],
///   ),
/// )
/// ```
class ScrollControllerScope extends InheritedNotifier<ScrollController> {
  /// Creates a [ScrollControllerScope] that provides the given [controller]
  /// to descendant widgets.
  const ScrollControllerScope({
    super.key,
    required ScrollController controller,
    required super.child,
  }) : super(notifier: controller);

  /// Returns the [ScrollController] from the nearest [ScrollControllerScope]
  /// ancestor.
  ///
  /// This method registers a dependency on the [ScrollControllerScope], so
  /// the calling widget will rebuild whenever the scroll position changes.
  ///
  /// Throws an [AssertionError] in debug mode if no [ScrollControllerScope]
  /// is found in the widget tree.
  static ScrollController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<ScrollControllerScope>();
    assert(
      scope != null,
      'No ScrollControllerScope found in widget tree. '
      'Wrap your ScrollTransformItem widgets in a ScrollTransformView '
      'or provide a ScrollControllerScope ancestor.',
    );
    return scope!.notifier!;
  }
}
