import 'package:example/views/home/home_view_desktop.dart';
import 'package:example/views/home/home_view_mobile.dart';
import 'package:example/views/home/home_view_tablet.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder2/responsive_builder.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: ScreenBreakpoints(large: 650, small: 250),
      desktop: (_) => HomeViewDesktop(),
      mobile: (_) => OrientationLayoutBuilder(
        portrait: (context) => HomeMobileView(isPortrait: true),
        landscape: (context) => HomeMobileView(isPortrait: false),
      ),
      tablet: (_) => HomeViewTablet(),
    );
  }
}
