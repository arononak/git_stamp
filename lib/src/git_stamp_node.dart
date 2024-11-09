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
/// const appVersion = GitStampNode.appVersion;
/// ```
abstract class GitStampNode {
  bool get isEncrypted => false;

  bool decrypt(Uint8List key, Uint8List iv) => true;

  String get commitListString => '[]';
  List<Commit> get commitList => json.decode(commitListString).map<Commit>((json) => Commit.fromJson(json)).toList();
  Commit? get latestCommit => commitList.firstOrNull;
  String get sha => latestCommit?.hash ?? 'REPO WITHOUT COMMITS';
  int get commitCount => commitList.length;

  String get tagListString => '[]';
  List<Tag> get tagList => json.decode(tagListString).map<Tag>((json) => Tag.fromJson(json)).toList();
  int get tagListCount => tagList.length;

  String get diffListString => '{}';
  Map<String, dynamic> get diffList => json.decode(diffListString.replaceAll(r"\'", "'"));
  String get diffStatListString => '{}';
  Map<String, dynamic> get diffStatList => json.decode(diffStatListString.replaceAll(r"\'", "'"));

  String get buildMachineString => '';
  BuildMachine get buildMachine => BuildMachine.fromJson(json.decode(buildMachineString));
  
  String get observedFiles => '';
  List<String> get observedFilesList => observedFiles.split(RegExp(r'\r?\n'));
  int get observedFilesCount => observedFilesList.length;

  String get branchListString => '';
  List<String> get branchList => branchListString.split(RegExp(r'\r?\n'));
  int get branchListCount => branchList.length;

  String get packageListString => '[]';
  List<Package> get packageList => Packages.fromJson(json.decode(packageListString)).packages ?? [];
  int get packageListCount => packageList.length;

  String get buildBranch => '';
  String get buildDateTime => '';
  String get buildSystemInfo => '';
  String get repoCreationDate => '';
  String get repoPath => '';

  String get appVersionFull => !isEncrypted ? '$appVersion ($appBuild)' : 'ENCRYPTED';
  String get appVersion => '';
  String get appBuild => '';
  String get appName => '';
  
  String get gitConfigGlobalUser => '$gitConfigGlobalUserName ($gitConfigGlobalUserEmail)';
  String get gitConfigGlobalUserName => '';
  String get gitConfigGlobalUserEmail => '';

  String get gitConfigUser => '$gitConfigUserName ($gitConfigUserEmail)';
  String get gitConfigUserName => '';
  String get gitConfigUserEmail => '';
  
  String get gitRemote => '';
  String get gitConfigList => '';
  String get gitCountObjects => '';
  String get gitReflog => '';

  Widget icon() => SizedBox();
  Widget listTile({required BuildContext context, String? monospaceFontFamily}) => SizedBox();
  Widget mainPage({String? monospaceFontFamily, bool showDetails = false, bool showFiles = false}) => SizedBox();
  Widget detailsPage({required Commit commit, String? monospaceFontFamily}) => SizedBox();

  void showMainPage({required BuildContext context, String? monospaceFontFamily, bool useRootNavigator = false}) {}
  void showDetailsPage({required BuildContext context, required Commit commit, String? monospaceFontFamily, bool useRootNavigator = false}) {}
  void showLicensePage({required BuildContext context, Widget? applicationIcon, String? applicationLegalese, bool useRootNavigator = false}) {}
}
