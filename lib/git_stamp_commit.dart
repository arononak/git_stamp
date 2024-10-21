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
        hash: json['hash'] ?? 'null',
        subject: json['subject'] ?? 'null',
        date: json['date'] ?? 'null',
        authorName: json['authorName'] ?? 'null',
        authorEmail: json['authorEmail'] ?? 'null',
      );
}
