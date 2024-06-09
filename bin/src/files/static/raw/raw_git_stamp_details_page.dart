const rawGitStampDetailsPage = '''
import 'package:flutter/material.dart';

import '../git_stamp.dart';

void showGitStampDetailsPage({
  required BuildContext context,
  bool useRootNavigator = false,
  required String commitHash,
}) {
  Navigator.of(context, rootNavigator: useRootNavigator)
      .push(MaterialPageRoute<void>(
    builder: (BuildContext context) =>
        GitStampDetailsPage(commitHash: commitHash),
  ));
}

class GitStampDetailsPage extends StatelessWidget {
  final String commitHash;

  const GitStampDetailsPage({Key? key, required this.commitHash})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(commitHash),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(GitStamp.diffOutput[commitHash] ?? ''),
        ),
      ),
    );
  }
}

''';
