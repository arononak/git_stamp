// Copyright © 2024 Aron Onak. All rights reserved.
// Licensed under the MIT license.
// If you have any feedback, please contact me at arononak@gmail.com

/// A model [BuildMachine] used to store information about a building machine.
///
/// Stores information about the machine that built the executable file.
class BuildMachine {
  /// Example: `3.24.4`.
  final String frameworkVersion;

  /// Example: `stable`.
  final String channel;

  /// Example: `https://github.com/flutter/flutter.git`.
  final String repositoryUrl;

  /// Example: `603104015dd692ea3403755b55d07813d5cf8965`.
  final String frameworkRevision;

  /// Example: `2024-10-24 08:01:25 -0700`.
  final String frameworkCommitDate;

  /// Example: `db49896cf25ceabc44096d5f088d86414e05a7aa`.
  final String engineRevision;

  /// Example: `3.5.4`.
  final String dartSdkVersion;

  /// Example: `2.37.3`.
  final String devToolsVersion;

  /// Example: `3.24.4`.
  final String flutterVersion;

  /// Example: `/home/aron/flutter`.
  final String flutterRoot;

  /// Creates an instance of [BuildMachine].
  ///
  /// This constructor requires all fields.
  BuildMachine({
    required this.frameworkVersion,
    required this.channel,
    required this.repositoryUrl,
    required this.frameworkRevision,
    required this.frameworkCommitDate,
    required this.engineRevision,
    required this.dartSdkVersion,
    required this.devToolsVersion,
    required this.flutterVersion,
    required this.flutterRoot,
  });

  /// Creates an instance of [BuildMachine].
  ///
  /// Requires json map.
  factory BuildMachine.fromJson(Map<String, dynamic> json) => BuildMachine(
        frameworkVersion: json['frameworkVersion'] ?? 'null',
        channel: json['channel'] ?? 'null',
        repositoryUrl: json['repositoryUrl'] ?? 'null',
        frameworkRevision: json['frameworkRevision'] ?? 'null',
        frameworkCommitDate: json['frameworkCommitDate'] ?? 'null',
        engineRevision: json['engineRevision'] ?? 'null',
        dartSdkVersion: json['dartSdkVersion'] ?? 'null',
        devToolsVersion: json['devToolsVersion'] ?? 'null',
        flutterVersion: json['flutterVersion'] ?? 'null',
        flutterRoot: json['flutterRoot'] ?? 'null',
      );

  /// Creates an instance of [BuildMachine].
  ///
  /// Assigns one value to each field, e.g. "null" or "ENCRYPTED".
  factory BuildMachine.all(String value) => BuildMachine(
        frameworkVersion: value,
        channel: value,
        repositoryUrl: value,
        frameworkRevision: value,
        frameworkCommitDate: value,
        engineRevision: value,
        dartSdkVersion: value,
        devToolsVersion: value,
        flutterVersion: value,
        flutterRoot: value,
      );
}
