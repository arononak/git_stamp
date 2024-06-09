import 'dart:io';

abstract class GitStampDirectory {
  static const mainFolder = 'lib/git_stamp';
  static const srcFolder = 'lib/git_stamp/src';
  static const dataFolder = 'lib/git_stamp/src/data';

  static void recreateDirectories() {
    Directory(mainFolder).deleteSync(recursive: true);

    for (var e in [mainFolder, srcFolder, dataFolder]) {
      Directory(e).createSync(recursive: true);
    }
  }
}
