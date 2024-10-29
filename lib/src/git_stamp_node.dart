import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'git_stamp_build_machine.dart';
import 'git_stamp_commit.dart';
import 'git_stamp_tag.dart';

mixin _GitStampNavigator {
  Widget icon();
  Widget listTile({required BuildContext context, String? monospaceFontFamily});
  Widget mainPage({String? monospaceFontFamily, bool showDetails = false, bool showFiles = false});
  Widget detailsPage({required GitStampCommit commit, String? monospaceFontFamily});

  void showMainPage({required BuildContext context, String? monospaceFontFamily, bool useRootNavigator = false});
  void showDetailsPage({required BuildContext context, required GitStampCommit commit, String? monospaceFontFamily, bool useRootNavigator = false});
  void showLicensePage({required BuildContext context, Widget? applicationIcon, String? applicationLegalese, bool useRootNavigator = false});
}

abstract class _GitStampNode with _GitStampNavigator {
  bool get isEncrypted;

  bool decrypt(Uint8List key, Uint8List iv);

  String get commitListString;
  List<GitStampCommit> get commitList;
  GitStampCommit? get latestCommit;
  String get sha;
  int get commitCount;

  String get diffListString;
  Map<String, dynamic> get diffList;
  String get diffStatListString;
  Map<String, dynamic> get diffStatList;

  String get buildMachineString;
  GitStampBuildMachine get buildMachine;

  String get buildBranch;
  String get buildDateTime;
  String get buildSystemInfo;
  String get repoCreationDate;
  String get repoPath;

  String get observedFiles;
  List<String> get observedFilesList;
  int get observedFilesCount;

  String get tagListString;
  List<GitStampTag> get tagList;
  int get tagListCount;

  String get branchListString;
  List<String> get branchList;
  int get branchListCount;

  String get appVersionFull => '$appVersion ($appBuild)';
  String get appVersion;
  String get appBuild;
  String get appName;

  String get gitConfigGlobalUser => '$gitConfigGlobalUserName ($gitConfigGlobalUserEmail)';
  String get gitConfigGlobalUserName;
  String get gitConfigGlobalUserEmail;

  String get gitConfigUser => '$gitConfigUserName ($gitConfigUserEmail)';
  String get gitConfigUserName;
  String get gitConfigUserEmail;

  String get gitRemote;
  String get gitConfigList;
  String get gitCountObjects;
  String get gitReflog;
}

class GitStampNode extends _GitStampNode {
  @override bool get isEncrypted => false;

  @override bool decrypt(Uint8List key, Uint8List iv) => true;

  @override String get commitListString => '[]';
  @override List<GitStampCommit> get commitList => json.decode(commitListString).map<GitStampCommit>((json) => GitStampCommit.fromJson(json)).toList();
  @override GitStampCommit? get latestCommit => commitList.firstOrNull;
  @override String get sha => latestCommit?.hash ?? 'REPO WITHOUT COMMITS';
  @override int get commitCount => commitList.length;

  @override String get diffListString => '{}';
  @override Map<String, dynamic> get diffList => json.decode(diffListString.replaceAll(r"\'", "'"));
  @override String get diffStatListString => '{}';
  @override Map<String, dynamic> get diffStatList => json.decode(diffStatListString.replaceAll(r"\'", "'"));

  @override String get buildMachineString => '';
  @override GitStampBuildMachine get buildMachine => GitStampBuildMachine.fromJson(json.decode(buildMachineString));
  
  @override String get buildBranch => '';
  @override String get buildDateTime => '';
  @override String get buildSystemInfo => '';
  @override String get repoCreationDate => '';
  @override String get repoPath => '';
  
  @override String get observedFiles => '';
  @override List<String> get observedFilesList => observedFiles.split(RegExp(r'\r?\n'));
  @override int get observedFilesCount => observedFilesList.length;

  @override String get tagListString => '[]';
  @override List<GitStampTag> get tagList => json.decode(tagListString).map<GitStampTag>((json) => GitStampTag.fromJson(json)).toList();
  @override int get tagListCount => tagList.length;

  @override String get branchListString => '';
  @override List<String> get branchList => branchListString.split(RegExp(r'\r?\n'));
  @override int get branchListCount => branchList.length;
  
  @override String get appVersionFull => !isEncrypted ? super.appVersionFull : 'ENCRYPTED';
  @override String get appVersion => '';
  @override String get appBuild => '';
  @override String get appName => '';
  
  @override String get gitConfigGlobalUserName => '';
  @override String get gitConfigGlobalUserEmail => '';

  @override String get gitConfigUserName => '';
  @override String get gitConfigUserEmail => '';
  
  @override String get gitRemote => '';
  @override String get gitConfigList => '';
  @override String get gitCountObjects => '';
  @override String get gitReflog => '';

  @override Widget icon() => SizedBox();
  @override Widget listTile({required BuildContext context, String? monospaceFontFamily}) => SizedBox();
  @override Widget mainPage({String? monospaceFontFamily, bool showDetails = false, bool showFiles = false}) => SizedBox();
  @override Widget detailsPage({required GitStampCommit commit, String? monospaceFontFamily}) => SizedBox();

  @override void showMainPage({required BuildContext context, String? monospaceFontFamily, bool useRootNavigator = false}) {}
  @override void showDetailsPage({required BuildContext context, required GitStampCommit commit, String? monospaceFontFamily, bool useRootNavigator = false}) {}
  @override void showLicensePage({required BuildContext context, Widget? applicationIcon, String? applicationLegalese, bool useRootNavigator = false}) {}
}