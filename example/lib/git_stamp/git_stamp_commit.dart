import 'dart:convert';

import 'git_stamp_json_output.dart';

class GitStampCommit {
  final String hash;
  final String subject;
  final String date;

  GitStampCommit({
    required this.hash,
    required this.subject,
    required this.date,
  });

  factory GitStampCommit.fromJson(Map<String, dynamic> json) => GitStampCommit(
        hash: json['hash'],
        subject: json['subject'],
        date: json['date'],
      );

  static List<GitStampCommit> get commitList =>
      json.decode(jsonOutput).map<GitStampCommit>((json) => GitStampCommit.fromJson(json)).toList();
}
