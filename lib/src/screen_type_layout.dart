import 'package:flutter/widgets.dart' hide WidgetBuilder;
import 'device_screen_type.dart';
import 'responsive_builder.dart';
import 'responsive_wrapper.dart';
import 'sizing_information.dart';
import 'typedefs.dart';

/// Provides a builder function for different screen types
///
/// Each builder will get built based on the current device width.
/// [_breakpoints] define your own custom device resolutions
/// [_watch] will be built and shown when width is less than 300
/// [_mobile] will be built when width greater than 300
/// [_tablet] will be built when width is greater than 600
/// [_desktop] will be built if width is greater than 950
class ScreenTypeLayout extends StatelessWidget {
  final ScreenBreakpoints? _breakpoints;
  final bool? _isWebOrDesktop;

  final WidgetBuilder? _watch;
  final WidgetBuilder2? _watch2;

  final WidgetBuilder? _mobile;
  final WidgetBuilder2? _phone2;

  final WidgetBuilder? _tablet;
  final WidgetBuilder2? _tablet2;

  final WidgetBuilder? _desktop;
  final WidgetBuilder2? _desktop2;

  @Deprecated(
    'Use ScreenTypeLayout.builder instead for performance improvements',
  )
  ScreenTypeLayout({
    super.key,
    ScreenBreakpoints? breakpoints,
    bool? isWebOrDesktop,
    Widget? watch,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  })  : this._breakpoints = breakpoints,
        this._isWebOrDesktop = isWebOrDesktop,
        this._watch = _builderOrNull(watch),
        this._watch2 = null,
        this._mobile = _builderOrNull(mobile)!,
        this._phone2 = null,
        this._tablet = _builderOrNull(tablet),
        this._tablet2 = null,
        this._desktop = _builderOrNull(desktop),
        this._desktop2 = null {
    _checkIfMobileOrDesktopIsSupplied();
  }

  @Deprecated(
      'Use ScreenTypeLayout.builder instead for performance improvements')
  static WidgetBuilder? _builderOrNull(Widget? widget) {
    return widget == null ? null : (BuildContext context) => widget;
  }

  ScreenTypeLayout.builder({
    super.key,
    ScreenBreakpoints? breakpoints,
    bool? isWebOrDesktop,
    Widget Function(BuildContext)? watch,
    Widget Function(BuildContext)? mobile,
    Widget Function(BuildContext)? tablet,
    Widget Function(BuildContext)? desktop,
  })  : this._breakpoints = breakpoints,
        this._isWebOrDesktop = isWebOrDesktop,
        this._desktop = desktop,
        this._tablet = tablet,
        this._mobile = mobile,
        this._watch = watch,
        this._watch2 = null,
        this._phone2 = null,
        this._tablet2 = null,
        this._desktop2 = null {
    _checkIfMobileOrDesktopIsSupplied();
  }

  ScreenTypeLayout.builder2({
    super.key,
    ScreenBreakpoints? breakpoints,
    bool? isWebOrDesktop,
    WidgetBuilder2? watch,
    WidgetBuilder2? phone,
    WidgetBuilder2? tablet,
    WidgetBuilder2? desktop,
  })  : this._breakpoints = breakpoints,
        this._isWebOrDesktop = isWebOrDesktop,
        this._watch = null,
        this._watch2 = watch,
        this._mobile = null,
        this._phone2 = phone,
        this._tablet = null,
        this._tablet2 = tablet,
        this._desktop = null,
        this._desktop2 = desktop {
    _checkIfMobileOrDesktopIsSupplied();
  }

  void _checkIfMobileOrDesktopIsSupplied() {
    final hasMobileLayout = _mobile != null || _phone2 != null;
    final hasDesktopLayout = _desktop != null || _desktop2 != null;

    assert(
      hasMobileLayout || hasDesktopLayout,
      'You should supply either a mobile layout or a desktop layout. '
      'If you don\'t need two layouts then remove this widget and use the '
      'widget you want to use directly. ',
    );
  }

  bool _usingBuilder2() {
    return _watch2 != null ||
        _phone2 != null ||
        _tablet2 != null ||
        _desktop2 != null;
  }

  /// Builds the widget tree for the [ScreenTypeLayout].
  ///
  /// This method uses a [ResponsiveBuilder] to determine the current screen's
  /// sizing information and selects the appropriate widget builder based on
  /// the device type (watch, mobile, tablet, desktop) and the provided
  /// breakpoints. It first attempts to use a simple [WidgetBuilder] (if
  /// provided), and if none is available for the current device type, it falls
  /// back to a [WidgetBuilder2] (if provided) for more granular control.
  ///
  /// Throws an assertion error if neither a mobile nor a desktop layout is
  /// supplied.
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      breakpoints: _breakpoints,
      isWebOrDesktop: _isWebOrDesktop,
      builder: (context, sizingInformation) {
        return _usingBuilder2()
            ? _handleWidgetBuilder2(context, sizingInformation)
            : _handleWidgetBuilder(context, sizingInformation);
      },
    );
  }

  /// Returns the first available builder callback, used as a last-resort
  /// fallback when no device-specific builder matches.
  WidgetBuilder? get _anyBuilder =>
      _mobile ?? _desktop ?? _tablet ?? _watch;

  /// Returns the first available builder2 callback, used as a last-resort
  /// fallback when no device-specific builder2 matches.
  WidgetBuilder2? get _anyBuilder2 =>
      _phone2 ?? _desktop2 ?? _tablet2 ?? _watch2;

  Widget _handleWidgetBuilder(
      BuildContext context, SizingInformation sizingInformation) {
    if (ResponsiveAppUtil.preferDesktop) {
      return (_desktop ?? _mobile ?? _anyBuilder)!.call(context);
    }

    // If we're at desktop size
    if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
      // If we have supplied the desktop layout then display that
      if (_desktop != null) return _desktop!(context);
      // If no desktop layout is supplied we want to check if we have the
      // size below it and display that
      if (_tablet != null) return _tablet!(context);
    }

    if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
      if (_tablet != null) return _tablet!(context);
    }

    if (sizingInformation.deviceScreenType == DeviceScreenType.watch &&
        _watch != null) {
      return _watch!(context);
    }

    // Fall back to mobile, or any available builder as last resort
    return (_mobile ?? _anyBuilder)!.call(context);
  }

  Widget _handleWidgetBuilder2(
      BuildContext context, SizingInformation sizingInformation) {
    if (ResponsiveAppUtil.preferDesktop) {
      return (_desktop2 ?? _phone2 ?? _anyBuilder2)!
          .call(context, sizingInformation);
    }

    // If we're at desktop size
    if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
      // If we have supplied the desktop layout then display that
      if (_desktop2 != null) return _desktop2!(context, sizingInformation);
      // If no desktop layout is supplied we want to check if we have the
      // size below it and display that
      if (_tablet2 != null) return _tablet2!(context, sizingInformation);
    }

    if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
      if (_tablet2 != null) return _tablet2!(context, sizingInformation);
    }

    if (sizingInformation.deviceScreenType == DeviceScreenType.watch &&
        _watch2 != null) {
      return _watch2!(context, sizingInformation);
    }

    // Fall back to phone, or any available builder2 as last resort
    return (_phone2 ?? _anyBuilder2)!.call(context, sizingInformation);
  }
}
