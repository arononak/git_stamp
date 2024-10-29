import 'dateable.dart';

class GitStampTag extends Dateable {
  final String name;
  @override
  final String date;

  GitStampTag({
    required this.name,
    required this.date,
  });

  factory GitStampTag.fromJson(Map<String, dynamic> json) => GitStampTag(
        name: json['name'] ?? 'null',
        date: json['date'] ?? 'null',
      );

  factory GitStampTag.all(String value) => GitStampTag(
        name: value,
        date: value,
      );
}
