import 'dart:convert';
import 'dart:io';

const gitStampCommit = '''
import 'dart:convert';

import 'git_stamp_json_output.dart';

class GitStampCommit {
  final String hash;
  final String subject;
  final String date;

  GitStampCommit({
    required this.hash,
    required this.subject,
    required this.date,
  });

  factory GitStampCommit.fromJson(Map<String, dynamic> json) => GitStampCommit(
        hash: json['hash'],
        subject: json['subject'],
        date: json['date'],
      );

  static List<GitStampCommit> get commitList =>
      json.decode(jsonOutput).map<GitStampCommit>((json) => GitStampCommit.fromJson(json)).toList();
}
''';

const gitStampPage = '''
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
      '--pretty=format:{"hash":"%h","subject":"%s","date":"%ad"}',
      '--date=format-local:%Y-%m-%d %H:%M',
    ],
  ).stdout;

  final logs = LineSplitter.split(gitLogJson).map((line) => json.decode(line)).toList();
  
  final jsonOutput = 'const jsonOutput = \'\'\'\n${jsonEncode(logs)}\n\'\'\';';

  File('$outputFolder/git_stamp_json_output.dart').writeAsStringSync(jsonOutput);
  File('$outputFolder/git_stamp_commit.dart').writeAsStringSync(gitStampCommit);
  File('$outputFolder/git_stamp_page.dart').writeAsStringSync(gitStampPage);
}
