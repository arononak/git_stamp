// Copyright © 2024 Aron Onak. All rights reserved.
// Licensed under the MIT license.
// If you have any feedback, please contact me at arononak@gmail.com

import 'dateable.dart';

/// The model used to store information about the [Tag].
///
/// Stores information about the tag.
class Tag extends Dateable {
  /// Example: `v5.0.0`.
  final String name;

  /// Example: `2024-11-16 08:05:28 +0100`.
  @override
  final String date;

  /// Creates an instance of [Tag].
  ///
  /// This constructor requires all fields.
  Tag({
    required this.name,
    required this.date,
  });

  /// Creates an instance of [Tag].
  ///
  /// Requires json map.
  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        name: json['name'] ?? 'null',
        date: json['date'] ?? 'null',
      );

  /// Creates an instance of [Tag].
  ///
  /// Assigns one value to each field, e.g. "null" or "ENCRYPTED".
  factory Tag.all(String value) => Tag(
        name: value,
        date: value,
      );
}
