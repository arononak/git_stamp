const rawGitStampPage = '''
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:aron_gradient_line/aron_gradient_line.dart';

import '../../git_stamp.dart';

const _text = TextStyle(fontSize: 12);
const _textBold = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
const _textTitle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

bool isMobile(context) => MediaQuery.of(context).size.width < 600;

void showGitStampPage({
  required BuildContext context,
  bool useRootNavigator = false,
  String? monospaceFontFamily,
}) {
  Navigator.of(
    context,
    rootNavigator: useRootNavigator,
  ).push(MaterialPageRoute<void>(
    builder: (BuildContext context) {
      return GitStampPage(
        monospaceFontFamily: monospaceFontFamily,
      );
    },
  ));
}

void _showRepoFilesBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) => GitStampRepoFiles(),
  );
}

void _showMoreBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) => GitStampMore(),
  );
}

void _showFilterBottomSheet(
  BuildContext context, {
  required String? selectedUser,
  required void Function(String? commiter) onFilterPressed,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return GitStampFilterList(
        selectedUser: selectedUser,
        onFilterPressed: onFilterPressed,
      );
    },
  );
}

void _showDetailsBottomSheet(
  BuildContext context, {
  VoidCallback? onFinish,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) => GitStampRepoDetails(),
  ).then((result) => onFinish?.call());
}

class GitStampPage extends StatefulWidget {
  const GitStampPage({
    super.key,
    this.showDetails = false,
    this.showFiles = false,
    this.monospaceFontFamily,
  });

  final bool showDetails;
  final bool showFiles;
  final String? monospaceFontFamily;

  @override
  State<GitStampPage> createState() => _GitStampPageState();
}

class _GitStampPageState extends State<GitStampPage> {
  final _arrowIconKey = GlobalKey<_GitStampArrowIconState>();
  bool itemLargeType = true;
  String? _filterAuthorName;

  @override
  void initState() {
    super.initState();

    if (widget.showDetails) {
      Future.delayed(Duration.zero, () => _showDetailsBottomSheet(context));
    }

    if (widget.showFiles) {
      Future.delayed(Duration.zero, () => _showRepoFilesBottomSheet(context));
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
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: GitStampLabel(
          first: 'Git Stamp',
          second: GitStamp.commitCount.toString(),
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
                      setState(() => this.itemLargeType = !this.itemLargeType);
                    },
                    icon: Icon(
                      itemLargeType ? Icons.format_list_bulleted : Icons.list,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _showFilterBottomSheet(
                        context,
                        selectedUser: _filterAuthorName,
                        onFilterPressed: (commiter) {
                          Navigator.pop(context);
                          setState(() => _filterAuthorName = commiter);
                        },
                      );
                    },
                    icon: const Icon(Icons.filter_list),
                  ),
                  GitStampArrowIcon(
                    key: _arrowIconKey,
                    onPressed: () {
                      _showDetailsBottomSheet(
                        context,
                        onFinish: () => _arrowIconKey.currentState?.toggle(),
                      );
                    },
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
        itemLargeType: itemLargeType,
        monospaceFontFamily: widget.monospaceFontFamily,
      ),
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
  final bool itemLargeType;
  final String? monospaceFontFamily;

  const GitStampCommitList({
    this.commits = const [],
    this.filterAuthorName,
    this.isLiteVersion = true,
    this.itemLargeType = true,
    this.monospaceFontFamily,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, List<GitStampCommit>> groupedCommit = groupBy(
      commits.where(
        (element) {
          return filterAuthorName == null
              ? true
              : element.authorName == filterAuthorName;
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

    List<dynamic> listElement = [];
    groupedCommit.forEach((key, commits) {
      listElement.add(key);
      listElement.addAll(commits);
    });

    return ListView.builder(
      itemCount: listElement.length,
      itemBuilder: (context, index) {
        final element = listElement[index];

        switch (element) {
          case String():
            return GitStampDateListElement(
              date: element,
            );
          case GitStampCommit():
            return GitStampCommitListElement(
              commit: element,
              isLiteVersion: isLiteVersion,
              itemLargeType: itemLargeType,
              monospaceFontFamily: monospaceFontFamily,
            );
          default:
            return SizedBox();
        }
      },
    );
  }
}

class GitStampDateListElement extends StatelessWidget {
  final String date;

  const GitStampDateListElement({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Icon(
            Icons.commit,
            color: Theme.of(context).colorScheme.secondary,
          ),
          SizedBox(width: 8),
          Text(
            date,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class GitStampCommitListElement extends StatelessWidget {
  final GitStampCommit commit;
  final bool isLiteVersion;
  final bool itemLargeType;
  final String? monospaceFontFamily;

  const GitStampCommitListElement({
    required this.commit,
    this.isLiteVersion = true,
    required this.itemLargeType,
    this.monospaceFontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
      margin: EdgeInsets.symmetric(
        horizontal: 0.0,
        vertical: itemLargeType == false ? 0.0 : 4.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
      elevation: 0.0,
      child: InkWell(
        onTap: isLiteVersion ? null : () => showGitDiffStat(context),
        splashColor: Colors.orange[900],
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: itemLargeType == false ? 8.0 : 16,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: itemLargeType == false
                ? null
                : isMobile(context)
                    ? null
                    : Icon(
                        Icons.code,
                        size: 36,
                        color: Theme.of(context).colorScheme.primary,
                      ),
            title: GitStampCommitListHeader(commit: commit),
            subtitle: itemLargeType == false
                ? null
                : Column(
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                        maxLines: 1,
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

  void showGitDiffStat(BuildContext context) {
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
                      child: GitStampCommitListHeader(commit: commit),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showGitStampDetailsPage(
                        context: context,
                        commit: commit,
                        monospaceFontFamily: monospaceFontFamily,
                      );
                    },
                    icon: Icon(Icons.arrow_forward),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      GitStamp.diffStatList[commit.hash] ?? '',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: monospaceFontFamily,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
    return Stack(
      children: [
        Positioned(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGitStampSection(context),
                    const SizedBox(height: 32),
                    _buildBuildSection(context),
                    const SizedBox(height: 32),
                    _buildEnvironmentSection(context),
                    const SizedBox(height: 32),
                    _buildRepositorySection(context),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 20,
          top: 8,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  showSnackbar(
                    context: context,
                    message: GitStamp.gitConfigList,
                    showCloseIcon: true,
                    floating: false,
                  );
                },
                icon: Icon(Icons.settings),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  showSnackbar(
                    context: context,
                    message: GitStamp.gitRemote,
                    showCloseIcon: true,
                  );
                },
                icon: Icon(Icons.cloud),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  showSnackbar(
                    context: context,
                    message: GitStamp.buildSystemInfo,
                    showCloseIcon: true,
                    floating: false,
                  );
                },
                icon: Icon(Icons.medical_information),
              ),
              IconButton(
                onPressed: () => _showRepoFilesBottomSheet(context),
                icon: const Icon(Icons.folder),
              ),
              IconButton(
                onPressed: () => _showMoreBottomSheet(context),
                icon: const Icon(Icons.more),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGitStampSection(BuildContext context) {
    return Column(
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
      ],
    );
  }

  Widget _buildBuildSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Build', style: _textTitle),
        const SizedBox(height: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GitStampDoubleText('Date: ', GitStamp.buildDateTime),
            GitStampDoubleText('Path: ', GitStamp.repoPath),
            GitStampDoubleText('Branch: ', GitStamp.buildBranch),
            GitStampDoubleText('SHA: ', GitStamp.sha),
          ],
        ),
      ],
    );
  }

  Widget _buildEnvironmentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Environment', style: _textTitle),
        const SizedBox(height: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            ...{
              'Framework Version: ': GitStamp.buildMachine.frameworkVersion,
              'Channel: ': GitStamp.buildMachine.channel,
              'Repository Url: ': GitStamp.buildMachine.repositoryUrl,
              'Framework Revision: ': GitStamp.buildMachine.frameworkRevision,
              'Framework Commit Date: ':
                  GitStamp.buildMachine.frameworkCommitDate,
              'Engine Revision: ': GitStamp.buildMachine.engineRevision,
              'Dart Sdk Version: ': GitStamp.buildMachine.dartSdkVersion,
              'DevTools Version: ': GitStamp.buildMachine.devToolsVersion,
              'Flutter Version: ': GitStamp.buildMachine.flutterVersion,
              'Flutter Root: ': GitStamp.buildMachine.flutterRoot,
            }.entries.map((e) => GitStampDoubleText(e.key, e.value)).toList(),
          ],
        ),
      ],
    );
  }

  Widget _buildRepositorySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            GitStampLabel(
              first: 'Repository files',
              second: GitStamp.observedFilesCount.toString(),
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
  final String? selectedUser;
  final void Function(String? commiter) onFilterPressed;

  const GitStampFilterList({
    super.key,
    required this.selectedUser,
    required this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    final commitCount = commitCountByAuthor();
    final users = <String?>[null, ...commitAuthors()]; // null -> no filter

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
                children: users.map(
                  (e) {
                    final count = commitCount[e];

                    return ListTile(
                      leading: Icon(e != null ? Icons.person : Icons.close),
                      title: Text(e ?? 'No filter', style: _textBold),
                      subtitle: count == null ? null : Text(count.toString()),
                      trailing: e != selectedUser ? null : Icon(Icons.check),
                      onTap: () => onFilterPressed(e),
                    );
                  },
                ).toList(),
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

class GitStampLabel extends StatelessWidget {
  final String first;
  final String second;

  const GitStampLabel({super.key, required this.first, required this.second});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(first, style: TextStyle(fontSize: 20)),
        SizedBox(width: 8.0),
        GitStampTextLabel(text: second),
      ],
    );
  }
}

class GitStampArrowIcon extends StatefulWidget {
  final VoidCallback? onPressed;

  const GitStampArrowIcon({super.key, this.onPressed});

  @override
  _GitStampArrowIconState createState() => _GitStampArrowIconState();
}

class _GitStampArrowIconState extends State<GitStampArrowIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    super.initState();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onPressed?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggle() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value * pi,
          child: child,
        );
      },
      child: IconButton(
        icon: Icon(Icons.arrow_upward),
        onPressed: () => toggle(),
      ),
    );
  }
}

''';
