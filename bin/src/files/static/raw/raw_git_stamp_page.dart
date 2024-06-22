const rawGitStampPage = '''
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../git_stamp.dart';

void showGitStampPage({
  required BuildContext context,
  bool useRootNavigator = false,
}) {
  Navigator.of(context, rootNavigator: useRootNavigator).push(MaterialPageRoute<void>(
    builder: (BuildContext context) => const GitStampPage(),
  ));
}

class GitStampPage extends StatefulWidget {
  const GitStampPage({super.key});

  @override
  State<GitStampPage> createState() => _GitStampPageState();
}

class _GitStampPageState extends State<GitStampPage> {
  String? _filterAuthorName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Git Stamp', style: TextStyle(fontSize: 20)),
            SizedBox(width: 8.0),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                GitStamp.commitList.length.toString(),
                maxLines: 1,
                style: TextStyle(fontSize: 20),
              ),
            ),
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
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text('Filter',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 20),
                                  Flexible(
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: <String?>[
                                        null,
                                        ...commitAuthors()
                                      ]
                                          .map(
                                            (e) => ListTile(
                                              leading: Icon(e != null
                                                  ? Icons.person
                                                  : Icons.close),
                                              title: Text(
                                                e != null ? e : 'No filter',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                                setState(() =>
                                                    _filterAuthorName = e);
                                              },
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.filter_list),
                  ),
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
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Repository files',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(height: 16.0),
                                  Text(GitStamp.observedFiles),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.folder),
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
      body: _buildCommitList(GitStamp.commitList, _filterAuthorName),
    );
  }
}

Widget _buildCommitList(
    List<GitStampCommit> elements, String? filterAuthorName) {
  Map<String, List<GitStampCommit>> groupedCommit = groupBy(
    elements.where((e) =>
        filterAuthorName == null ? true : e.authorName == filterAuthorName),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _buildCommitHeader(context, commit),
                      ),
                    ),
                    IconButton(
                      onPressed: () => showGitStampDetailsPage(
                          context: context, commitHash: commit.hash),
                      icon: Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(GitStamp.diffOutput[commit.hash ?? ''] ?? ''),
                  ),
                ),
              ],
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
          title: _buildCommitHeader(context, commit),
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

Widget _buildCommitHeader(context, commit) {
  return Text.rich(
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
            text: ' - ', style: TextStyle(fontWeight: FontWeight.normal)),
        TextSpan(
            text: commit.subject,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
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
          _buildDoubleText('Date: ', GitStamp.buildDateTime),
          _buildDoubleText('Path: ', GitStamp.repoPath),
          _buildDoubleText('Branch: ', GitStamp.buildBranch),
          Row(
            children: [
              Text('GitStamp build type: <', style: TextStyle(fontSize: 12)),
              Text('LITE',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: GitStamp.isLiteVersion
                          ? FontWeight.bold
                          : FontWeight.normal)),
              Text(', ', style: TextStyle(fontSize: 12)),
              Text('FULL',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: GitStamp.isLiteVersion
                          ? FontWeight.normal
                          : FontWeight.bold)),
              Text('>', style: TextStyle(fontSize: 12)),
            ],
          ),
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
                  parseBuildSystemInfo(GitStamp.buildSystemInfo).join(
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
                  showSnackbar(context, GitStamp.buildSystemInfo);
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
          _buildDoubleText('Created: ', GitStamp.repoCreationDate),
          _buildDoubleText(
            'Commit count: ',
            GitStamp.commitList.length.toString(),
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
