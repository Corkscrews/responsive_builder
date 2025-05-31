// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_builder2/src/device_screen_type.dart';

void main() {
  group('DeviceScreenType', () {
    test('ordinal values are correct', () {
      expect(DeviceScreenType.watch.ordinal, 0);
      expect(DeviceScreenType.phone.ordinal, 1);
      expect(DeviceScreenType.mobile.ordinal, 1);
      expect(DeviceScreenType.tablet.ordinal, 2);
      expect(DeviceScreenType.desktop.ordinal, 3);
      // Deprecated values
      expect(DeviceScreenType.Watch.ordinal, 0);
      expect(DeviceScreenType.Mobile.ordinal, 1);
      expect(DeviceScreenType.Tablet.ordinal, 2);
      expect(DeviceScreenType.Desktop.ordinal, 3);
    });

    test('comparison operators work as expected', () {
      expect(DeviceScreenType.watch < DeviceScreenType.phone, isTrue);
      expect(DeviceScreenType.phone < DeviceScreenType.tablet, isTrue);
      expect(DeviceScreenType.tablet < DeviceScreenType.desktop, isTrue);
      expect(DeviceScreenType.desktop > DeviceScreenType.tablet, isTrue);
      expect(DeviceScreenType.phone >= DeviceScreenType.mobile, isTrue);
      expect(DeviceScreenType.watch <= DeviceScreenType.Watch, isTrue);
      expect(DeviceScreenType.desktop >= DeviceScreenType.Desktop, isTrue);
    });
  });

  group('RefinedSize', () {
    test('comparison operators work as expected', () {
      expect(RefinedSize.small < RefinedSize.normal, isTrue);
      expect(RefinedSize.normal < RefinedSize.large, isTrue);
      expect(RefinedSize.large < RefinedSize.extraLarge, isTrue);
      expect(RefinedSize.extraLarge > RefinedSize.large, isTrue);
      expect(RefinedSize.normal >= RefinedSize.small, isTrue);
      expect(RefinedSize.large <= RefinedSize.extraLarge, isTrue);
      expect(RefinedSize.normal <= RefinedSize.normal, isTrue);
    });
  });
}
