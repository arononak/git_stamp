// Copyright © 2024 Aron Onak. All rights reserved.
// Licensed under the MIT license.
// If you have any feedback, please contact me at arononak@gmail.com

/// The model used to store information about the repository packages.
class Packages {
  final List<Package>? packages;

  Packages({this.packages});

  factory Packages.fromJson(Map<String, dynamic> json) {
    final packagesJson = json['packages'] as List<dynamic>?;
    return Packages(
      packages: packagesJson?.map((item) => Package.fromJson(item)).toList(),
    );
  }
}

class Package {
  final String? package;
  final String? kind;
  final bool? isDiscontinued;
  final bool? isCurrentRetracted;
  final bool? isCurrentAffectedByAdvisory;
  final Version? current;
  final Version? upgradable;
  final Version? resolvable;
  final Version? latest;

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

class Version {
  final String? version;

  Version({this.version});

  factory Version.fromJson(Map<String, dynamic>? json) {
    return Version(version: json?['version']);
  }
}
