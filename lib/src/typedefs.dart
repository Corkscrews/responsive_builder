import 'package:flutter/widgets.dart';
import 'sizing_information.dart';

/// Signature for a function that builds a widget given a [BuildContext].
///
/// Used by [ScreenTypeLayout.builder] to provide both the build context for
/// responsive widget construction.
typedef WidgetBuilder = Widget Function(BuildContext);

/// Signature for a function that builds a widget given a [BuildContext]
/// and [SizingInformation].
///
/// Used by [ScreenTypeLayout.builder2] to provide both the build context and
/// detailed sizing information for responsive widget construction.
typedef WidgetBuilder2 = Widget Function(BuildContext, SizingInformation);
