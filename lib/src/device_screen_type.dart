enum DeviceScreenType {
  @Deprecated('Use lowercase version')
  Watch(0),
  @Deprecated('Use lowercase or phoneversion')
  Mobile(1),
  @Deprecated('Use lowercase version')
  Tablet(2),
  @Deprecated('Use lowercase version')
  Desktop(3),

  @Deprecated('Use phone version')
  mobile(1),

  watch(0),
  phone(1),
  tablet(2),
  desktop(3);

  const DeviceScreenType(this.ordinal);

  final int ordinal;

  bool operator >(DeviceScreenType other) => ordinal > other.ordinal;

  bool operator >=(DeviceScreenType other) => ordinal >= other.ordinal;

  bool operator <(DeviceScreenType other) => ordinal < other.ordinal;

  bool operator <=(DeviceScreenType other) => ordinal <= other.ordinal;
}

enum RefinedSize {
  small,
  normal,
  large,
  extraLarge;

  bool operator >(RefinedSize other) => index > other.index;

  bool operator >=(RefinedSize other) => index >= other.index;

  bool operator <(RefinedSize other) => index < other.index;

  bool operator <=(RefinedSize other) => index <= other.index;
}
