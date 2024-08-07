const rawGitStampIcon = '''
import 'package:flutter/material.dart';

import '../../git_stamp.dart';

class GitStampIcon extends StatelessWidget {
  const GitStampIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      richMessage: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'Git Stamp\\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
              text: ''
                  'Date: \${GitStamp.buildDateTime}\\n'
                  'Branch: \${GitStamp.buildBranch}\\n'
                  'SHA: \${GitStamp.latestCommit.hash}',
              style: TextStyle(fontWeight: FontWeight.normal)),
        ],
      ),
      child: Icon(Icons.developer_board),
    );
  }
}
''';
