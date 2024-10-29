import 'dart:math';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:aron_gradient_line/aron_gradient_line.dart';

import 'git_stamp_commit.dart';
import 'git_stamp_decrypt_bottom_sheet.dart';
import 'git_stamp_launcher.dart';
import 'git_stamp_node.dart';
import 'git_stamp_utils.dart';

const textDefault = TextStyle(fontSize: 12);
const textBold = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
const textTitle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

extension _GitStampNode on GitStampNode {
  Map<String, int> get commitCountByAuthor {
    Map<String, int> map = {};

    for (GitStampCommit commit in commitList) {
      map.update(commit.authorName, (value) => (value) + 1, ifAbsent: () => 1);
    }

    return map;
  }

  List<String> get commitAuthors {
    Set<String> authors = {};

    for (GitStampCommit commit in commitList) {
      authors.add(commit.authorName);
    }

    return authors.toList();
  }
}

bool _isMobile(context) => MediaQuery.of(context).size.width < 600;

void _showDetailsBottomSheet(
  BuildContext context, {
  required GitStampNode gitStamp,
  required String gitStampVersion,
  required bool isLiteVersion,
  VoidCallback? onFinish,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return _GitStampRepoDetails(
        gitStamp: gitStamp,
        gitStampVersion: gitStampVersion,
        isLiteVersion: isLiteVersion,
      );
    },
  ).then((result) => onFinish?.call());
}

class GitStampPage extends StatefulWidget {
  const GitStampPage({
    super.key,
    required this.gitStamp,
    required this.gitStampVersion,
    required this.isLiteVersion,
    this.showDetails = false,
    this.showFiles = false,
    this.monospaceFontFamily,
    this.encryptDebugKey,
    this.encryptDebugIv,
  });

  final GitStampNode gitStamp;
  final String gitStampVersion;
  final bool isLiteVersion;
  final bool showDetails;
  final bool showFiles;
  final String? monospaceFontFamily;
  final String? encryptDebugKey;
  final String? encryptDebugIv;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.showDetails) {
        _showDetailsBottomSheet(
          context,
          gitStamp: widget.gitStamp,
          gitStampVersion: widget.gitStampVersion,
          isLiteVersion: widget.isLiteVersion,
        );
      }

      if (widget.showFiles) {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return _GitStampRepoFiles(gitStamp: widget.gitStamp);
          },
        );
      }
    });
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
        title: _GitStampLabel(
          first: 'Git Stamp',
          second: widget.gitStamp.commitCount.toString(),
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
                      setState(() => itemLargeType = !itemLargeType);
                    },
                    icon: Icon(
                      itemLargeType ? Icons.format_list_bulleted : Icons.list,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return _GitStampFilterList(
                            gitStamp: widget.gitStamp,
                            selectedUser: _filterAuthorName,
                            onFilterPressed: (commiter) {
                              Navigator.pop(context);
                              setState(() => _filterAuthorName = commiter);
                            },
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.filter_list),
                  ),
                  _GitStampArrowIcon(
                    key: _arrowIconKey,
                    onPressed: () {
                      _showDetailsBottomSheet(
                        context,
                        gitStamp: widget.gitStamp,
                        gitStampVersion: widget.gitStampVersion,
                        isLiteVersion: widget.isLiteVersion,
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
      body: widget.gitStamp.isEncrypted
          ? Center(
              child: IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return GitStampDecryptForm(
                        gitStamp: widget.gitStamp,
                        startKey: widget.encryptDebugKey,
                        startIv: widget.encryptDebugIv,
                        onSuccess: () => setState(() {}),
                      );
                    },
                  );
                },
                icon: Icon(Icons.lock_open, size: 60),
              ),
            )
          : _GitStampCommitList(
              gitStamp: widget.gitStamp,
              commits: widget.gitStamp.commitList,
              filterAuthorName: _filterAuthorName,
              isLiteVersion: widget.isLiteVersion,
              itemLargeType: itemLargeType,
              monospaceFontFamily: widget.monospaceFontFamily,
            ),
    );
  }
}

class GitStampDetailsPage extends StatefulWidget {
  final GitStampNode gitStamp;
  final GitStampCommit commit;
  final String? monospaceFontFamily;

  const GitStampDetailsPage({
    super.key,
    required this.gitStamp,
    required this.commit,
    this.monospaceFontFamily,
  });

  @override
  State<GitStampDetailsPage> createState() => _GitStampDetailsPageState();
}

class _GitStampDetailsPageState extends State<GitStampDetailsPage> {
  String get diffList => widget.gitStamp.diffList[widget.commit.hash] ?? '';

