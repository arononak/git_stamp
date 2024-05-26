const generatedGitStamp = '''
library git_stamp;

import 'data/branch_output.dart';
import 'data/build_date_time_output.dart';
import 'data/build_system_info_output.dart';
import 'data/creation_date_output.dart';
import 'data/diff_output.dart';
import 'data/generated_version.dart';
import 'data/json_output.dart';
import 'data/repo_path_output.dart';

export 'git_stamp_page.dart';

class GitStamp {
  static const buildBranch = generatedBuildBranch;
  static const buildDateTime = generatedBuildDateTime;
  static const buildSystemInfo = generatedBuildSystemInfo;
  static const repoCreationDate = generatedRepoCreationDate;
  static const diffOutput = generatedDiffOutput;
  static const isLiteVersion = generatedIsLiteVersion;
  static const jsonOutput = generatedJsonOutput;
  static const repoPath = generatedRepoPath;
}

''';
