import 'package:responsive_builder2_example/views/home/content_view.dart';
import 'package:responsive_builder2_example/widgets/app_drawer/app_drawer.dart';
import 'package:flutter/material.dart';

/// Contains the widget that will be used for Mobile layout of home,
/// portrait and landscape, controlled by a flag.

class HomeMobileView extends StatelessWidget {
  final bool isPortrait;
  const HomeMobileView({Key? key, required this.isPortrait}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isPortrait) {
      return Scaffold(
        drawer: AppDrawer(),
        body: Stack(
          children: <Widget>[
            ContentWidget(title: "Mobile portrait detected"),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu, size: 30),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      body: Row(
        children: <Widget>[
          AppDrawer(),
          Expanded(child: ContentWidget(title: "Mobile landscape detected")),
        ],
      ),
    );
  }
}
