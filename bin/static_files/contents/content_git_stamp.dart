const contentGitStamp = '''
library git_stamp;

import 'dart:convert';

import 'data/branch_output.dart';
import 'data/build_date_time_output.dart';
import 'data/build_system_info_output.dart';
import 'data/creation_date_output.dart';
import 'data/diff_output.dart';
import 'data/generated_version.dart';
import 'data/json_output.dart';
import 'data/repo_path_output.dart';

import 'git_stamp_commit.dart';

class GitStamp {
  static const buildBranch = generatedBuildBranch;
  static const buildDateTime = generatedBuildDateTime;
  static const buildSystemInfo = generatedBuildSystemInfo;
  static const repoCreationDate = generatedRepoCreationDate;
  static const diffOutput = generatedDiffOutput;
  static const isLiteVersion = generatedIsLiteVersion;
  static const jsonOutput = generatedJsonOutput;
  static const repoPath = generatedRepoPath;

  static List<GitStampCommit> get commitList => json
      .decode(GitStamp.jsonOutput)
      .map<GitStampCommit>((json) => GitStampCommit.fromJson(json))
      .toList();

  static GitStampCommit get latestCommit => commitList.first;
}

''';
