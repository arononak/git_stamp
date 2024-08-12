import 'dart:io';
import 'dart:math';

import './../git_stamp_logger.dart';

abstract class GitStampFile {
  String filename();
  String content();

  String getFileSize({int decimals = 1}) {
    const suffixes = ["B ", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    final fileSize = File(filename()).lengthSync();

    if (fileSize <= 0) {
      return "0 B";
    }

    final i = (log(fileSize) / log(1024)).floor();

    return '${(fileSize / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  void generate() {
    File(filename()).writeAsStringSync(content());
    
    final text = 'Generated ${getFileSize().padLeft(13)}               ${filename()}';
    GitStampLogger().logger.info(text);
  }
}
