// Copyright © 2024 Aron Onak. All rights reserved.
// Licensed under the MIT license.
// If you have any feedback, please contact me at arononak@gmail.com

/// A model [BuildMachine] used to store information about a building machine.
/// 
/// Stores information about the machine that built the executable file.
class BuildMachine {
  final String frameworkVersion;
  final String channel;
  final String repositoryUrl;
  final String frameworkRevision;
  final String frameworkCommitDate;
  final String engineRevision;
  final String dartSdkVersion;
  final String devToolsVersion;
  final String flutterVersion;
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
  factory BuildMachine.fromJson(Map<String, dynamic> json) =>
      BuildMachine(
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