  var _fontSize = 12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _GitStampCommitListHeader(commit: widget.commit),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: AronGradientLine(),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                setState(() => _fontSize -= _fontSize <= 1 ? 0 : 1),
            icon: Icon(Icons.remove_circle),
          ),
          Text(_fontSize.toString().padLeft(2, ' ')),
          IconButton(
            onPressed: () => setState(() => _fontSize += 1),
            icon: Icon(Icons.add_circle),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width,
                ),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _GitStampDetailsPageText(
                        diffList: diffList,
                        monospaceFontFamily: widget.monospaceFontFamily,
                        fontSize: _fontSize.toDouble(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => copyToClipboard(context, diffList),
        child: Icon(Icons.copy),
      ),
    );
  }
}

class _GitStampTextLabel extends StatelessWidget {
  final String text;

  const _GitStampTextLabel({required this.text});

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

class _GitStampCommitHeader {
  final String date;
  final int count;

  const _GitStampCommitHeader({
    required this.date,
    required this.count,
  });
}

class _GitStampCommitList extends StatelessWidget {
  final GitStampNode gitStamp;
  final List<GitStampCommit> commits;
  final String? filterAuthorName;
  final bool isLiteVersion;
  final bool itemLargeType;
  final String? monospaceFontFamily;

  const _GitStampCommitList({
    required this.gitStamp,
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

        return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      },
    );

    List<dynamic> listElement = [];
    groupedCommit.forEach((key, commits) {
      listElement.add(_GitStampCommitHeader(date: key, count: commits.length));
      listElement.addAll(commits);
    });

