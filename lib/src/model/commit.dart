// Copyright © 2024 Aron Onak. All rights reserved.
// Licensed under the MIT license.
// If you have any feedback, please contact me at arononak@gmail.com

import 'dateable.dart';

/// The model used to store information about the Commit.
class Commit extends Dateable {
  final String hash;
  final String subject;
  @override
  final String date;
  final String authorName;
  final String authorEmail;

  Commit({
    required this.hash,
    required this.subject,
    required this.date,
    required this.authorName,
    required this.authorEmail,
  });

  factory Commit.fromJson(Map<String, dynamic> json) => Commit(
        hash: json['hash'] ?? 'null',
        subject: json['subject'] ?? 'null',
        date: json['date'] ?? 'null',
        authorName: json['authorName'] ?? 'null',
        authorEmail: json['authorEmail'] ?? 'null',
      );
}
