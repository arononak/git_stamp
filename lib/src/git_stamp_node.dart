// Copyright © 2024 Aron Onak. All rights reserved.
// Licensed under the MIT license.
// If you have any feedback, please contact me at arononak@gmail.com

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'model/build_machine.dart';
import 'model/commit.dart';
import 'model/package.dart';
import 'model/tag.dart';

extension _StringExtension on String {
  dynamic get jsonDecode => json.decode(this);
}

/// The [GitStampNode] class contains information provided during generation.
///
/// ```cli
/// dart run git_stamp --build-type full
/// ```
///
/// Used by [GitStampPage].
///
/// Can be used to extract information.
///
/// Example:
/// ```dart
/// const appVersion = GitStamp.appVersion;
/// ```
abstract class GitStampNode {
  /// GitStamp version.
  String get toolVersion;

  /// GitStamp Build Type selected during generation.
  ///
  /// Possible values ​​are: [FULL], [LITE], [ICON] & [CUSTOM].
  String get toolBuildType;

  /// Checks if the build type is [LITE].
  bool get isLiteVersion => toolBuildType == 'LITE';

  /// Displays whether [GitStampNode] is encrypted.
  bool get isEncrypted => false;

  /// Function to decrypt GitStampNode.
  bool decrypt(Uint8List key, Uint8List iv) => true;

  /// Commit List as JSON.
  String get commitListString => '[]';

  /// Commit List.
  List<Commit> get commitList => commitListString.jsonDecode
      .map<Commit>((json) => Commit.fromJson(json))
      .toList();

  /// Latest Commit.
  Commit? get latestCommit => commitList.firstOrNull;

  /// Latest Commit SHA.
  String get sha => latestCommit?.hash ?? 'REPO WITHOUT COMMITS';

  /// Commit List Count.
  int get commitCount => commitList.length;

  /// Tag List as json.
  String get tagListString => '[]';

  /// Tag List.
  List<Tag> get tagList =>
      tagListString.jsonDecode.map<Tag>((json) => Tag.fromJson(json)).toList();

  /// Tag List Count.
  int get tagListCount => tagList.length;

  /// Diff List as JSON.
  String get diffListString => '{}';

  /// Diff List.
  Map<String, dynamic> get diffList =>
      diffListString.replaceAll(r"\'", "'").jsonDecode;

  /// Diff Stat List as JSON.
  String get diffStatListString => '{}';

  /// Diff Stat List.
  Map<String, dynamic> get diffStatList =>
      diffStatListString.replaceAll(r"\'", "'").jsonDecode;

  /// Return [BuildMachine] as JSON.
  String get buildMachineString => '';

  /// Returns [BuildMachine].
  BuildMachine get buildMachine =>
      BuildMachine.fromJson(buildMachineString.jsonDecode);

  /// List of observable files in a [git] repository as String.
  String get observedFiles => '';

  /// List of observable files in a [git] repository as List.
  List<String> get observedFilesList => observedFiles.split(RegExp(r'\r?\n'));

  /// Number of observable files in [git] repository.
  int get observedFilesCount => observedFilesList.length;

  /// List of branches in [git] repository as String.
  String get branchListString => '';

  /// List of branches in [git] repository as List.
  List<String> get branchList => branchListString.split(RegExp(r'\r?\n'));

  /// Number of branches in the repository.
  int get branchListCount => branchList.length;

  /// List of packages that are in [pubspec.yml] as JSON.
  String get packageListString => '[]';

  /// List of packages that are in [pubspec.yml] as List.
  List<Package> get packageList =>
      Packages.fromJson(packageListString.jsonDecode).packages ?? [];

  /// The number of packages that are in [pubspec.yml].
  int get packageListCount => packageList.length;

  /// The branch from which the applications were built.
  String get buildBranch => '';

  /// Date the application was built.
  String get buildDateTime => '';

  /// Information that is visible during the ```flutter doctor``` command
  String get buildSystemInfo => '';

  /// The date the [git] repository was created.
  String get repoCreationDate => '';

  /// The path of the repository on the system during build.
  String get repoPath => '';

  /// Application version + build number from [pubspec.yaml].
  ///
  /// Example: '1.0.0 (1)'.
  String get appVersionFull =>
      !isEncrypted ? '$appVersion ($appBuild)' : 'ENCRYPTED';

  /// Application version from [pubspec.yaml].
  ///
  /// Example: '1.0.0'.
  String get appVersion => '';

  /// Application build number from [pubspec.yaml].
  ///
  /// Example: '1'.
  String get appBuild => '';

  /// Application name from [pubspec.yaml].
  ///
  /// Example: 'example_app'.
  String get appName => '';

  /// [git] global configuration from system during build.
  ///
  /// Example: 'Jan Pyta (jan.pyta69@mail.com)'.
  String get gitConfigGlobalUser =>
      '$gitConfigGlobalUserName ($gitConfigGlobalUserEmail)';

  /// [git] global configuration from system during build.
  ///
  /// Example: 'Jan Pyta'.
  String get gitConfigGlobalUserName => '';

  /// [git] global configuration from system during build.
  ///
  /// Example: 'jan.pyta69@mail.com'.
  String get gitConfigGlobalUserEmail => '';

  /// [git] local configuration from system during build.
  ///
  /// Example: 'Jan Pyta (jan.pyta69@mail.com)'.
  String get gitConfigUser => '$gitConfigUserName ($gitConfigUserEmail)';

  /// [git] local configuration from system during build.
  ///
  /// Example: 'Jan Pyta'.
  String get gitConfigUserName => '';

  /// [git] local configuration from system during build.
  ///
  /// Example: 'jan.pyta69@mail.com'.
  String get gitConfigUserEmail => '';

  /// [git] origin.
  String get gitRemote => '';

  /// [git] configuration while building.
  String get gitConfigList => '';

  /// [git] count objects.
  String get gitCountObjects => '';

  /// [git] reflog.
  String get gitReflog => '';

  /// Returns an icon with information.
  ///
  /// Only possible for BuildType: [ICON], [LITE], [FULL].
  Widget icon() => SizedBox();

  /// Returns a [ListTile] widget to open a [GitStampPage].
  ///
  /// Only possible for BuildType: [LITE], [FULL].
  Widget listTile({
    required BuildContext context,
    String? monospaceFontFamily,
  }) {
    return SizedBox();
  }

  /// Only for testing.
  Widget mainPage({
    String? monospaceFontFamily,
    bool showDetails = false,
    bool showFiles = false,
  }) {
    return SizedBox();
  }

  /// Only for testing.
  Widget detailsPage({
    required Commit commit,
    String? monospaceFontFamily,
  }) {
    return SizedBox();
  }

  /// Starts [GitStampPage].
  void showMainPage({
    required BuildContext context,
    String? monospaceFontFamily,
    bool useRootNavigator = false,
  }) {}

  /// Only for testing.
  void showDetailsPage({
    required BuildContext context,
    required Commit commit,
    String? monospaceFontFamily,
    bool useRootNavigator = false,
  }) {}

  /// Starts [showLicensePage] function from [material] package.
  ///
  /// Adds [appName] and [appVersion] automatically.
  void showLicensePage({
    required BuildContext context,
    Widget? applicationIcon,
    String? applicationLegalese,
    bool useRootNavigator = false,
  }) {}
}
