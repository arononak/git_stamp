// ignore_for_file: avoid_print

class GitStampLogger {
  static void red(String message) {
    print('\x1B[31m$message\x1B[0m');
  }

  static void lightGrey(String message) {
    print('\x1B[90m$message\x1B[0m');
  }

  static void lightGreen(String message) {
    print('\x1B[92m$message\x1B[0m');
  }

  static void lightYellow(String message) {
    print('\x1B[93m$message\x1B[0m');
  }
}
