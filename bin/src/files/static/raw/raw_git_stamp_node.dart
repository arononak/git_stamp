import 'dart:typed_data';

import '../../../../git_stamp_build_model.dart';

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

${(model.commitList || model.buildMachine).enabled}import 'dart:convert';

${model.generateFlutterFiles.enabled}import 'package:flutter/widgets.dart';
${model.generateFlutterFiles.enabled}import 'src/ui/git_stamp_license_page.dart';

${model.commitList.enabled}import 'src/data/commit_list.dart';
${model.commitList.enabled}import 'src/data/git_stamp_commit.dart';
${model.diffList.enabled}import 'src/data/diff_list.dart';
${model.diffStatList.enabled}import 'src/data/diff_stat_list.dart';
${model.buildBranch.enabled}import 'src/data/build_branch.dart';
${model.buildDateTime.enabled}import 'src/data/build_date_time.dart';
${model.buildSystemInfo.enabled}import 'src/data/build_system_info.dart';
${model.buildMachine.enabled}import 'src/data/git_stamp_build_machine.dart';
${model.buildMachine.enabled}import 'src/data/build_machine.dart';
${model.repoCreationDate.enabled}import 'src/data/repo_creation_date.dart';
${model.repoPath.enabled}import 'src/data/repo_path.dart';
${model.observedFilesList.enabled}import 'src/data/observed_files_list.dart';
${model.appVersion.enabled}import 'src/data/app_version.dart';
${model.appBuild.enabled}import 'src/data/app_build.dart';
${model.appName.enabled}import 'src/data/app_name.dart';
${model.gitConfig.enabled}import 'src/data/git_config_global_user_name.dart';
${model.gitConfig.enabled}import 'src/data/git_config_global_user_email.dart';
${model.gitConfig.enabled}import 'src/data/git_config_user_name.dart';
${model.gitConfig.enabled}import 'src/data/git_config_user_email.dart';
${model.gitRemote.enabled}import 'src/data/git_remote.dart';
${model.gitConfigList.enabled}import 'src/data/git_config_list.dart';
${model.gitCountObjects.enabled}import 'src/data/git_count_objects.dart';

${model.encrypt.enabled}import 'dart:typed_data';
${model.encrypt.enabled}import 'package:encrypt/encrypt.dart' as crypto;

abstract class GitStampNode {
  ${model.commitList.enabled}String get commitListString;
  ${model.commitList.enabled}List<GitStampCommit> get commitList;
  ${model.commitList.enabled}GitStampCommit? get latestCommit;
  ${model.commitList.enabled}String get sha;
  ${model.commitList.enabled}int get commitCount;

  ${model.diffList.enabled}String get diffListString;
  ${model.diffList.enabled}Map<String, dynamic> get diffList;
  ${model.diffStatList.enabled}String get diffStatListString;
  ${model.diffStatList.enabled}Map<String, dynamic> get diffStatList;

  ${model.buildMachine.enabled}String get buildMachineString;
  ${model.buildMachine.enabled}GitStampBuildMachine get buildMachine;

  ${model.buildBranch.enabled}String get buildBranch;
  ${model.buildDateTime.enabled}String get buildDateTime;
  ${model.buildSystemInfo.enabled}String get buildSystemInfo;
  ${model.repoCreationDate.enabled}String get repoCreationDate;
  ${model.repoPath.enabled}String get repoPath;
  
  ${model.observedFilesList.enabled}String get observedFiles;
  ${model.observedFilesList.enabled}List<String> get observedFilesList;
  ${model.observedFilesList.enabled}int get observedFilesCount;
  
  ${model.appVersion.enabled}String get appVersion;
  ${model.appBuild.enabled}String get appBuild;
  ${model.appName.enabled}String get appName;

  ${model.gitConfig.enabled}String get gitConfigGlobalUserName;
  ${model.gitConfig.enabled}String get gitConfigGlobalUserEmail;
  ${model.gitConfig.enabled}String get gitConfigUserName;
  ${model.gitConfig.enabled}String get gitConfigUserEmail;
  ${model.gitRemote.enabled}String get gitRemote;
  ${model.gitConfigList.enabled}String get gitConfigList;
  ${model.gitCountObjects.enabled}String get gitCountObjects;

  ${model.generateFlutterFiles.enabled}void showLicensePage({
  ${model.generateFlutterFiles.enabled}  required BuildContext context,
  ${model.generateFlutterFiles.enabled}  Widget? applicationIcon,
  ${model.generateFlutterFiles.enabled}  String? applicationLegalese,
  ${model.generateFlutterFiles.enabled}  bool useRootNavigator = false,
  ${model.generateFlutterFiles.enabled}});
}
''';

String _decryptedImpl(GitStampBuildModel model) => '''
class DecryptedGitStampNode implements GitStampNode {
  bool get isEncrypted => false;

  ${model.commitList.enabled}@override String get commitListString => gitStampCommitList;
  ${model.commitList.enabled}@override List<GitStampCommit> get commitList => json.decode(commitListString).map<GitStampCommit>((json) => GitStampCommit.fromJson(json)).toList();
  ${model.commitList.enabled}@override GitStampCommit? get latestCommit => commitList.firstOrNull;
  ${model.commitList.enabled}@override String get sha => latestCommit?.hash ?? 'REPO WITHOUT COMMITS';
  ${model.commitList.enabled}@override int get commitCount => commitList.length;

  ${model.diffList.enabled}@override String get diffListString => gitStampDiffList;
  ${model.diffList.enabled}@override Map<String, dynamic> get diffList => json.decode(diffListString.replaceAll(r"\\'", "'"));
  ${model.diffStatList.enabled}@override String get diffStatListString => gitStampDiffStatList;
  ${model.diffStatList.enabled}@override Map<String, dynamic> get diffStatList => json.decode(diffStatListString.replaceAll(r"\\'", "'"));

