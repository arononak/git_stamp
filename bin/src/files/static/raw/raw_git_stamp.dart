import '../../../git_stamp_build.dart';

extension BoolExtension on bool {
  String get enabled => this ? '' : '//';
}

String rawGitStamp(GitStampBuild files) => '''
library git_stamp;

${files.commitList.enabled} import 'dart:convert';
${files.commitList.enabled} import 'src/data/commit_list.dart';
${files.commitList.enabled} import 'src/git_stamp_commit.dart';

${files.diffList.enabled} import 'src/data/diff_list.dart';

${files.buildBranch.enabled} import 'src/data/build_branch.dart';
${files.buildDateTime.enabled} import 'src/data/build_date_time.dart';
${files.buildSystemInfo.enabled} import 'src/data/build_system_info.dart';
${files.repoCreationDate.enabled} import 'src/data/repo_creation_date.dart';
${files.repoPath.enabled} import 'src/data/repo_path.dart';
${files.observedFilesList.enabled} import 'src/data/observed_files_list.dart';

${files.generateFlutterFiles.enabled} import 'src/data/is_lite_version.dart';
${files.generateFlutterFiles.enabled} export 'src/git_stamp_commit.dart';
${files.generateFlutterFiles.enabled} export 'src/git_stamp_details_page.dart';
${files.generateFlutterFiles.enabled} export 'src/git_stamp_launcher.dart';
${files.generateFlutterFiles.enabled} export 'src/git_stamp_page.dart';
${files.generateFlutterFiles.enabled} export 'src/git_stamp_utils.dart';

class GitStamp {
  ${files.commitList.enabled} static List<GitStampCommit> get commitList => json.decode(gitStampCommitList).map<GitStampCommit>((json) => GitStampCommit.fromJson(json)).toList();
  ${files.commitList.enabled} static GitStampCommit get latestCommit => commitList.first;

  ${files.diffList.enabled} static const Map<String, String> diffList = gitStampDiffList;

  ${files.buildBranch.enabled} static const String buildBranch = gitStampBuildBranch;
  ${files.buildDateTime.enabled} static const String buildDateTime = gitStampBuildDateTime;
  ${files.buildSystemInfo.enabled} static const String buildSystemInfo = gitStampBuildSystemInfo;
  ${files.repoCreationDate.enabled} static const String repoCreationDate = gitStampRepoCreationDate;
  ${files.repoPath.enabled} static const String repoPath = gitStampRepoPath;
  ${files.observedFilesList.enabled} static const String observedFilesList = gitStampObservedFilesList;

  ${files.generateFlutterFiles.enabled} static const bool isLiteVersion = gitStampIsLiteVersion;
}
''';
