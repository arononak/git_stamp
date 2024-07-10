import 'raw/raw_git_stamp.dart';
import 'raw/raw_git_stamp_commit.dart';
import 'raw/raw_git_stamp_details_page.dart';
import 'raw/raw_git_stamp_launcher.dart';
import 'raw/raw_git_stamp_launcher_empty.dart';
import 'raw/raw_git_stamp_page.dart';
import 'raw/raw_git_stamp_utils.dart';
import 'raw/raw_git_stamp_icon.dart';
import '../../git_stamp_build.dart';
import '../../git_stamp_directory.dart';
import '../../git_stamp_file.dart';

class GitStampNode extends GitStampFile {
  final GitStampBuild dataFiles;

  GitStampNode(this.dataFiles);

  @override
  String filename() => '${GitStampDirectory.mainFolder}/git_stamp.dart';

  @override
  String content() => rawGitStamp(dataFiles);
}

class GitStampUtils extends GitStampFile {
  @override
  String filename() => '${GitStampDirectory.uiFolder}/git_stamp_utils.dart';

  @override
  String content() => rawGitStampUtils;
}

class GitStampLauncher extends GitStampFile {
  final bool useUrlLauncher;

  GitStampLauncher(this.useUrlLauncher);

  @override
  String filename() => '${GitStampDirectory.uiFolder}/git_stamp_launcher.dart';

  @override
  String content() =>
      useUrlLauncher ? rawGitStampLauncher : rawGitStampLauncherEmpty;
}

class GitStampCommit extends GitStampFile {
  @override
  String filename() => '${GitStampDirectory.dataFolder}/git_stamp_commit.dart';

  @override
  String content() => rawGitStampCommit;
}

class GitStampPage extends GitStampFile {
  @override
  String filename() => '${GitStampDirectory.uiFolder}/git_stamp_page.dart';

  @override
  String content() => rawGitStampPage;
}

class GitStampDetailsPage extends GitStampFile {
  @override
  String filename() =>
      '${GitStampDirectory.uiFolder}/git_stamp_details_page.dart';

  @override
  String content() => rawGitStampDetailsPage;
}

class GitStampIcon extends GitStampFile {
  @override
  String filename() =>
      '${GitStampDirectory.uiFolder}/git_stamp_icon.dart';

  @override
  String content() => rawGitStampIcon;
}
