import 'raw/raw_git_stamp.dart';
import 'raw/raw_git_stamp_node.dart';
import 'raw/raw_git_stamp_commit.dart';
import 'raw/raw_git_stamp_build_machine.dart';
import 'raw/raw_git_stamp_details_page.dart';
import 'raw/raw_git_stamp_launcher.dart';
import 'raw/raw_git_stamp_page.dart';
import 'raw/raw_git_stamp_utils.dart';
import 'raw/raw_git_stamp_icon.dart';
import 'raw/raw_git_stamp_list_tile.dart';
import 'raw/raw_git_stamp_license_page.dart';
import 'raw/raw_git_stamp_decrypt_bottom_sheet.dart';
import 'raw/raw_git_stamp_decrypt_bottom_sheet_stub.dart';
import '../../git_stamp_files.dart';
import '../../git_stamp_build_model.dart';

class GitStampMain extends GitStampMainFile {
  final GitStampBuildModel model;

  GitStampMain(this.model);

  @override
  String get filename => 'git_stamp.dart';

  @override
  String get content => rawGitStamp(
        model.generateFlutterFiles,
        model.generateFlutterIcon,
      );
}

class GitStampNode extends GitStampMainFile {
  final GitStampBuildModel model;
  final String decryptedTestText;
  final dynamic encryptedTestText;

  GitStampNode(this.model, this.decryptedTestText, this.encryptedTestText);

  @override
  String get filename => 'git_stamp_node.dart';

  @override
  String get content => rawGitStampNode(
        model,
        decryptedTestText,
        encryptedTestText,
      );
}

class GitStampUtils extends GitStampUiFile {
  @override
  String get filename => 'git_stamp_utils.dart';

  @override
  String get content => rawGitStampUtils;
}

class GitStampLauncher extends GitStampUiFile {
  @override
  String get filename => 'git_stamp_launcher.dart';

  @override
  String get content => rawGitStampLauncher;
}

class GitStampCommit extends GitStampDataFile {
  GitStampCommit() : super(null);

  @override
  String get filename => 'git_stamp_commit.dart';

  @override
  String get content => rawGitStampCommit;
}

class GitStampBuildMachine extends GitStampDataFile {
  GitStampBuildMachine() : super(null);

  @override
  String get filename => 'git_stamp_build_machine.dart';

  @override
  String get content => rawGitStampBuildMachine;
}

class GitStampPage extends GitStampUiFile {
  @override
  String get filename => 'git_stamp_page.dart';

  @override
  String get content => rawGitStampPage;
}

class GitStampDetailsPage extends GitStampUiFile {
  @override
  String get filename => 'git_stamp_details_page.dart';

  @override
  String get content => rawGitStampDetailsPage;
}

class GitStampIcon extends GitStampUiFile {
  @override
  String get filename => 'git_stamp_icon.dart';

  @override
  String get content => rawGitStampIcon;
}

class GitStampListTile extends GitStampUiFile {
  @override
  String get filename => 'git_stamp_list_tile.dart';

  @override
  String get content => rawGitStampListTile;
}

class GitStampLicensePage extends GitStampUiFile {
  @override
  String get filename => 'git_stamp_license_page.dart';

  @override
  String get content => rawGitStampLicensePage;
}

class GitStampDecryptBottomSheet extends GitStampUiFile {
  bool isStub;

  GitStampDecryptBottomSheet(this.isStub);

  @override
  String get filename => 'git_stamp_decrypt_bottom_sheet.dart';

  @override
  String get content => isStub
      ? rawGitStampDecryptBottomSheetStub
      : rawGitStampDecryptBottomSheet;
}
