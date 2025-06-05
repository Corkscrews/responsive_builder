import 'dart:ui';

/// Calculates the effective device width based on the platform and screen size.
///
/// For web or desktop platforms, returns the full width of the screen.
/// For mobile platforms, returns the shortest side of the screen
/// (width or height).
///
/// Parameters:
/// * [size]: The physical size of the screen
/// * [isWebOrDesktop]: Whether the app is running on web or desktop platform
///
/// Returns the effective width in logical pixels.
double deviceWidth(Size size, bool isWebOrDesktop) =>
    isWebOrDesktop ? size.width : size.shortestSide;
