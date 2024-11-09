// Copyright © 2024 Aron Onak. All rights reserved.
// Licensed under the MIT license.
// If you have any feedback, please contact me at arononak@gmail.com

import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';

import 'git_stamp_logger.dart';

class GitStampEncrypt {
  static Key generateKey() => Key.fromSecureRandom(32);

  static IV generateIv() => IV.fromSecureRandom(16);

  static Uint8List encrypt(String text, Key key, IV iv) {
    return Encrypter(AES(key)).encrypt(text, iv: iv).bytes;
  }

  static String decrypt(Uint8List text, key, iv) {
    return Encrypter(AES(Key(key))).decrypt(Encrypted(text), iv: IV(iv));
  }

  static void printKeyAndIv(Key key, IV iv) {
    final hexKey = key.bytes.asHex;
    final hexIv = iv.bytes.asHex;

    GitStampLogger.lightYellow('KEY: ${hexKey.join(' ')}');
    GitStampLogger.lightYellow('IV: ${hexIv.join(' ')}');
    GitStampLogger.lightYellow('');
  }
}

extension UintExtension on Uint8List {
  List<String> get asHex =>
      map((e) => e.toRadixString(16).padLeft(2, '0').toUpperCase()).toList();
}
