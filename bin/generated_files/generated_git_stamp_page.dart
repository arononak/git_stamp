const generatedGitStampPage = '''
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:collection/collection.dart';

import 'branch_output.dart';
import 'build_date_time_output.dart';
import 'build_system_info_output.dart';
import 'creation_date_output.dart';
import 'repo_path_output.dart';

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

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      showCloseIcon: true,
      duration: Duration(seconds: 5),
    ),
  );
}

void openProjectHomepage() {
  launchUrl(Uri(
    scheme: 'https',
    host: 'github.com',
    path: 'arononak/git_stamp',
  ));
}

Map<String, int> commitCountByAuthor() {
  Map<String, int> map = {};

  for (GitStampCommit commit in GitStampCommit.commitList) {
    map.update(commit.authorName, (value) => (value) + 1, ifAbsent: () => 1);
  }

  return map;
}

List<String> parseBuildSystemInfo(text) {
  List<String> elements = RegExp(r'\\((.*?)\\)').firstMatch(text)?.group(1)?.split(', ') ?? [];

  return elements.isEmpty ? ["No data :/"] : elements;
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
                          return _buildRepoDetailsModal(context);
                        },
                      );
                    },
                    icon: const Icon(Icons.tag),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Git Stamp',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Flexible(
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      ListTile(
                                        onTap: () => openEmail(email: 'arononak@gmail.com'),
                                        title: Text(
                                          'Have a great idea for Git Stamp?',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        trailing: Icon(Icons.mail),
                                      ),
                                      ListTile(
                                        onTap: () => openProjectHomepage(),
                                        title: Text(
                                          'You love Git Stamp?',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        trailing: Icon(Icons.star),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: _buildCommitList(GitStampCommit.commitList),
    );
  }
}

void _copyToClipboard(BuildContext context, String text) {
  Clipboard.setData(ClipboardData(text: text));
  showSnackbar(context, 'Copied to clipboard !');
}

Widget _buildCommitList(elements) {
  Map<String, List<GitStampCommit>> groupedCommit = groupBy(
    elements,
    (element) {
      DateTime date = DateTime.parse(element.date);
      return date.year.toString() + '-' + date.month.toString().padLeft(2, '0') + '-' + date.day.toString().padLeft(2, '0');
    },
  );

  return ListView.builder(
    itemCount: groupedCommit.length,
    itemBuilder: (context, index) {
      String header = groupedCommit.keys.elementAt(index);
      List<GitStampCommit> commits = groupedCommit[header]!;

      return Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.commit, color: Theme.of(context).colorScheme.secondary),
                SizedBox(width: 8),
                Text(
                  header,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          ...commits.map((commit) => _buildCommitElement(context, commit)).toList()
        ],
      );
    },
  );
}

Widget _buildCommitElement(context, commit) {
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
}

Widget _buildDoubleText(String left, String right) {
  return Row(
    children: [
      Text(
        left,
        style: TextStyle(fontSize: 12),
      ),
      Text(
        right,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

Widget _buildRepoDetailsModal(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(16.0),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Build', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          _buildDoubleText('Date: ', buildDateTime),
          _buildDoubleText('Path: ', repoPath),
          _buildDoubleText('Branch: ', buildBranch),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Environment: ',
                style: TextStyle(fontSize: 12),
              ),
              Expanded(
                child: Text(
                  parseBuildSystemInfo(buildSystemInfo).join(String.fromCharCode(10)),
                  softWrap: true,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  showSnackbar(context, buildSystemInfo);
                },
                icon: Icon(Icons.info_outline),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text('Repository', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          _buildDoubleText('Created: ', repoCreationDate),
          _buildDoubleText('Commit count: ', GitStampCommit.commitList.length.toString()),
          Text(
            'Commit stats:',
            style: TextStyle(fontSize: 12),
          ),
          ...commitCountByAuthor().entries.map(
                (entry) => Row(
                  children: [
                    SizedBox(width: 16),
                    Text(
                      entry.key + ': ',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      entry.value.toString(),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
        ],
      ),
    ),
  );
}

''';