    return ListView.builder(
      itemCount: listElement.length,
      itemBuilder: (context, index) {
        final element = listElement[index];

        switch (element) {
          case _GitStampCommitHeader():
            return _GitStampDateListElement(
              date: element.date,
              count: element.count,
            );
          case GitStampCommit():
            return _GitStampCommitListElement(
              gitStamp: gitStamp,
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

class _GitStampDateListElement extends StatelessWidget {
  final String date;
  final int count;

  const _GitStampDateListElement({
    required this.date,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
          Container(
            constraints: BoxConstraints(
              minHeight: 40,
              minWidth: 40,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.surfaceContainer,
            ),
            alignment: Alignment.center,
            child: Text(
              count.toString(),
              maxLines: 1,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GitStampCommitListElement extends StatelessWidget {
  final GitStampNode gitStamp;
  final GitStampCommit commit;
  final bool isLiteVersion;
  final bool itemLargeType;
  final String? monospaceFontFamily;

  const _GitStampCommitListElement({
    required this.gitStamp,
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
        onTap: isLiteVersion
            ? null
            : () => showGitDiffStat(context, gitStamp: gitStamp),
        splashColor: Colors.orange[900],
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: itemLargeType == false ? 8.0 : 16,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: itemLargeType == false
                ? null
                : _isMobile(context)
                    ? null
                    : Icon(
                        Icons.code,
                        size: 36,
                        color: Theme.of(context).colorScheme.primary,
                      ),
            title: _GitStampCommitListHeader(commit: commit),
            subtitle: itemLargeType == false
                ? null
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => openEmail(email: commit.authorEmail),
                        child: Text(
                          '${commit.authorName} (${commit.authorEmail})',
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

  void showGitDiffStat(
    BuildContext context, {
    required GitStampNode gitStamp,
  }) {
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
                      child: _GitStampCommitListHeader(commit: commit),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      gitStamp.showDetailsPage(
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
                      gitStamp.diffStatList[commit.hash] ?? '',
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

class _GitStampCommitListHeader extends StatelessWidget {
  final GitStampCommit commit;

  const _GitStampCommitListHeader({required this.commit});

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

class _GitStampDoubleText extends StatelessWidget {
  final String left;
  final String right;

  const _GitStampDoubleText(this.left, this.right);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(left, style: textDefault),
        Text(right, style: textBold),
      ],
    );
  }
}

class _GitStampRepoDetails extends StatelessWidget {
  const _GitStampRepoDetails({
    required this.gitStamp,
    required this.gitStampVersion,
    required this.isLiteVersion,
  });

  final GitStampNode gitStamp;
  final String gitStampVersion;
  final bool isLiteVersion;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 400),
      child: Stack(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showSnackbar(
                          context: context,
                          message: gitStamp.gitRemote,
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
                          message: gitStamp.gitCountObjects,
                          showCloseIcon: true,
                          floating: false,
                        );
                      },
                      icon: Icon(Icons.storage),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showSnackbar(
                          context: context,
                          message: gitStamp.buildSystemInfo,
                          showCloseIcon: true,
                          floating: false,
                        );
                      },
                      icon: Icon(Icons.medical_information),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showSnackbar(
                          context: context,
                          message: gitStamp.gitConfigList,
                          showCloseIcon: true,
                          floating: false,
                        );
                      },
                      icon: Icon(Icons.settings),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return _GitStampRepoReflog(gitStamp: gitStamp);
                          },
                        );
                      },
                      icon: const Icon(Icons.history),
                    ),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return _GitStampRepoBranches(gitStamp: gitStamp);
                          },
                        );
                      },
                      icon: const Icon(Icons.call_split),
                    ),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return _GitStampRepoTags(gitStamp: gitStamp);
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
                            return _GitStampRepoFiles(gitStamp: gitStamp);
                          },
                        );
                      },
                      icon: const Icon(Icons.folder),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) => _GitStampMore(),
                        );
                      },
                      icon: const Icon(Icons.more),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGitStampSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('GitStamp', style: textTitle),
        const SizedBox(height: 4),
        _GitStampDoubleText('Version: ', gitStampVersion),
        Row(
          children: [
            Text('Build type: [', style: textDefault),
            Text('LITE', style: isLiteVersion ? textBold : textDefault),
            Text(', ', style: textDefault),
            Text('FULL', style: isLiteVersion ? textDefault : textBold),
            Text(']', style: textDefault),
          ],
        ),
      ],
    );
  }

  Widget _buildBuildSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Build', style: textTitle),
        const SizedBox(height: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GitStampDoubleText('Date: ', gitStamp.buildDateTime),
            _GitStampDoubleText('Path: ', gitStamp.repoPath),
            _GitStampDoubleText('Branch: ', gitStamp.buildBranch),
            _GitStampDoubleText('Tag: ', gitStamp.tagList.first.name),
            _GitStampDoubleText('SHA: ', gitStamp.sha),
          ],
        ),
      ],
    );
  }

  Widget _buildEnvironmentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Environment', style: textTitle),
        const SizedBox(height: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GitStampDoubleText('Global: ', gitStamp.gitConfigGlobalUser),
            _GitStampDoubleText('Local: ', gitStamp.gitConfigUser),
            ...{
              'Framework Version: ': gitStamp.buildMachine.frameworkVersion,
              'Channel: ': gitStamp.buildMachine.channel,
              'Repository Url: ': gitStamp.buildMachine.repositoryUrl,
              'Framework Revision: ': gitStamp.buildMachine.frameworkRevision,
              'Framework Commit Date: ':
                  gitStamp.buildMachine.frameworkCommitDate,
              'Engine Revision: ': gitStamp.buildMachine.engineRevision,
              'Dart Sdk Version: ': gitStamp.buildMachine.dartSdkVersion,
              'DevTools Version: ': gitStamp.buildMachine.devToolsVersion,
              'Flutter Version: ': gitStamp.buildMachine.flutterVersion,
              'Flutter Root: ': gitStamp.buildMachine.flutterRoot,
            }.entries.map((e) => _GitStampDoubleText(e.key, e.value)),
          ],
        ),
      ],
    );
  }

  Widget _buildRepositorySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Repository', style: textTitle),
        const SizedBox(height: 4),
        _GitStampDoubleText('App Name: ', gitStamp.appName),
        _GitStampDoubleText('App Version: ', gitStamp.appVersionFull),
        _GitStampDoubleText('Created: ', gitStamp.repoCreationDate),
        _GitStampDoubleText(
          'Commit count: ',
          gitStamp.isEncrypted ? 'ENCRYPTED' : gitStamp.commitCount.toString(),
        ),
        ...gitStamp.commitCountByAuthor.entries.map(
          (entry) => Row(
            children: [
              SizedBox(width: 16),
              Text('${entry.key}: ', style: textDefault),
              Text(entry.value.toString(), style: textBold),
            ],
          ),
        ),
      ],
    );
  }
}

class _GitStampRepoFiles extends StatelessWidget {
  const _GitStampRepoFiles({required this.gitStamp});

