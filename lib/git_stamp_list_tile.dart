import 'package:flutter/material.dart';

import 'git_stamp_node.dart';

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
