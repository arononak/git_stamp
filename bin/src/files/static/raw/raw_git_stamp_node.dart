import '../../../git_stamp_build.dart';

extension BoolExtension on bool {
  String get enabled => this ? '' : '//';
}

String rawGitStampNode(GitStampBuild files) => '''
library git_stamp;

${(files.commitList || files.buildMachine).enabled}import 'dart:convert';

${files.commitList.enabled}import 'src/data/commit_list.dart';
${files.commitList.enabled}import 'src/data/git_stamp_commit.dart';

${files.diffList.enabled}import 'src/data/diff_list.dart';
${files.diffStatList.enabled}import 'src/data/diff_stat_list.dart';

${files.buildBranch.enabled}import 'src/data/build_branch.dart';
${files.buildDateTime.enabled}import 'src/data/build_date_time.dart';
${files.buildSystemInfo.enabled}import 'src/data/build_system_info.dart';
${files.buildMachine.enabled}import 'src/data/git_stamp_build_machine.dart';
${files.buildMachine.enabled}import 'src/data/build_machine.dart';
${files.repoCreationDate.enabled}import 'src/data/repo_creation_date.dart';
${files.repoPath.enabled}import 'src/data/repo_path.dart';
${files.observedFilesList.enabled}import 'src/data/observed_files_list.dart';
${files.appVersion.enabled}import 'src/data/app_version.dart';
${files.appBuild.enabled}import 'src/data/app_build.dart';
${files.appName.enabled}import 'src/data/app_name.dart';
${files.gitConfig.enabled}import 'src/data/git_config.dart';
${files.gitRemote.enabled}import 'src/data/git_remote.dart';
${files.gitConfigList.enabled}import 'src/data/git_config_list.dart';

${files.generateFlutterFiles.enabled}import 'package:flutter/widgets.dart';
${files.generateFlutterFiles.enabled}import 'src/ui/git_stamp_license_page.dart';

class GitStamp {
  ${files.commitList.enabled}static List<GitStampCommit> get commitList => json.decode(gitStampCommitList).map<GitStampCommit>((json) => GitStampCommit.fromJson(json)).toList();
  ${files.commitList.enabled}static GitStampCommit? get latestCommit => commitList.firstOrNull;
  ${files.commitList.enabled}static String get sha => latestCommit?.hash ?? 'REPO WITHOUT COMMITS';
  ${files.commitList.enabled}static int get commitCount => commitList.length;

  ${files.diffList.enabled}static Map<String, dynamic> diffList = json.decode(gitStampDiffList.replaceAll(r"\\'", "'"));
  ${files.diffStatList.enabled}static Map<String, dynamic> diffStatList = json.decode(gitStampDiffStatList.replaceAll(r"\\'", "'"));

  ${files.buildBranch.enabled}static const String buildBranch = gitStampBuildBranch;
  ${files.buildDateTime.enabled}static const String buildDateTime = gitStampBuildDateTime;
  ${files.buildSystemInfo.enabled}static const String buildSystemInfo = gitStampBuildSystemInfo;
  ${files.buildMachine.enabled}static GitStampBuildMachine get buildMachine => GitStampBuildMachine.fromJson(json.decode(gitStampBuildMachine));
  ${files.repoCreationDate.enabled}static const String repoCreationDate = gitStampRepoCreationDate;
  ${files.repoPath.enabled}static const String repoPath = gitStampRepoPath;
  
  ${files.observedFilesList.enabled}static String observedFiles = gitStampObservedFilesList;
  ${files.observedFilesList.enabled}static List<String> observedFilesList = observedFiles.split(RegExp(r'\\r?\\n'));
  ${files.observedFilesList.enabled}static int observedFilesCount = observedFilesList.length;
  
  ${files.appVersion.enabled}static const String appVersion = gitStampAppVersion;
  ${files.appBuild.enabled}static const String appBuild = gitStampAppBuild;
  ${files.appName.enabled}static const String appName = gitStampAppName;

  ${files.gitConfig.enabled}static const String gitConfigGlobalUserName = gitStampGitConfigGlobalUserName;
  ${files.gitConfig.enabled}static const String gitConfigGlobalUserEmail = gitStampGitConfigGlobalUserEmail;
  ${files.gitConfig.enabled}static const String gitConfigUserName = gitStampGitConfigUserName;
  ${files.gitConfig.enabled}static const String gitConfigUserEmail = gitStampGitConfigUserEmail;

  ${files.gitRemote.enabled}static const String gitRemote = gitStampGitRemoteList;

  ${files.gitConfigList.enabled}static const String gitConfigList = gitStampGitConfigList;

  ${files.generateFlutterFiles.enabled}static showLicensePage({
  ${files.generateFlutterFiles.enabled}  required BuildContext context,
  ${files.generateFlutterFiles.enabled}  Widget? applicationIcon,
  ${files.generateFlutterFiles.enabled}  String? applicationLegalese,
  ${files.generateFlutterFiles.enabled}  bool useRootNavigator = false,
  ${files.generateFlutterFiles.enabled}}) =>
  ${files.generateFlutterFiles.enabled}    showGitStampLicensePage(
  ${files.generateFlutterFiles.enabled}      context: context,
  ${files.generateFlutterFiles.enabled}      applicationIcon: applicationIcon,
  ${files.generateFlutterFiles.enabled}      applicationLegalese: applicationLegalese,
  ${files.generateFlutterFiles.enabled}      useRootNavigator: useRootNavigator,
  ${files.generateFlutterFiles.enabled}    );
}
''';
