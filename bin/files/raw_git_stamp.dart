import 'dart:typed_data';

import '../git_stamp_build_model.dart';

extension BoolExtension on bool {
  String get enabled => this ? '' : '//';
}

String rawGitStampNode(
  GitStampBuildModel model,
  String decryptedTestText,
  dynamic encryptedTestText,
) =>
    _content(model) +
    (model.encrypt
        ? _encryptedImpl(decryptedTestText, encryptedTestText)
        : _decryptedImpl(model));

String _content(GitStampBuildModel model) => '''
library git_stamp;

import 'package:flutter/services.dart';
${model.encrypt.enabled}import 'package:encrypt/encrypt.dart' as crypto;

${(model.generateFlutterFiles || model.isIcon).enabled}import 'package:flutter/material.dart';

import 'package:git_stamp/git_stamp.dart';

${model.commitList.enabled}import 'data/commit_list.dart';
${model.diffList.enabled}import 'data/diff_list.dart';
${model.diffStatList.enabled}import 'data/diff_stat_list.dart';
${model.buildBranch.enabled}import 'data/build_branch.dart';
${model.buildDateTime.enabled}import 'data/build_date_time.dart';
${model.buildSystemInfo.enabled}import 'data/build_system_info.dart';
${model.buildMachine.enabled}import 'data/build_machine.dart';
${model.repoCreationDate.enabled}import 'data/repo_creation_date.dart';
${model.repoPath.enabled}import 'data/repo_path.dart';
${model.observedFilesList.enabled}import 'data/observed_files_list.dart';
${model.appVersion.enabled}import 'data/app_version.dart';
${model.appBuild.enabled}import 'data/app_build.dart';
${model.appName.enabled}import 'data/app_name.dart';
${model.gitConfig.enabled}import 'data/git_config_global_user_name.dart';
${model.gitConfig.enabled}import 'data/git_config_global_user_email.dart';
${model.gitConfig.enabled}import 'data/git_config_user_name.dart';
${model.gitConfig.enabled}import 'data/git_config_user_email.dart';
${model.gitRemote.enabled}import 'data/git_remote.dart';
${model.gitConfigList.enabled}import 'data/git_config_list.dart';
${model.gitCountObjects.enabled}import 'data/git_count_objects.dart';
${model.gitTagList.enabled}import 'data/git_tag_list.dart';
${model.gitBranchList.enabled}import 'data/git_branch_list.dart';
${model.gitReflog.enabled}import 'data/git_reflog.dart';

${model.generateFlutterFiles.enabled}import 'git_stamp_is_lite_version.dart';
import 'git_stamp_tool_version.dart';
${model.encrypt.enabled}import 'git_stamp_encrypt_debug_key.dart';

${model.generateFlutterFiles.enabled}const bool isLiteVersion = gitStampIsLiteVersion;
const String gitStampVersion = gitStampToolVersion;

''';

