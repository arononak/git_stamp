// Copyright © 2024 Aron Onak. All rights reserved.
// Licensed under the MIT license.
// If you have any feedback, please contact me at arononak@gmail.com

import 'dateable.dart';

/// The model used to store information about the [Commit].
///
/// Stores information about the commit.
class Commit extends Dateable {
  /// Example: `7e48e2e650e6f08e7a98d9c424d671d59bd271b2`.
  final String hash;

  /// Example: `refactor`.
  final String subject;

  /// Example: `2024-11-16 08:05:28 +0100`.
  @override
  final String date;

  /// Example: `Jan Pyta`.
  final String authorName;

  /// Example: `jan.pyta69@mail.com`.
  final String authorEmail;

  /// Creates an instance of [Commit].
  ///
  /// This constructor requires all fields.
  Commit({
    required this.hash,
    required this.subject,
    required this.date,
    required this.authorName,
    required this.authorEmail,
  });

  /// Creates an instance of [Commit].
  ///
  /// Requires json map.
  factory Commit.fromJson(Map<String, dynamic> json) => Commit(
    hash: json['hash'] ?? 'null',
    subject: json['subject'] ?? 'null',
    date: json['date'] ?? 'null',
    authorName: json['authorName'] ?? 'null',
    authorEmail: json['authorEmail'] ?? 'null',
  );
}
