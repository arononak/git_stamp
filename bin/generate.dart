import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';

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
import 'package:example/git_stamp/git_stamp_build_date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'git_stamp_branch_output.dart';
import 'git_stamp_commit.dart';

void showGitStampPage({
  required BuildContext context,
  bool useRootNavigator = false,
}) {
  Navigator.of(context, rootNavigator: useRootNavigator).push(MaterialPageRoute<void>(
    builder: (BuildContext context) => const GitStampPage(),
  ));
}

void openEmail({
  required String email,
  String? subject,
}) {
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries.map(
      (MapEntry<String, String> e) {
        return Uri.encodeComponent(e.key) + '=' + Uri.encodeComponent(e.value);
      },
    ).join('&');
  }

  launchUrl(
    Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(
        <String, String>{'subject': subject ?? ''},
      ),
    ),
  );
}

class GitStampPage extends StatelessWidget {
  const GitStampPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Git Stamp', style: TextStyle(fontSize: 20)),
          ],
        ),
        flexibleSpace: Center(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Commit count: ',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      GitStampCommit.commitList.length.toString(),
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Build branch: ',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      buildBranch,
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Build time: ',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      buildDateTime,
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.info_outline),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: GitStampCommit.commitList.length,
        itemBuilder: (context, index) {
          final commit = GitStampCommit.commitList[index];

          return Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                contentPadding: const EdgeInsets.all(0),
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
                      const TextSpan(
                        text: ' - ',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                      TextSpan(
                        text: commit.subject,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => openEmail(email: commit.authorEmail),
                      child: Text(
                        // ignore: prefer_interpolation_to_compose_strings
                        commit.authorName + ' (' + commit.authorEmail + ')',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontStyle: FontStyle.italic,
                        ),
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
        .showSnackBar(const SnackBar(content: Text('Copied to clipboard !')));
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
  final logsOutput =
      '''const jsonOutput = \'\'\'\n${jsonEncode(logs)}\n\'\'\';''';

  final branch =
      Process.runSync('git', ['rev-parse', '--abbrev-ref', 'HEAD']).stdout;
  final branchOutput = 'const buildBranch = "${branch.toString().trim()}";';

  final buildDateTime =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  final buildDateTimeOutput =
      'const buildDateTime = "${buildDateTime.toString().trim()}";';

  void saveFile(String filename, String content) {
    File(filename).writeAsStringSync(content);
  }

  saveFile('$outputFolder/git_stamp_json_output.dart', logsOutput);
  saveFile('$outputFolder/git_stamp_branch_output.dart', branchOutput);
  saveFile('$outputFolder/git_stamp_build_date_time.dart', buildDateTimeOutput);

  saveFile('$outputFolder/git_stamp_commit.dart', gitStampCommit);
  saveFile('$outputFolder/git_stamp_page.dart', gitStampPage);
}
