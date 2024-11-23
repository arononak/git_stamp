// Copyright © 2024 Aron Onak. All rights reserved.
// Licensed under the MIT license.
// If you have any feedback, please contact me at arononak@gmail.com

/// The model used to store information about the [DiffList].
///
/// Stores information about the commits diff.
class DiffList {
  final Map<String, dynamic> _map;

  /// Creates an instance of [DiffList].
  ///
  /// This constructor requires all fields.
  DiffList(this._map);

  /// Creates an instance of [DiffList].
  ///
  /// Requires json map.
  factory DiffList.fromJson(Map<String, dynamic> json) => DiffList(json);

  /// Returns changes as a [String] by hash.
  ///
  /// Requires [Commit] hash.
  String elementForHash(String hash) => _map[hash] ?? '';
}
