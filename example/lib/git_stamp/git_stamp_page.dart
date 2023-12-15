import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: Icon(
                  Icons.code,
                  size: 36,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: commit.hash.substring(0, 7),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      TextSpan(
                        text: ' - ',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                      TextSpan(
                        text: commit.subject,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      commit.authorName + '(' + commit.authorEmail + ')',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      commit.date,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () => _copyToClipboard(context, commit.hash),
                  icon: Icon(
                    Icons.content_copy,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: const Text('Copied to clipboard !')));
  }
}
