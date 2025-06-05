/// Represents the type of device screen, used for responsive layout decisions.
///
/// The enum values are ordered by increasing screen size:
/// - [watch]: Smallest screens, such as smartwatches.
/// - [phone]: Phones and small mobile devices.
/// - [tablet]: Tablets and medium-sized devices.
/// - [desktop]: Large screens, such as desktops and laptops.
///
/// Deprecated values (capitalized) are kept for backward compatibility.
enum DeviceScreenType {
  /// Deprecated: Use [watch] instead.
  @Deprecated('Use lowercase version')
  Watch(0),

  /// Deprecated: Use [phone] instead.
  @Deprecated('Use lowercase or phoneversion')
  Mobile(1),

  /// Deprecated: Use [tablet] instead.
  @Deprecated('Use lowercase version')
  Tablet(2),

  /// Deprecated: Use [desktop] instead.
  @Deprecated('Use lowercase version')
  Desktop(3),

  /// Deprecated: Use [phone] instead.
  @Deprecated('Use phone version')
  mobile(1),

  /// Smallest screens, such as smartwatches.
  watch(0),

  /// Phones and small mobile devices.
  phone(1),

  /// Tablets and medium-sized devices.
  tablet(2),

  /// Large screens, such as desktops and laptops.
  desktop(3);

  /// The ordinal value representing the order of the device type.
  const DeviceScreenType(this.ordinal);

  final int ordinal;

  /// Returns true if this device type is greater (larger) than [other].
  bool operator >(DeviceScreenType other) => ordinal > other.ordinal;

  /// Returns true if this device type is greater than or equal to [other].
  bool operator >=(DeviceScreenType other) => ordinal >= other.ordinal;

  /// Returns true if this device type is less (smaller) than [other].
  bool operator <(DeviceScreenType other) => ordinal < other.ordinal;

  /// Returns true if this device type is less than or equal to [other].
  bool operator <=(DeviceScreenType other) => ordinal <= other.ordinal;
}

/// Represents a more granular size classification for responsive layouts.
///
/// The enum values are ordered by increasing size:
/// - [small]: Smallest refined size.
/// - [normal]: Default or typical size.
/// - [large]: Larger than normal.
/// - [extraLarge]: Largest refined size.
enum RefinedSize {
  /// Smallest refined size.
  small,

  /// Default or typical size.
  normal,

  /// Larger than normal.
  large,

  /// Largest refined size.
  extraLarge;

  /// Returns true if this refined size is greater (larger) than [other].
  bool operator >(RefinedSize other) => index > other.index;

  /// Returns true if this refined size is greater than or equal to [other].
  bool operator >=(RefinedSize other) => index >= other.index;

  /// Returns true if this refined size is less (smaller) than [other].
  bool operator <(RefinedSize other) => index < other.index;

  /// Returns true if this refined size is less than or equal to [other].
  bool operator <=(RefinedSize other) => index <= other.index;
}
