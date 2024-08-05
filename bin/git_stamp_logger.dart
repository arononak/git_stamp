// ignore_for_file: avoid_print

import 'package:logging/logging.dart';

class GitStampLogger {
  static final GitStampLogger _instance = GitStampLogger._internal();
  factory GitStampLogger() => _instance;
  
  late Logger logger;

  GitStampLogger._internal() {
    logger = Logger('GitStampLogger');
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) => _print(rec));
  }

  void _print(LogRecord rec) {
    switch (rec.level.name) {
      case 'SEVERE':
        print('\x1B[31m${rec.level.name}:\t${rec.message}\x1B[0m');
        break;
      case 'WARNING':
        print('\x1B[90m${rec.level.name}:\t${rec.message}\x1B[0m');
        break;
      case 'INFO':
        print('\x1B[90m${rec.level.name}:\t${rec.message}\x1B[0m');
        break;
      case 'CONFIG':
        print('\x1B[92m${rec.message}\x1B[0m');
      case 'FINE':
      case 'FINER':
      case 'FINEST':
        print('\x1B[93m${rec.message}\x1B[0m');
        break;
      default:
        print('\x1B[0m${rec.level.name}:\t${rec.message}\x1B[0m');
    }
  }
}
