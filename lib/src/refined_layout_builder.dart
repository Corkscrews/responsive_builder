import 'package:flutter/widgets.dart' hide WidgetBuilder;
import 'device_screen_type.dart';
import 'responsive_builder.dart';
import 'sizing_information.dart';
import 'typedefs.dart';

/// Provides a builder function for refined screen sizes to be used
/// with [ScreenTypeLayout]
///
/// Each builder will get built based on the current device width.
/// [breakpoints] define your own custom device resolutions
/// [extraLarge] will be built if width is greater than 2160 on Desktops, 1280
/// on Tablets, and 600 on Mobiles
/// [large] will be built when width is greater than 1440 on Desktops, 1024 on
///  Tablets, and 414 on Mobiles
/// [normal] will be built when width is greater than 1080 on Desktops, 768 on
/// Tablets, and 375 on Mobiles
/// [small] will be built if width is less than 720 on Desktops, 600 on Tablets,
/// and 320 on Mobiles
class RefinedLayoutBuilder extends StatelessWidget {
  final RefinedBreakpoints? refinedBreakpoints;
  final bool? isWebOrDesktop;

  final WidgetBuilder? extraLarge;
  final WidgetBuilder? large;
  final WidgetBuilder normal;
  final WidgetBuilder? small;

  const RefinedLayoutBuilder({
    super.key,
    this.refinedBreakpoints,
    this.isWebOrDesktop,
    this.extraLarge,
    this.large,
    required this.normal,
    this.small,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      refinedBreakpoints: refinedBreakpoints,
      isWebOrDesktop: isWebOrDesktop,
      builder: (context, sizingInformation) {
        // If we're at extra large size
        if (sizingInformation.refinedSize == RefinedSize.extraLarge) {
          // If we have supplied the extra large layout then display that
          if (extraLarge != null) return extraLarge!(context);
          // If no extra large layout is supplied we want to check if we have
          // the size below it and display that
          if (large != null) return large!(context);
        }

        if (sizingInformation.refinedSize == RefinedSize.large) {
          // If we have supplied the large layout then display that
          if (large != null) return large!(context);
          // If no large layout is supplied we want to check if we have the
          // size below it and display that
          return normal(context);
        }

        if (sizingInformation.refinedSize == RefinedSize.small) {
          // If we have supplied the small layout then display that
          if (small != null) return small!(context);
        }

        // If none of the layouts above are supplied or we're on the small size
        // layout then we show the small layout
        return normal(context);
      },
    );
  }
}
