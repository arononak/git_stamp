import 'dart:io';
import 'dart:math';

import './../git_stamp_logger.dart';

abstract class GitStampFile {
  String directory();
  String filename();
  String content();

  String get path => '${directory()}/${filename()}';

  String getFileSize({int decimals = 1}) {
    const suffixes = ["B ", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    final fileSize = File(path).lengthSync();

    if (fileSize <= 0) {
      return "0 B";
    }

    final i = (log(fileSize) / log(1024)).floor();

    return '${(fileSize / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  void generate() {
    File(path).writeAsStringSync(content());

    final text = 'Generated ${getFileSize().padLeft(13)}               $path';
    GitStampLogger().logger.info(text);
  }
}
