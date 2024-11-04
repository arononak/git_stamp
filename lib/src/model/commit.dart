import 'dateable.dart';

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