String _decryptedImpl(GitStampBuildModel model) => '''
final GitStamp = DecryptedGitStampNode();

class DecryptedGitStampNode extends GitStampNode {
  @override bool get isEncrypted => false;
  @override bool decrypt(Uint8List key, Uint8List iv) => true;

  ${model.commitList.enabled}@override String get commitListString => gitStampCommitList;
  ${model.diffList.enabled}@override String get diffListString => gitStampDiffList;
  ${model.diffStatList.enabled}@override String get diffStatListString => gitStampDiffStatList;
  ${model.buildMachine.enabled}@override String get buildMachineString => gitStampBuildMachine;
  ${model.buildBranch.enabled}@override String get buildBranch => gitStampBuildBranch;
  ${model.buildDateTime.enabled}@override String get buildDateTime => gitStampBuildDateTime;
  ${model.buildSystemInfo.enabled}@override String get buildSystemInfo => gitStampBuildSystemInfo;
  ${model.repoCreationDate.enabled}@override String get repoCreationDate => gitStampRepoCreationDate;
  ${model.repoPath.enabled}@override String get repoPath => gitStampRepoPath;
  ${model.observedFilesList.enabled}@override String get observedFiles => gitStampObservedFilesList;
  ${model.gitTagList.enabled}@override String get tagListString => gitStampGitTagList;
  ${model.gitBranchList.enabled}@override String get branchListString => gitStampGitBranchList;
  ${model.appVersion.enabled}@override String get appVersion => gitStampAppVersion;
  ${model.appBuild.enabled}@override String get appBuild => gitStampAppBuild;
  ${model.appName.enabled}@override String get appName => gitStampAppName;
  ${model.gitConfig.enabled}@override String get gitConfigGlobalUserName => gitStampGitConfigGlobalUserName;
  ${model.gitConfig.enabled}@override String get gitConfigGlobalUserEmail => gitStampGitConfigGlobalUserEmail;
  ${model.gitConfig.enabled}@override String get gitConfigUserName => gitStampGitConfigUserName;
  ${model.gitConfig.enabled}@override String get gitConfigUserEmail => gitStampGitConfigUserEmail;
  ${model.gitRemote.enabled}@override String get gitRemote => gitStampGitRemoteList;
  ${model.gitConfigList.enabled}@override String get gitConfigList => gitStampGitConfigList;
  ${model.gitCountObjects.enabled}@override String get gitCountObjects => gitStampGitCountObjects;
  ${model.gitReflog.enabled}@override String get gitReflog => gitStampGitReflog;

  ${(model.generateFlutterFiles || model.isIcon).enabled}@override Widget icon() {
  ${(model.generateFlutterFiles || model.isIcon).enabled}  return GitStampIcon(gitStamp: this);
  ${(model.generateFlutterFiles || model.isIcon).enabled}}
  ${model.generateFlutterFiles.enabled}
  ${model.generateFlutterFiles.enabled}@override Widget listTile({required BuildContext context, String? monospaceFontFamily}) {
  ${model.generateFlutterFiles.enabled}  return GitStampListTile(
  ${model.generateFlutterFiles.enabled}    gitStamp: this,
  ${model.generateFlutterFiles.enabled}    gitStampVersion: gitStampVersion,
  ${model.generateFlutterFiles.enabled}    isLiteVersion: isLiteVersion,
  ${model.generateFlutterFiles.enabled}    onPressed: () {
  ${model.generateFlutterFiles.enabled}      showMainPage(
  ${model.generateFlutterFiles.enabled}        context: context,
  ${model.generateFlutterFiles.enabled}        monospaceFontFamily: monospaceFontFamily,
  ${model.generateFlutterFiles.enabled}      );
  ${model.generateFlutterFiles.enabled}    },
  ${model.generateFlutterFiles.enabled}  );
  ${model.generateFlutterFiles.enabled}}
  ${model.generateFlutterFiles.enabled}
  ${model.generateFlutterFiles.enabled}@override Widget mainPage({String? monospaceFontFamily, bool showDetails = false, bool showFiles = false}) {
  ${model.generateFlutterFiles.enabled}  return GitStampPage(
  ${model.generateFlutterFiles.enabled}    gitStamp: this,
  ${model.generateFlutterFiles.enabled}    gitStampVersion: gitStampVersion,
  ${model.generateFlutterFiles.enabled}    isLiteVersion: isLiteVersion,
  ${model.generateFlutterFiles.enabled}    monospaceFontFamily: monospaceFontFamily,
  ${model.generateFlutterFiles.enabled}    showDetails: showDetails,
  ${model.generateFlutterFiles.enabled}    showFiles: showFiles,
  ${(model.generateFlutterFiles && model.encrypt).enabled}    encryptDebugKey: GitStampEncryptDebugKey.key,
  ${(model.generateFlutterFiles && model.encrypt).enabled}    encryptDebugIv: GitStampEncryptDebugKey.iv,
  ${model.generateFlutterFiles.enabled}  );
  ${model.generateFlutterFiles.enabled}}
  ${model.generateFlutterFiles.enabled}
  ${model.generateFlutterFiles.enabled}@override Widget detailsPage({required GitStampCommit commit, String? monospaceFontFamily}) {
  ${model.generateFlutterFiles.enabled}  return GitStampDetailsPage(
  ${model.generateFlutterFiles.enabled}    gitStamp: this,
  ${model.generateFlutterFiles.enabled}    commit: commit,
  ${model.generateFlutterFiles.enabled}    monospaceFontFamily: monospaceFontFamily,
  ${model.generateFlutterFiles.enabled}  );
  ${model.generateFlutterFiles.enabled}}
  ${model.generateFlutterFiles.enabled}
  ${model.generateFlutterFiles.enabled}@override void showMainPage({required BuildContext context, String? monospaceFontFamily, bool useRootNavigator = false}) {
  ${model.generateFlutterFiles.enabled}  Navigator.of(context, rootNavigator: useRootNavigator).push(MaterialPageRoute<void>(
  ${model.generateFlutterFiles.enabled}    builder: (BuildContext context) {
  ${model.generateFlutterFiles.enabled}      return mainPage(monospaceFontFamily: monospaceFontFamily);
  ${model.generateFlutterFiles.enabled}    },
  ${model.generateFlutterFiles.enabled}  ));
  ${model.generateFlutterFiles.enabled}}
  ${model.generateFlutterFiles.enabled}
  ${model.generateFlutterFiles.enabled}@override void showDetailsPage({required BuildContext context, required GitStampCommit commit, String? monospaceFontFamily, bool useRootNavigator = false}) {
  ${model.generateFlutterFiles.enabled}  Navigator.of(context, rootNavigator: useRootNavigator).push(MaterialPageRoute<void>(
  ${model.generateFlutterFiles.enabled}    builder: (BuildContext context) {
  ${model.generateFlutterFiles.enabled}      return detailsPage(commit: commit, monospaceFontFamily: monospaceFontFamily);
  ${model.generateFlutterFiles.enabled}    },
  ${model.generateFlutterFiles.enabled}  ));
  ${model.generateFlutterFiles.enabled}}
  ${model.generateFlutterFiles.enabled}
  ${model.generateFlutterFiles.enabled}@override void showLicensePage({required BuildContext context, Widget? applicationIcon, String? applicationLegalese, bool useRootNavigator = false}) {
  ${model.generateFlutterFiles.enabled}  showGitStampLicensePage(
  ${model.generateFlutterFiles.enabled}    context: context,
  ${model.generateFlutterFiles.enabled}    gitStamp: this,
  ${model.generateFlutterFiles.enabled}    applicationIcon: applicationIcon,
  ${model.generateFlutterFiles.enabled}    applicationLegalese: applicationLegalese,
  ${model.generateFlutterFiles.enabled}    useRootNavigator: useRootNavigator,
  ${model.generateFlutterFiles.enabled}  );
  ${model.generateFlutterFiles.enabled}}
}
''';

