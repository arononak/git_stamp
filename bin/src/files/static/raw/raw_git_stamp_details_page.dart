const rawGitStampDetailsPage = '''
import 'package:flutter/material.dart';

import 'package:aron_gradient_line/aron_gradient_line.dart';

import '../../git_stamp.dart';

void showGitStampDetailsPage({
  required BuildContext context,
  bool useRootNavigator = false,
  required GitStampCommit commit,
  String? monospaceFontFamily,
}) {
  Navigator.of(
    context,
    rootNavigator: useRootNavigator,
  ).push(MaterialPageRoute<void>(
    builder: (BuildContext context) {
      return GitStampDetailsPage(
        commit: commit,
        monospaceFontFamily: monospaceFontFamily,
      );
    },
  ));
}

class GitStampDetailsPage extends StatelessWidget {
  final GitStampCommit commit;
  final String? monospaceFontFamily;

  const GitStampDetailsPage({
    Key? key,
    required this.commit,
    this.monospaceFontFamily,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: GitStampCommitListHeader(commit: commit),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: AronGradientLine(),
        ),
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
                fontFamily: monospaceFontFamily,
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
