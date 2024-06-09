const rawGitStamp = '''
library git_stamp;

import 'dart:convert';

import 'src/git_stamp_commit.dart';

import 'src/data/branch_output.dart';
import 'src/data/build_date_time_output.dart';
import 'src/data/build_system_info_output.dart';
import 'src/data/creation_date_output.dart';
import 'src/data/diff_output.dart';
import 'src/data/generated_version.dart';
import 'src/data/json_output.dart';
import 'src/data/observed_files.dart';
import 'src/data/repo_path_output.dart';

class GitStamp {
  static const buildBranch = generatedBuildBranch;
  static const buildDateTime = generatedBuildDateTime;
  static const buildSystemInfo = generatedBuildSystemInfo;
  static const repoCreationDate = generatedRepoCreationDate;
  static const diffOutput = generatedDiffOutput;
  static const isLiteVersion = generatedIsLiteVersion;
  static const jsonOutput = generatedJsonOutput;
  static const repoPath = generatedRepoPath;
  static const observedFiles = generatedObservedFiles;

  static List<GitStampCommit> get commitList => json
      .decode(GitStamp.jsonOutput)
      .map<GitStampCommit>((json) => GitStampCommit.fromJson(json))
      .toList();

  static GitStampCommit get latestCommit => commitList.first;
}

''';