String _encryptedImpl(
  String decryptedTestText,
  Uint8List encryptedTestText,
) =>
    '''
final GitStamp = EncryptedGitStampNode();

class EncryptedGitStampNode extends GitStampNode {
  static Uint8List? key;
  static Uint8List? iv;

  EncryptedGitStampNode();

  @override bool get isEncrypted => (key == null || iv == null);

  @override bool decrypt(Uint8List key, Uint8List iv) {
    EncryptedGitStampNode.key = key;
    EncryptedGitStampNode.iv = iv;

    bool success = false;

    try {
      success = _checkKeyAndIv();
    } catch (e) {
      success = false;
    }

    if (success == false) {
      EncryptedGitStampNode.key = null;
      EncryptedGitStampNode.iv = null;
    }

    return success;
  }

  String? _decrypt(Uint8List text) {
    if (isEncrypted) {
      return null;
    }

    return crypto.Encrypter(crypto.AES(crypto.Key(key!))).decrypt(crypto.Encrypted(text), iv: crypto.IV(iv!));
  }

  bool _checkKeyAndIv() => _decrypt(Uint8List.fromList($encryptedTestText)) == '$decryptedTestText';

  @override String get commitListString => _decrypt(gitStampCommitList) ?? '[]';
  @override String get sha => latestCommit?.hash ?? (isEncrypted ?'ENCRYPTED' : 'REPO WITHOUT COMMITS');
  @override String get diffListString => _decrypt(gitStampDiffList) ?? '[]';
  @override String get diffStatListString => _decrypt(gitStampDiffStatList) ?? '[]';
  @override String get buildMachineString => _decrypt(gitStampBuildMachine) ?? '{}';
  @override GitStampBuildMachine get buildMachine => isEncrypted ? GitStampBuildMachine.all('ENCRYPTED') : super.buildMachine;
  @override String get buildBranch => _decrypt(gitStampBuildBranch) ?? 'ENCRYPTED';
  @override String get buildDateTime => _decrypt(gitStampBuildDateTime) ?? 'ENCRYPTED';
  @override String get buildSystemInfo => _decrypt(gitStampBuildSystemInfo) ?? 'ENCRYPTED';
  @override String get repoCreationDate => _decrypt(gitStampRepoCreationDate) ?? 'ENCRYPTED';
  @override String get repoPath => _decrypt(gitStampRepoPath) ?? 'ENCRYPTED';
  @override String get observedFiles => _decrypt(gitStampObservedFilesList) ?? 'ENCRYPTED';
  @override String get tagListString => _decrypt(gitStampGitTagList) ?? 'ENCRYPTED';
  @override String get branchListString => _decrypt(gitStampGitBranchList) ?? 'ENCRYPTED';
  @override String get appVersionFull => !isEncrypted ? super.appVersionFull : 'ENCRYPTED';
  @override String get appVersion => _decrypt(gitStampAppVersion) ?? 'ENCRYPTED';
  @override String get appBuild => _decrypt(gitStampAppBuild) ?? 'ENCRYPTED';
  @override String get appName => _decrypt(gitStampAppName) ?? 'ENCRYPTED';
  @override String get gitConfigGlobalUser => !isEncrypted ? super.gitConfigGlobalUser : 'ENCRYPTED';
  @override String get gitConfigGlobalUserName => _decrypt(gitStampGitConfigGlobalUserName) ?? 'ENCRYPTED';
  @override String get gitConfigGlobalUserEmail => _decrypt(gitStampGitConfigGlobalUserEmail) ?? 'ENCRYPTED';
  @override String get gitConfigUser => !isEncrypted ? super.gitConfigUser : 'ENCRYPTED';
  @override String get gitConfigUserName => _decrypt(gitStampGitConfigUserName) ?? 'ENCRYPTED';
  @override String get gitConfigUserEmail => _decrypt(gitStampGitConfigUserEmail) ?? 'ENCRYPTED';
  @override String get gitRemote => _decrypt(gitStampGitRemoteList) ?? 'ENCRYPTED';
  @override String get gitConfigList => _decrypt(gitStampGitConfigList) ?? 'ENCRYPTED';
  @override String get gitCountObjects => _decrypt(gitStampGitCountObjects) ?? 'ENCRYPTED';
  @override String get gitReflog => _decrypt(gitStampGitReflog) ?? 'ENCRYPTED';

  @override Widget icon() {
    return GitStampIcon(gitStamp: this);
  }

  @override Widget listTile({required BuildContext context, String? monospaceFontFamily}) {
    return GitStampListTile(
      gitStamp: this,
      gitStampVersion: gitStampVersion,
      isLiteVersion: isLiteVersion,
      onPressed: () {
        showMainPage(
          context: context,
          monospaceFontFamily: monospaceFontFamily,
        );
      },
    );
  }

  @override Widget mainPage({String? monospaceFontFamily, bool showDetails = false, bool showFiles = false}) {
    return GitStampPage(
      gitStamp: this,
      gitStampVersion: gitStampVersion,
      isLiteVersion: isLiteVersion,
      monospaceFontFamily: monospaceFontFamily,
      showDetails: showDetails,
      showFiles: showFiles,
      encryptDebugKey: GitStampEncryptDebugKey.key,
      encryptDebugIv: GitStampEncryptDebugKey.iv,
    );
  }

  @override Widget detailsPage({required GitStampCommit commit, String? monospaceFontFamily}) {
    return GitStampDetailsPage(
      gitStamp: this,
      commit: commit,
      monospaceFontFamily: monospaceFontFamily,
    );
  }

  @override void showMainPage({required BuildContext context, String? monospaceFontFamily, bool useRootNavigator = false}) {
    Navigator.of(context, rootNavigator: useRootNavigator).push(MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return mainPage(monospaceFontFamily: monospaceFontFamily);
      },
    ));
  }

  @override void showDetailsPage({required BuildContext context, required GitStampCommit commit, String? monospaceFontFamily, bool useRootNavigator = false}) {
    Navigator.of(context, rootNavigator: useRootNavigator).push(MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return detailsPage(commit: commit, monospaceFontFamily: monospaceFontFamily);
      },
    ));
  }

  @override void showLicensePage({required BuildContext context, Widget? applicationIcon, String? applicationLegalese, bool useRootNavigator = false}) {
    showGitStampLicensePage(
      context: context,
      gitStamp: this,
      applicationIcon: applicationIcon,
      applicationLegalese: applicationLegalese,
      useRootNavigator: useRootNavigator,
    );
  }
}
''';