  final GitStampNode gitStamp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GitStampLabel(
                first: 'Repository files',
                second: !gitStamp.isEncrypted
                    ? gitStamp.observedFilesCount.toString()
                    : 'ENCRYPTED',
              ),
              SizedBox(height: 16.0),
              if (!gitStamp.isEncrypted) ...[
                Text(gitStamp.observedFiles, style: textDefault)
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _GitStampRepoTags extends StatelessWidget {
  const _GitStampRepoTags({required this.gitStamp});

  final GitStampNode gitStamp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GitStampLabel(
                first: 'Repository tags',
                second: !gitStamp.isEncrypted
                    ? gitStamp.tagListCount.toString()
                    : 'ENCRYPTED',
              ),
              SizedBox(height: 16.0),
              if (!gitStamp.isEncrypted) ...[
                ...gitStamp.tagList
                    .map((e) => _GitStampDoubleText('${e.date} - ', e.name)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _GitStampRepoReflog extends StatelessWidget {
  const _GitStampRepoReflog({required this.gitStamp});

  final GitStampNode gitStamp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GitStampLabel(first: 'Repository reflog'),
              SizedBox(height: 12),
              if (!gitStamp.isEncrypted) ...[
                Text(gitStamp.gitReflog, style: textDefault)
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _GitStampRepoBranches extends StatelessWidget {
  const _GitStampRepoBranches({required this.gitStamp});

  final GitStampNode gitStamp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GitStampLabel(
                first: 'Repository branches',
                second: !gitStamp.isEncrypted
                    ? gitStamp.branchListCount.toString()
                    : 'ENCRYPTED',
              ),
              SizedBox(height: 16.0),
              if (!gitStamp.isEncrypted) ...[
                Text(gitStamp.branchListString, style: textDefault)
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _GitStampFilterList extends StatelessWidget {
  final GitStampNode gitStamp;
  final String? selectedUser;
  final void Function(String? commiter) onFilterPressed;

  const _GitStampFilterList({
    required this.gitStamp,
    required this.selectedUser,
    required this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    final commitCount = gitStamp.commitCountByAuthor;

    /// null -> no filter
    final users = <String?>[null, ...gitStamp.commitAuthors];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Filter', style: textTitle),
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
                      title: Text(e ?? 'No filter', style: textBold),
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

class _GitStampMore extends StatelessWidget {
  const _GitStampMore();

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
            child: Text('Git Stamp', style: textTitle),
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
                    style: textBold,
                  ),
                  leading: Icon(Icons.mail),
                ),
                ListTile(
                  onTap: () => openProjectHomepage(),
                  title: Text('You love Git Stamp?', style: textBold),
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

class _GitStampLabel extends StatelessWidget {
  final String first;
  final String? second;

  const _GitStampLabel({required this.first, this.second});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(first, style: TextStyle(fontSize: 20)),
        if (second != null) ...[
          SizedBox(width: 8.0),
          _GitStampTextLabel(text: second!),
        ],
      ],
    );
  }
}

class _GitStampArrowIcon extends StatefulWidget {
  final VoidCallback? onPressed;

  const _GitStampArrowIcon({super.key, this.onPressed});

  @override
  State<_GitStampArrowIcon> createState() => _GitStampArrowIconState();
}

class _GitStampArrowIconState extends State<_GitStampArrowIcon>
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

class _GitStampDetailsPageText extends StatelessWidget {
  final String diffList;
  final double fontSize;
  final String? monospaceFontFamily;

  const _GitStampDetailsPageText({
    required this.diffList,
    required this.fontSize,
    this.monospaceFontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        children: [
          ...diffList.split('\n').map(
            (line) {
              return TextSpan(
                text: '$line\n',
                style: TextStyle(
                  color: _textColor(context, line),
                  backgroundColor: _backgroundColor(context, line),
                ),
              );
            },
          ),
        ],
      ),
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: monospaceFontFamily,
      ),
    );
  }

  Color _backgroundColor(BuildContext context, String line) {
    if (line.startsWith('diff --git ') ||
        line.startsWith('index ') ||
        line.startsWith('--- ') ||
        line.startsWith('+++ ') ||
        line.startsWith('@@ ') ||
        line.startsWith('new file mode ')) {
      return Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.2);
    } else if (line.startsWith('-') && !line.startsWith('--- ')) {
      return Theme.of(context).colorScheme.errorContainer.withOpacity(0.8);
    } else if (line.startsWith('+') && !line.startsWith('+++ ')) {
      return Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8);
    } else {
      return Colors.transparent;
    }
  }

  Color? _textColor(BuildContext context, String line) {
    if (line.startsWith('diff --git ') ||
        line.startsWith('index ') ||
        line.startsWith('--- ') ||
        line.startsWith('+++ ') ||
        line.startsWith('@@ ') ||
        line.startsWith('new file mode ')) {
      return Theme.of(context).colorScheme.onTertiaryContainer.withOpacity(0.4);
    } else if (line.startsWith('-') && !line.startsWith('--- ')) {
      return Theme.of(context).colorScheme.onErrorContainer;
    } else if (line.startsWith('+') && !line.startsWith('+++ ')) {
      return Theme.of(context).colorScheme.onPrimaryContainer;
    } else {
      return Theme.of(context).colorScheme.onSurface;
    }
  }
}
