// Copyright © 2024 Aron Onak. All rights reserved.
// Licensed under the MIT license.
// If you have any feedback, please contact me at arononak@gmail.com

import 'package:flutter/material.dart';

import 'git_stamp_node.dart';

/// The [GitStampListTile] class used when we want to go to the main screen of the tool.
///
/// Example:
/// ```dart
/// const Row(
///   mainAxisAlignment: MainAxisAlignment.spaceAround,
///   children: <Widget>[
///     GitStampListTile(),
///   ],
/// ),
/// ```
class GitStampListTile extends StatelessWidget {
  /// The [GitStampNode] class contains information provided during generation.
  final GitStampNode gitStamp;

  /// GitStamp version.
  final String gitStampVersion;

  /// Font name used to display changes.
  ///
  /// This field is not required, but if we want the changes to be displayed
  /// evenly, we need to pass the font name.
  ///
  /// See for example:
  /// https://github.com/arononak/git_stamp/blob/main/example/lib/main.dart#L9
  final String? monospaceFontFamily;

  /// Called when the user taps.
  final VoidCallback onPressed;

  const GitStampListTile({
    super.key,
    required this.gitStamp,
    required this.gitStampVersion,
    required this.onPressed,
    this.monospaceFontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      splashColor: Colors.orange[900],
      child: ListTile(
        title: const Text('Git Stamp Page'),
        subtitle: Text(gitStamp.sha),
        leading: const Icon(Icons.commit),
        splashColor: Colors.orange,
      ),
    );
  }
}
