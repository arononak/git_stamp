import 'dart:io';
import 'dart:math';

import './../git_stamp_logger.dart';

abstract class GitStampFile {
  String filename();
  String content();

  String getFileSize({int decimals = 2}) {
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    final bytes = File(filename()).lengthSync();

    if (bytes <= 0) {
      return "0 B";
    }

    final i = (log(bytes) / log(1024)).floor();

    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  void generate() {
    File(filename()).writeAsStringSync(content());
    GitStampLogger()
        .logger
        .info('Generated - ${getFileSize()} \t ${filename()}');
  }
}
