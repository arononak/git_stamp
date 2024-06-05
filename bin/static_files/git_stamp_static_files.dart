import 'contents/content_git_stamp.dart';
import 'contents/content_git_stamp_commit.dart';
import 'contents/content_git_stamp_details_page.dart';
import 'contents/content_git_stamp_launcher_empty.dart';
import 'contents/content_git_stamp_page.dart';
import 'contents/content_git_stamp_utils.dart';
import '../git_stamp_directory.dart';
import '../git_stamp_file.dart';

class GitStampUtils extends GitStampFile {
  @override
  String filename() => '${GitStampDirectory.mainFolder}/git_stamp_utils.dart';

  @override
  String content() => contentGitStampUtils;
}

class GitStampLauncher extends GitStampFile {
  final bool useUrlLauncher;

  GitStampLauncher(this.useUrlLauncher);

  @override
  String filename() =>
      '${GitStampDirectory.mainFolder}/git_stamp_launcher.dart';

  @override
  String content() =>
      useUrlLauncher ? contentGitStampUtils : contentGitStampLauncherEmpty;
}

class GitStampCommit extends GitStampFile {
  @override
  String filename() => '${GitStampDirectory.mainFolder}/git_stamp_commit.dart';

  @override
  String content() => contentGitStampCommit;
}

class GitStampPage extends GitStampFile {
  @override
  String filename() => '${GitStampDirectory.mainFolder}/git_stamp_page.dart';

  @override
  String content() => contentGitStampPage;
}

class GitStampDetailsPage extends GitStampFile {
  @override
  String filename() =>
      '${GitStampDirectory.mainFolder}/git_stamp_details_page.dart';

  @override
  String content() => contentGitStampDetailsPage;
}

class GitStampNodeFile extends GitStampFile {
  @override
  String filename() => '${GitStampDirectory.mainFolder}/git_stamp.dart';

  @override
  String content() => contentGitStamp;
}
