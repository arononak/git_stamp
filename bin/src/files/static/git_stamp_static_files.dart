import 'raw/raw_git_stamp.dart';
import 'raw/raw_git_stamp_node.dart';
import 'raw/raw_git_stamp_commit.dart';
import 'raw/raw_git_stamp_details_page.dart';
import 'raw/raw_git_stamp_launcher.dart';
import 'raw/raw_git_stamp_page.dart';
import 'raw/raw_git_stamp_utils.dart';
import 'raw/raw_git_stamp_icon.dart';
import 'raw/raw_git_stamp_license_page.dart';
import '../../git_stamp_build.dart';
import '../../git_stamp_directory.dart';
import '../../git_stamp_file.dart';

class GitStampMainFile extends GitStampFile {
  final bool generateFlutterFiles;

  GitStampMainFile(this.generateFlutterFiles);

  @override
  String filename() => '${GitStampDirectory.mainFolder}/git_stamp.dart';

  @override
  String content() => rawGitStamp(generateFlutterFiles);
}

class GitStampNode extends GitStampFile {
  final GitStampBuild dataFiles;

  GitStampNode(this.dataFiles);

  @override
  String filename() => '${GitStampDirectory.mainFolder}/git_stamp_node.dart';

  @override
  String content() => rawGitStampNode(dataFiles);
}

class GitStampUtils extends GitStampFile {
  @override
  String filename() => '${GitStampDirectory.uiFolder}/git_stamp_utils.dart';

  @override
  String content() => rawGitStampUtils;
}

class GitStampLauncher extends GitStampFile {
  @override
  String filename() => '${GitStampDirectory.uiFolder}/git_stamp_launcher.dart';

  @override
  String content() => rawGitStampLauncher;
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
  String filename() => '${GitStampDirectory.uiFolder}/git_stamp_icon.dart';

  @override
  String content() => rawGitStampIcon;
}

class GitStampLicensePage extends GitStampFile {
  @override
  String filename() =>
      '${GitStampDirectory.uiFolder}/git_stamp_license_page.dart';

  @override
  String content() => rawGitStampLicensePage;
}
