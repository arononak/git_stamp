import 'dart:io';
import 'dart:math';

import './../git_stamp_logger.dart';

String fileSize(String path, {int decimals = 1}) {
  final size = File(path).lengthSync();

  return formatSize(size, decimals: decimals);
}

String directorySize(String path, {int decimals = 1}) {
  int size = 0;

  for (var e in Directory(path).listSync(recursive: true, followLinks: false)) {
    if (e is File) {
      size += e.lengthSync();
    }
  }

  return formatSize(size, decimals: decimals);
}

String formatSize(int size, {int decimals = 1}) {
  const suffixes = ["B ", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];

  if (size <= 0) {
    return "0 B";
  }

  final i = (log(size) / log(1024)).floor();

  return '${(size / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}

abstract class _GitStampFile {
  String get directory;
  String get filename => '';
  String get content => '';

  String get path => '$directory/$filename';

  String getFileSize({int decimals = 1}) {
    return fileSize(path, decimals: decimals);
  }

  void generate() {
    File(path).writeAsStringSync(content);

    final text = 'Generated ${getFileSize().padLeft(13)}               $path';
    GitStampLogger().logger.info(text);
  }
}

class GitStampMainFile extends _GitStampFile {
  @override
  String get directory => 'lib/git_stamp';
}

class GitStampSrcFile extends _GitStampFile {
  @override
  String get directory => 'lib/git_stamp/src';
}

class GitStampDataFile extends _GitStampFile {
  @override
  String get directory => 'lib/git_stamp/src/data';
}

class GitStampUiFile extends _GitStampFile {
  @override
  String get directory => 'lib/git_stamp/src/ui';
}

abstract class GitStampDirectory {
  static Future<void> recreateDirectories() async {
    final mainDirectory = Directory(GitStampMainFile().path);

    if (await mainDirectory.exists()) {
      mainDirectory.deleteSync(recursive: true);
    }

    final gitStampFiles = [
      GitStampMainFile().path,
      GitStampSrcFile().path,
      GitStampDataFile().path,
      GitStampUiFile().path,
    ];

    for (var e in gitStampFiles) {
      Directory(e).createSync(recursive: true);
    }
  }
}
