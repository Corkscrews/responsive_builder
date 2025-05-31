import 'package:flutter/material.dart';

class DrawerOptionMobilePortrait extends StatelessWidget {
  final String? title;
  final IconData? iconData;
  const DrawerOptionMobilePortrait({
    Key? key,
    this.title,
    this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
      children: <Widget>[
        SizedBox(
          width: 16,
        ),
        Icon(
          iconData,
          size: 25,
        ),
        SizedBox(
          width: 16,
        ),
        Text(
          title!,
          style: TextStyle(fontSize: 21),
          )
        ],
      ),
    );
  }
}

class DrawerOptionMobileLandscape extends StatelessWidget {
  final String? title;
  final IconData? iconData;
  const DrawerOptionMobileLandscape({
    Key? key,
    this.title,
    this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: <Widget>[
          Icon(
            iconData,
            size: 25,
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            title ?? '',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
