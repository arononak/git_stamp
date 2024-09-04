const rawGitStampPage = '''
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:aron_gradient_line/aron_gradient_line.dart';

import '../../git_stamp.dart';

const _text = TextStyle(fontSize: 12);
const _textBold = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
const _textTitle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

void showGitStampPage({
  required BuildContext context,
  bool useRootNavigator = false,
}) {
  Navigator.of(context, rootNavigator: useRootNavigator)
      .push(MaterialPageRoute<void>(
    builder: (BuildContext context) => const GitStampPage(),
  ));
}

class GitStampPage extends StatefulWidget {
  const GitStampPage({
    super.key,
    this.showDetails = false,
    this.showFiles = false,
  });

  final bool showDetails;
  final bool showFiles;

  @override
  State<GitStampPage> createState() => _GitStampPageState();
}

class _GitStampPageState extends State<GitStampPage> {
  String? _filterAuthorName;

  @override
  void initState() {
    super.initState();

    if (widget.showDetails) {
      Future.delayed(Duration.zero, () => showDetailsBottomSheet());
    }

    if (widget.showFiles) {
      Future.delayed(Duration.zero, () => showRepoFilesBottomSheet());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: AronGradientLine(),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Git Stamp', style: TextStyle(fontSize: 20)),
            SizedBox(width: 8.0),
            GitStampTextLabel(text: GitStamp.commitCount.toString()),
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
                    onPressed: () => showDetailsBottomSheet(),
                    icon: const Icon(Icons.tag),
                  ),
                  IconButton(
                    onPressed: () => showRepoFilesBottomSheet(),
                    icon: const Icon(Icons.folder),
                  ),
                  IconButton(
                    onPressed: () => showFilterBottomSheet(),
                    icon: const Icon(Icons.filter_list),
                  ),
                  IconButton(
                    onPressed: () => showMoreBottomSheet(),
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: GitStampCommitList(
        commits: GitStamp.commitList,
        filterAuthorName: _filterAuthorName,
        isLiteVersion: isLiteVersion,
      ),
    );
  }

  void showDetailsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => GitStampRepoDetails(),
    );
  }

  void showRepoFilesBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => GitStampRepoFiles(),
    );
  }

  void showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return GitStampFilterList(
          onFilterPressed: (commiter) {
            Navigator.pop(context);
            setState(() => _filterAuthorName = commiter);
          },
        );
      },
    );
  }

  void showMoreBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => GitStampMore(),
    );
  }
}

class GitStampTextLabel extends StatelessWidget {
  final String text;

  const GitStampTextLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        maxLines: 1,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

class GitStampCommitList extends StatelessWidget {
  final List<GitStampCommit> commits;
  final String? filterAuthorName;
  final bool isLiteVersion;

  const GitStampCommitList({
    this.commits = const [],
    this.filterAuthorName,
    this.isLiteVersion = true,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, List<GitStampCommit>> groupedCommit = groupBy(
      commits.where(
        (e) {
          return filterAuthorName == null
              ? true
              : e.authorName == filterAuthorName;
        },
      ),
      (element) {
        final date = DateTime.parse(element.date);

        return date.year.toString() +
            '-' +
            date.month.toString().padLeft(2, '0') +
            '-' +
            date.day.toString().padLeft(2, '0');
      },
    );

    return ListView.builder(
      itemCount: groupedCommit.length,
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, index) {
        final header = groupedCommit.keys.elementAt(index);
        final commits = groupedCommit[header]!;

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.commit,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
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
                .map(
                  (commit) => GitStampCommitListElement(
                    commit: commit,
                    isLiteVersion: isLiteVersion,
                  ),
                )
                .toList()
          ],
        );
      },
    );
  }
}

class GitStampCommitListElement extends StatelessWidget {
  final GitStampCommit commit;
  final bool isLiteVersion;

  const GitStampCommitListElement({
    required this.commit,
    this.isLiteVersion = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: isLiteVersion
            ? null
            : () {
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
                                  child:
                                      GitStampCommitListHeader(commit: commit),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  showGitStampDetailsPage(
                                    context: context,
                                    commitHash: commit.hash,
                                  );
                                },
                                icon: Icon(Icons.arrow_forward),
                              ),
                            ],
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(GitStamp.diffList[commit.hash] ?? ''),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: Icon(
              Icons.code,
              size: 36,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: GitStampCommitListHeader(commit: commit),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => openEmail(email: commit.authorEmail),
                  child: Text(
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
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
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
}

class GitStampCommitListHeader extends StatelessWidget {
  final GitStampCommit commit;

  const GitStampCommitListHeader({required this.commit});

  @override
  Widget build(BuildContext context) {
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
    );
  }
}

class GitStampDoubleText extends StatelessWidget {
  final String left;
  final String right;

  const GitStampDoubleText(this.left, this.right);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(left, style: _text),
        Text(right, style: _textBold),
      ],
    );
  }
}

class GitStampRepoDetails extends StatelessWidget {
  const GitStampRepoDetails();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('GitStamp', style: _textTitle),
            const SizedBox(height: 4),
            GitStampDoubleText('Version: ', gitStampVersion),
            Row(
              children: [
                Text('Build type: [', style: _text),
                Text('LITE', style: isLiteVersion ? _textBold : _text),
                Text(', ', style: _text),
                Text('FULL', style: isLiteVersion ? _text : _textBold),
                Text(']', style: _text),
              ],
            ),
            const SizedBox(height: 32),
            Text('Build', style: _textTitle),
            const SizedBox(height: 4),
            GitStampDoubleText(
              'Global: ',
              GitStamp.gitConfigGlobalUserName +
                  ' (' +
                  GitStamp.gitConfigGlobalUserEmail +
                  ')',
            ),
            GitStampDoubleText(
              'Local: ',
              GitStamp.gitConfigUserName +
                  ' (' +
                  GitStamp.gitConfigUserEmail +
                  ')',
            ),
            GitStampDoubleText('Date: ', GitStamp.buildDateTime),
            GitStampDoubleText('Path: ', GitStamp.repoPath),
            GitStampDoubleText('Branch: ', GitStamp.buildBranch),
            GitStampDoubleText('SHA: ', GitStamp.sha),
            const SizedBox(height: 32),
            Text('Environment', style: _textTitle),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GitStampDoubleText('Framework Version: ',
                          GitStamp.buildMachine.frameworkVersion),
                      GitStampDoubleText(
                          'Channel: ', GitStamp.buildMachine.channel),
                      GitStampDoubleText('Repository Url: ',
                          GitStamp.buildMachine.repositoryUrl),
                      GitStampDoubleText('Framework Revision: ',
                          GitStamp.buildMachine.frameworkRevision),
                      GitStampDoubleText('Framework Commit Date: ',
                          GitStamp.buildMachine.frameworkCommitDate),
                      GitStampDoubleText('Engine Revision: ',
                          GitStamp.buildMachine.engineRevision),
                      GitStampDoubleText('Dart Sdk Version: ',
                          GitStamp.buildMachine.dartSdkVersion),
                      GitStampDoubleText('DevTools Version: ',
                          GitStamp.buildMachine.devToolsVersion),
                      GitStampDoubleText('Flutter Version: ',
                          GitStamp.buildMachine.flutterVersion),
                      GitStampDoubleText(
                          'Flutter Root: ', GitStamp.buildMachine.flutterRoot),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showSnackbar(context, GitStamp.buildSystemInfo);
                  },
                  icon: Icon(Icons.medical_information),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text('Repository', style: _textTitle),
            const SizedBox(height: 4),
            GitStampDoubleText('App Name: ', GitStamp.appName),
            GitStampDoubleText('App Version: ',
                GitStamp.appVersion + ' (' + GitStamp.appBuild + ')'),
            GitStampDoubleText('Created: ', GitStamp.repoCreationDate),
            GitStampDoubleText(
              'Commit count: ',
              GitStamp.commitList.length.toString(),
            ),
            Text('Commit stats:', style: _text),
            ...commitCountByAuthor()
                .entries
                .map(
                  (entry) => Row(
                    children: [
                      SizedBox(width: 16),
                      Text(entry.key + ': ', style: _text),
                      Text(entry.value.toString(), style: _textBold),
                    ],
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}

class GitStampRepoFiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Repository files', style: _textTitle),
                SizedBox(width: 8.0),
                GitStampTextLabel(
                  text: GitStamp.observedFilesCount.toString(),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(GitStamp.observedFiles, style: _text),
          ],
        ),
      ),
    );
  }
}

class GitStampFilterList extends StatelessWidget {
  final void Function(String? commiter) onFilterPressed;

  const GitStampFilterList({super.key, required this.onFilterPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Filter', style: _textTitle),
            ),
            SizedBox(height: 20),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: <String?>[null, ...commitAuthors()]
                    .map(
                      (e) => ListTile(
                        leading: Icon(
                          e != null ? Icons.person : Icons.close,
                        ),
                        title: Text(
                          e != null ? e : 'No filter',
                          style: _textBold,
                        ),
                        onTap: () {
                          onFilterPressed(e);
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
  }
}

class GitStampMore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Git Stamp', style: _textTitle),
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
                    style: _textBold,
                  ),
                  leading: Icon(Icons.mail),
                ),
                ListTile(
                  onTap: () => openProjectHomepage(),
                  title: Text('You love Git Stamp?', style: _textBold),
                  leading: Icon(Icons.star),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

''';
