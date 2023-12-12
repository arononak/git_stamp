import 'package:flutter/material.dart';

import 'git_stamp_commit.dart';

void showGitStampPage({
  required BuildContext context,
  bool useRootNavigator = false,
}) {
  Navigator.of(context, rootNavigator: useRootNavigator).push(MaterialPageRoute<void>(
    builder: (BuildContext context) => const GitStampPage(),
  ));
}

class GitStampPage extends StatelessWidget {
  const GitStampPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Git Stamp'),
      ),
      body: ListView.builder(
        itemCount: GitStampCommit.commitList.length,
        itemBuilder: (context, index) {
          final commit = GitStampCommit.commitList[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: const Icon(Icons.code),
              title: Text(
                commit.hash.substring(0, 7),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    commit.date,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 4),
                  Text(commit.subject),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
