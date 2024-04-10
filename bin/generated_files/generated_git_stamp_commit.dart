const generatedGitStampCommit = '''
import 'dart:convert';

import 'data/json_output.dart';

class GitStampCommit {
  final String hash;
  final String subject;
  final String date;
  final String authorName;
  final String authorEmail;

  GitStampCommit({
    required this.hash,
    required this.subject,
    required this.date,
    required this.authorName,
    required this.authorEmail,
  });

  factory GitStampCommit.fromJson(Map<String, dynamic> json) => GitStampCommit(
        hash: json['hash'],
        subject: json['subject'],
        date: json['date'],
        authorName: json['authorName'],
        authorEmail: json['authorEmail'],
      );

  static List<GitStampCommit> get commitList =>
      json.decode(jsonOutput).map<GitStampCommit>((json) => GitStampCommit.fromJson(json)).toList();
}
''';
