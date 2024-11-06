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
  final GitStampNode gitStamp;
  final String gitStampVersion;
  final bool isLiteVersion;
  final String? monospaceFontFamily;
  final VoidCallback onPressed;

  const GitStampListTile({
    super.key,
    required this.gitStamp,
    required this.gitStampVersion,
    required this.isLiteVersion,
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
