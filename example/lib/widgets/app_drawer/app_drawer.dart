import 'package:responsive_builder2_example/widgets/drawer_option/drawer_option.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder2/responsive_builder2.dart';

import 'app_drawer_mobile.dart';
import 'app_drawer_tablet.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder2(
      phone: (_, __) => AppDrawerMobile(),
      tablet: (_, __) => OrientationLayoutBuilder(
        portrait: (context) => AppDrawerTabletPortrait(),
        landscape: (context) => AppDrawerTabletLandscape(),
      ),
    );
  }

  static List<Widget> getDrawerOptions() {
    return [
      DrawerOption(
        title: 'Images',
        iconData: Icons.image,
      ),
      DrawerOption(
        title: 'Reports',
        iconData: Icons.photo_filter,
      ),
      DrawerOption(
        title: 'Incidents',
        iconData: Icons.message,
      ),
      DrawerOption(
        title: 'Settings',
        iconData: Icons.settings,
      ),
    ];
  }
}
