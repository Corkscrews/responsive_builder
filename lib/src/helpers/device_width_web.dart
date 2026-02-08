import 'dart:ui';

/// Calculates the effective device width for web platforms.
///
/// On web, always returns the full width of the screen since the browser
/// window width is the relevant dimension for responsive layout decisions.
///
/// Parameters:
/// * [size]: The physical size of the screen
/// * [isWebOrDesktop]: Whether the app is running on web or desktop platform
///   (unused on web, always uses full width)
///
/// Returns the effective width in logical pixels.
double deviceWidth(Size size, bool isWebOrDesktop) => size.width;
