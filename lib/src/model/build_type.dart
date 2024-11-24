/// A model [BuildType] used to store information about the selected build type.
///
/// It is selected during compilation, or more precisely, when running
/// the GitStamp generator.
enum BuildType {
  full('full'),
  lite('lite'),
  icon('icon'),
  custom('custom'),
  noBuildType(':/');

  /// Enum value.
  final String value;

  /// Checks if the build type is [BuildType.lite].
  bool get isLiteVersion => this == lite;

  /// Creates an instance of [BuildType].
  ///
  /// This constructor requires [String] value.
  const BuildType(this.value);

  /// Creates an instance of [BuildType].
  ///
  /// Requires [String] value.
  static BuildType fromString(String value) => BuildType.values.firstWhere(
        (e) => e.value == value,
        orElse: () => noBuildType,
      );
}
