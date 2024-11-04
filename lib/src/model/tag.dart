import 'dateable.dart';

class Tag extends Dateable {
  final String name;
  @override
  final String date;

  Tag({
    required this.name,
    required this.date,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        name: json['name'] ?? 'null',
        date: json['date'] ?? 'null',
      );

  factory Tag.all(String value) => Tag(
        name: value,
        date: value,
      );
}
