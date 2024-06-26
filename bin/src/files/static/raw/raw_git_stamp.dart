const rawGitStamp = '''
library git_stamp;

import 'dart:convert';

import 'src/data/build_branch.dart';
import 'src/data/build_date_time.dart';
import 'src/data/build_system_info.dart';
import 'src/data/commit_list.dart';
import 'src/data/diff_list.dart';
import 'src/data/is_lite_version.dart';
import 'src/data/observed_files_list.dart';
import 'src/data/repo_creation_date.dart';
import 'src/data/repo_path.dart';
import 'src/git_stamp_commit.dart';

export 'src/git_stamp_commit.dart';
export 'src/git_stamp_details_page.dart';
export 'src/git_stamp_launcher.dart';
export 'src/git_stamp_page.dart';
export 'src/git_stamp_utils.dart';

class GitStamp {
  static List<GitStampCommit> get commitList => json
      .decode(gitStampCommitList)
      .map<GitStampCommit>((json) => GitStampCommit.fromJson(json))
      .toList();

  static const Map<String, String> diffList = gitStampDiffList;

  static GitStampCommit get latestCommit => commitList.first;

  static const String buildBranch = gitStampBuildBranch;
  static const String buildDateTime = gitStampBuildDateTime;
  static const String buildSystemInfo = gitStampBuildSystemInfo;
  static const String repoCreationDate = gitStampRepoCreationDate;
  static const bool isLiteVersion = gitStampIsLiteVersion;
  static const String repoPath = gitStampRepoPath;
  static const String observedFilesList = gitStampObservedFilesList;
}
''';
