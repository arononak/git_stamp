import 'dart:convert';
import 'dart:io';

const gitStampCommit = '''
import 'dart:convert';

import 'git_stamp_json_output.dart';

class GitStampCommit {
  final String hash;
  final String subject;
  final String date;
  final String authorName;
  final String authorEmail;

  GitStampCommit({
    required this.hash,
    required this.subject,
    required this.date,
    required this.authorName,
    required this.authorEmail,
  });

  factory GitStampCommit.fromJson(Map<String, dynamic> json) => GitStampCommit(
        hash: json['hash'],
        subject: json['subject'],
        date: json['date'],
        authorName: json['authorName'],
        authorEmail: json['authorEmail'],
      );

  static List<GitStampCommit> get commitList =>
      json.decode(jsonOutput).map<GitStampCommit>((json) => GitStampCommit.fromJson(json)).toList();
}
''';

const gitStampPage = '''
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
        title: Row(
          children: [
            Text('Git Stamp'),
            SizedBox(width: 8),
            CircleAvatar(
              child: Text(GitStampCommit.commitList.length.toString()),
            ),
            SizedBox(width: 8),
            Text('commits'),
          ],
        ),
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
''';

void main() {
  const outputFolder = 'lib/git_stamp';

  if (!Directory(outputFolder).existsSync()) {
    Directory(outputFolder).createSync(recursive: true);
  }

  final gitLogJson = Process.runSync(
    'git',
    [
      'log',
      '--pretty=format:{"hash":"%H","subject":"%s","date":"%ad","authorName":"%an","authorEmail":"%ae"}',
      '--date=format-local:%Y-%m-%d %H:%M',
    ],
  ).stdout;

  final logs =
      LineSplitter.split(gitLogJson).map((line) => json.decode(line)).toList();

  final gitStampJsonOutput = '''
    const jsonOutput = \'\'\'\n${jsonEncode(logs)}\n\'\'\';
  ''';

  void saveFile(String filename, String content) {
    File(filename).writeAsStringSync(content);
  }

  saveFile('$outputFolder/git_stamp_json_output.dart', gitStampJsonOutput);
  saveFile('$outputFolder/git_stamp_commit.dart', gitStampCommit);
  saveFile('$outputFolder/git_stamp_page.dart', gitStampPage);
}
