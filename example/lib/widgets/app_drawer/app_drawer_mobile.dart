import 'package:flutter/material.dart';

import 'app_drawer.dart';

class AppDrawerMobile extends StatelessWidget {
  const AppDrawerMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Container(
      width: orientation == Orientation.portrait ? 230 : 140,
      decoration: BoxDecoration(
        color: Colors.white, 
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            color: Colors.black12,
          )
        ]
      ),
      child: SafeArea(
        right: orientation == Orientation.portrait,
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                children: AppDrawer.getDrawerOptions(),
              )
            ),
          ],
        ),
      ),
    );
  }
}