  ${model.buildMachine.enabled}@override String get buildMachineString => gitStampBuildMachine;
  ${model.buildMachine.enabled}@override GitStampBuildMachine get buildMachine => GitStampBuildMachine.fromJson(json.decode(buildMachineString));
  
  ${model.buildBranch.enabled}@override String get buildBranch => gitStampBuildBranch;
  ${model.buildDateTime.enabled}@override String get buildDateTime => gitStampBuildDateTime;
  ${model.buildSystemInfo.enabled}@override String get buildSystemInfo => gitStampBuildSystemInfo;
  ${model.repoCreationDate.enabled}@override String get repoCreationDate => gitStampRepoCreationDate;
  ${model.repoPath.enabled}@override String get repoPath => gitStampRepoPath;
  
  ${model.observedFilesList.enabled}@override String get observedFiles => gitStampObservedFilesList;
  ${model.observedFilesList.enabled}@override List<String> get observedFilesList => observedFiles.split(RegExp(r'\\r?\\n'));
  ${model.observedFilesList.enabled}@override int get observedFilesCount => observedFilesList.length;
  
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

  ${model.generateFlutterFiles.enabled}@override void showLicensePage({required BuildContext context, Widget? applicationIcon, String? applicationLegalese, bool useRootNavigator = false}) {
  ${model.generateFlutterFiles.enabled}  showGitStampLicensePage(
  ${model.generateFlutterFiles.enabled}    context: context,
  ${model.generateFlutterFiles.enabled}    applicationIcon: applicationIcon,
  ${model.generateFlutterFiles.enabled}    applicationLegalese: applicationLegalese,
  ${model.generateFlutterFiles.enabled}    useRootNavigator: useRootNavigator,
  ${model.generateFlutterFiles.enabled}  );
  ${model.generateFlutterFiles.enabled}}
}

final GitStamp = DecryptedGitStampNode();
''';

String _encryptedImpl(
  String decryptedTestText,
  Uint8List encryptedTestText,
) =>
    '''
class EncryptedGitStampNode implements GitStampNode {
  static Uint8List? key;
  static Uint8List? iv;

  EncryptedGitStampNode();

  bool get isEncrypted => (key == null || iv == null);

  bool decrypt(Uint8List key, Uint8List iv) {
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
  @override List<GitStampCommit> get commitList => json.decode(commitListString).map<GitStampCommit>((json) => GitStampCommit.fromJson(json)).toList();
  @override GitStampCommit? get latestCommit => commitList.firstOrNull;
  @override String get sha => latestCommit?.hash ?? (isEncrypted ?'ECRYPTED' : 'REPO WITHOUT COMMITS');
  @override int get commitCount => commitList.length;

  @override String get diffListString => _decrypt(gitStampDiffList) ?? '[]';
  @override Map<String, dynamic> get diffList => json.decode(diffListString.replaceAll(r"\\'", "'"));
  @override String get diffStatListString => _decrypt(gitStampDiffStatList) ?? '[]';
  @override Map<String, dynamic> get diffStatList => json.decode(diffStatListString.replaceAll(r"\\'", "'"));

  @override String get buildMachineString => _decrypt(gitStampBuildMachine) ?? '{}';
  @override GitStampBuildMachine get buildMachine => GitStampBuildMachine.fromJson(json.decode(buildMachineString));
  
  @override String get buildBranch => _decrypt(gitStampBuildBranch) ?? 'ECRYPTED';
  @override String get buildDateTime => _decrypt(gitStampBuildDateTime) ?? 'ECRYPTED';
  @override String get buildSystemInfo => _decrypt(gitStampBuildSystemInfo) ?? 'ECRYPTED';
  @override String get repoCreationDate => _decrypt(gitStampRepoCreationDate) ?? 'ECRYPTED';
  @override String get repoPath => _decrypt(gitStampRepoPath) ?? 'ECRYPTED';
  
  @override String get observedFiles => _decrypt(gitStampObservedFilesList) ?? 'ECRYPTED';
  @override List<String> get observedFilesList => observedFiles.split(RegExp(r'\\r?\\n'));
  @override int get observedFilesCount => observedFilesList.length;
  
  @override String get appVersion => _decrypt(gitStampAppVersion) ?? 'ECRYPTED';
  @override String get appBuild => _decrypt(gitStampAppBuild) ?? 'ECRYPTED';
  @override String get appName => _decrypt(gitStampAppName) ?? 'ECRYPTED';

  @override String get gitConfigGlobalUserName => _decrypt(gitStampGitConfigGlobalUserName) ?? 'ECRYPTED';
  @override String get gitConfigGlobalUserEmail => _decrypt(gitStampGitConfigGlobalUserEmail) ?? 'ECRYPTED';
  @override String get gitConfigUserName => _decrypt(gitStampGitConfigUserName) ?? 'ECRYPTED';
  @override String get gitConfigUserEmail => _decrypt(gitStampGitConfigUserEmail) ?? 'ECRYPTED';
  @override String get gitRemote => _decrypt(gitStampGitRemoteList) ?? 'ECRYPTED';
  @override String get gitConfigList => _decrypt(gitStampGitConfigList) ?? 'ECRYPTED';
  @override String get gitCountObjects => _decrypt(gitStampGitCountObjects) ?? 'ECRYPTED';

  @override void showLicensePage({required BuildContext context, Widget? applicationIcon, String? applicationLegalese, bool useRootNavigator = false}) {
    showGitStampLicensePage(
      context: context,
      applicationIcon: applicationIcon,
      applicationLegalese: applicationLegalese,
      useRootNavigator: useRootNavigator,
    );
  }
}

final GitStamp = EncryptedGitStampNode();
''';
