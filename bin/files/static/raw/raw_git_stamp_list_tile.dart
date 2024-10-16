const rawGitStampListTile = '''
import 'package:flutter/material.dart';

import '../../git_stamp.dart';

class GitStampListTile extends StatelessWidget {
  final String? monospaceFontFamily;

  const GitStampListTile({super.key, this.monospaceFontFamily});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showGitStampPage(
          context: context,
          monospaceFontFamily: monospaceFontFamily,
        );
      },
      splashColor: Colors.orange[900],
      child: ListTile(
        title: const Text('Git Stamp Page'),
        subtitle: Text(GitStamp.sha),
        leading: const Icon(Icons.commit),
        splashColor: Colors.orange,
      ),
    );
  }
}

''';
