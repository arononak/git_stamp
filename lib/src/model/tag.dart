// Copyright © 2024 Aron Onak. All rights reserved.
// Licensed under the MIT license.
// If you have any feedback, please contact me at arononak@gmail.com

import 'dateable.dart';

/// The model used to store information about the Tag.
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
