// Copyright © 2024 Aron Onak. All rights reserved.
// Licensed under the MIT license.
// If you have any feedback, please contact me at arononak@gmail.com

/// The model used to store [Package] list.
///
/// Stores information about your Flutter project's pub packages.
class Packages {
  final List<Package>? packages;

  /// Creates an instance of [Packages].
  ///
  /// All fields optional.
  Packages({this.packages});

  /// Creates an instance of [Packages].
  ///
  /// Requires json map.
  factory Packages.fromJson(Map<String, dynamic> json) {
    final packagesJson = json['packages'] as List<dynamic>?;
    return Packages(
      packages: packagesJson?.map((item) => Package.fromJson(item)).toList(),
    );
  }
}

/// The model used to store information about the [Package].
///
/// Stores information about your Flutter project's pub single package.
class Package {
  /// Package name.
  /// 
  /// Example: `git_stamp`.
  final String? package;

  /// Type of package.
  ///
  ///  * direct     - `dependencies` section.
  ///  * dev        - `dev_dependencies` section,
  ///  * transitive - Used indirectly by the sections above.
  final String? kind;

  final bool? isDiscontinued;
  
  final bool? isCurrentRetracted;
  
  final bool? isCurrentAffectedByAdvisory;
  
  /// Current version of the package being used.
  final Version? current;
  
  final Version? upgradable;
  
  final Version? resolvable;
  
  /// The latest possible version of the package available at the time of compilation.
  final Version? latest;

  /// Creates an instance of [Package].
  ///
  /// All fields optional.
  Package({
    this.package,
    this.kind,
    this.isDiscontinued,
    this.isCurrentRetracted,
    this.isCurrentAffectedByAdvisory,
    this.current,
    this.upgradable,
    this.resolvable,
    this.latest,
  });

  /// Creates an instance of [Package].
  ///
  /// Requires json map.
  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      package: json['package'],
      kind: json['kind'],
      isDiscontinued: json['isDiscontinued'],
      isCurrentRetracted: json['isCurrentRetracted'],
      isCurrentAffectedByAdvisory: json['isCurrentAffectedByAdvisory'],
      current: Version.fromJson(json['current']),
      upgradable: Version.fromJson(json['upgradable']),
      resolvable: Version.fromJson(json['resolvable']),
      latest: Version.fromJson(json['latest']),
    );
  }
}

/// The model used to store information about the package [Version].
///
/// Stores information about your Flutter project's pub single package version.
class Version {
  /// Example: '5.6.0'.
  final String? version;

  /// Creates an instance of [Version].
  ///
  /// All fields optional.
  Version({this.version});

  /// Creates an instance of [Version].
  ///
  /// Requires json map.
  factory Version.fromJson(Map<String, dynamic>? json) {
    return Version(version: json?['version']);
  }
}
