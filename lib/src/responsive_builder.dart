import 'package:flutter/widgets.dart';
import 'device_screen_type.dart';
import 'helpers/helpers.dart';
import 'sizing_information.dart';

/// A widget with a builder that provides you with the sizingInformation
///
/// This widget is used by the ScreenTypeLayout to provide different widget
/// builders
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    SizingInformation sizingInformation,
  ) builder;

  final ScreenBreakpoints? breakpoints;
  final RefinedBreakpoints? refinedBreakpoints;
  final bool? isWebOrDesktop;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
    this.breakpoints,
    this.refinedBreakpoints,
    this.isWebOrDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, boxConstraints) {
      final size = MediaQuery.sizeOf(context);
      final sizingInformation = SizingInformation(
        deviceScreenType: getDeviceType(
          size,
          breakpoints,
          isWebOrDesktop,
        ),
        refinedSize: getRefinedSize(
          size,
          refinedBreakpoint: refinedBreakpoints,
          isWebOrDesktop: isWebOrDesktop,
        ),
        screenSize: size,
        localWidgetSize:
            Size(boxConstraints.maxWidth, boxConstraints.maxHeight),
      );
      return builder(context, sizingInformation);
    });
  }
}
