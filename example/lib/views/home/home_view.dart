import 'package:responsive_builder2_example/views/home/home_view_desktop.dart';
import 'package:responsive_builder2_example/views/home/home_view_mobile.dart';
import 'package:responsive_builder2_example/views/home/home_view_tablet.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder2/responsive_builder2.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder2(
      breakpoints: ScreenBreakpoints(large: 650, small: 250),
      desktop: (_, __) => HomeViewDesktop(),
      phone: (_, __) => OrientationLayoutBuilder(
        portrait: (context) => HomeMobileView(isPortrait: true),
        landscape: (context) => HomeMobileView(isPortrait: false),
      ),
      tablet: (_, __) => HomeViewTablet(),
    );
  }
}
