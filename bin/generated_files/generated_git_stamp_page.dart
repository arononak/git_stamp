const generatedGitStampPage = '''
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'git_stamp_commit.dart';
import 'git_stamp_utils.dart';

import 'data/diff_output.dart';
import 'data/branch_output.dart';
import 'data/build_date_time_output.dart';
import 'data/build_system_info_output.dart';
import 'data/creation_date_output.dart';
import 'data/repo_path_output.dart';

void showGitStampPage({
  required BuildContext context,
  bool useRootNavigator = false,
}) {
  Navigator.of(context, rootNavigator: useRootNavigator)
      .push(MaterialPageRoute<void>(
    builder: (BuildContext context) => const GitStampPage(),
  ));
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
                                        onTap: () => openEmail(
                                            email: 'arononak@gmail.com'),
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

Widget _buildCommitList(elements) {
  Map<String, List<GitStampCommit>> groupedCommit = groupBy(
    elements,
    (element) {
      DateTime date = DateTime.parse(element.date);
      return date.year.toString() +
          '-' +
          date.month.toString().padLeft(2, '0') +
          '-' +
          date.day.toString().padLeft(2, '0');
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
                Icon(Icons.commit,
                    color: Theme.of(context).colorScheme.secondary),
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
          ...commits
              .map((commit) => _buildCommitElement(context, commit))
              .toList()
        ],
      );
    },
  );
}

Widget _buildCommitElement(context, commit) {
  return GestureDetector(
    onTap: () {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Text(diffOutput[commit.hash ?? ''] ?? ''),
            ),
          );
        },
      );
    },
    child: Card(
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
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
          trailing: IconButton(
            onPressed: () => copyToClipboard(context, commit.hash),
            icon: Icon(
              Icons.content_copy,
              color: Theme.of(context).colorScheme.primary,
            ),
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
          Text(
            'Build',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          _buildDoubleText('Date: ', buildDateTime),
          _buildDoubleText('Path: ', repoPath),
          _buildDoubleText('Branch: ', buildBranch),
          const SizedBox(height: 32),
          Text(
            'Environment',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  parseBuildSystemInfo(buildSystemInfo).join(
                    String.fromCharCode(10),
                  ),
                  softWrap: true,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12),
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
          Text(
            'Repository',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          _buildDoubleText('Created: ', repoCreationDate),
          _buildDoubleText(
            'Commit count: ',
            GitStampCommit.commitList.length.toString(),
          ),
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
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
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
