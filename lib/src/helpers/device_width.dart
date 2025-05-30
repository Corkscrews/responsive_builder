import 'dart:ui';

double deviceWidth(Size size, bool isWebOrDesktop) =>
    isWebOrDesktop ? size.width : size.shortestSide;
