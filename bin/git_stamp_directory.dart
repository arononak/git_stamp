import 'dart:io';

abstract class GitStampDirectory {
  static const mainFolder = 'lib/git_stamp';
  static const dataFolder = 'lib/git_stamp/data';

  static void recreateDirectories() {
    Directory(mainFolder).deleteSync(recursive: true);

    Directory(mainFolder).createSync(recursive: true);
    Directory(dataFolder).createSync(recursive: true);
  }
}
