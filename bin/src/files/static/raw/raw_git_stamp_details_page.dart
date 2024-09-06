const rawGitStampDetailsPage = '''
import 'package:flutter/material.dart';

import 'package:aron_gradient_line/aron_gradient_line.dart';

import '../../git_stamp.dart';

void showGitStampDetailsPage({
  required BuildContext context,
  bool useRootNavigator = false,
  required GitStampCommit commit,
}) {
  Navigator.of(context, rootNavigator: useRootNavigator)
      .push(MaterialPageRoute<void>(
    builder: (BuildContext context) =>
        GitStampDetailsPage(commit: commit),
  ));
}

class GitStampDetailsPage extends StatelessWidget {
  final GitStampCommit commit;

  const GitStampDetailsPage({Key? key, required this.commit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: AronGradientLine(),
        ),
        title: GitStampCommitListHeader(commit: commit),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Text(
              GitStamp.diffList[commit.hash] ?? '',
              style: TextStyle(
                fontFamily: 'CourierNew',
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

''';
