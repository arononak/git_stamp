const rawGitStampIcon = '''
import 'package:flutter/material.dart';

import '../../git_stamp.dart';

class GitStampIcon extends StatelessWidget {
  const GitStampIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
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
                  'SHA: \${GitStamp.sha}',
              style: TextStyle(fontWeight: FontWeight.normal)),
        ],
      ),
      child: IconButton(
            icon: Icon(Icons.developer_board),
            onPressed: () {},
          ),
    );
  }
}
''';
