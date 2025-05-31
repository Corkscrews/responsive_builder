import 'package:responsive_builder2_example/views/home/content_view.dart';
import 'package:responsive_builder2_example/widgets/app_drawer/app_drawer.dart';
import 'package:flutter/material.dart';

class HomeViewTablet extends StatelessWidget {
  const HomeViewTablet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);
    final orientationText =
        orientation == Orientation.portrait ? "portrait" : "landscape";
    final children = [
      Expanded(
        child: ContentWidget(title: "Tablet $orientationText detected"),
      ),
      AppDrawer()
    ];
    return Scaffold(
      body: orientation == Orientation.portrait
          ? Column(
              children: children,
            )
          : Row(
              children: children.reversed.toList(),
            ),
    );
  }
}
