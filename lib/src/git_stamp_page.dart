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

bool isMobile(context) => MediaQuery.of(context).size.width < 600;

void _showRepoFilesBottomSheet(
  BuildContext context, {
  required GitStampNode gitStamp,
}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return GitStampRepoFiles(gitStamp: gitStamp);
    },
  );
}

void _showRepoTagsBottomSheet(
  BuildContext context, {
  required GitStampNode gitStamp,
}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return GitStampRepoTags(gitStamp: gitStamp);
    },
  );
}

void _showRepoReflogBottomSheet(
  BuildContext context, {
  required GitStampNode gitStamp,
}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return GitStampRepoReflog(gitStamp: gitStamp);
    },
  );
}

void _showRepoBranchesBottomSheet(
  BuildContext context, {
  required GitStampNode gitStamp,
}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return GitStampRepoBranches(gitStamp: gitStamp);
    },
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
  required GitStampNode gitStamp,
  required String? selectedUser,
  required void Function(String? commiter) onFilterPressed,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return GitStampFilterList(
        gitStamp: gitStamp,
        selectedUser: selectedUser,
        onFilterPressed: onFilterPressed,
      );
    },
  );
}

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
      return GitStampRepoDetails(
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
        _showRepoFilesBottomSheet(
          context,
          gitStamp: widget.gitStamp,
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
        title: GitStampLabel(
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
                      _showFilterBottomSheet(
                        context,
                        gitStamp: widget.gitStamp,
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
          : GitStampCommitList(
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

class GitStampCommitHeader {
  final String date;
  final int count;

  const GitStampCommitHeader({
    required this.date,
    required this.count,
  });
}

class GitStampCommitList extends StatelessWidget {
  final GitStampNode gitStamp;
  final List<GitStampCommit> commits;
  final String? filterAuthorName;
  final bool isLiteVersion;
  final bool itemLargeType;
  final String? monospaceFontFamily;

  const GitStampCommitList({
    super.key,
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
      listElement.add(GitStampCommitHeader(date: key, count: commits.length));
      listElement.addAll(commits);
    });

    return ListView.builder(
      itemCount: listElement.length,
      itemBuilder: (context, index) {
        final element = listElement[index];

        switch (element) {
          case GitStampCommitHeader():
            return GitStampDateListElement(
              date: element.date,
              count: element.count,
            );
          case GitStampCommit():
            return GitStampCommitListElement(
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

class GitStampDateListElement extends StatelessWidget {
  final String date;
  final int count;

  const GitStampDateListElement({
    super.key,
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

class GitStampCommitListElement extends StatelessWidget {
  final GitStampNode gitStamp;
  final GitStampCommit commit;
  final bool isLiteVersion;
  final bool itemLargeType;
  final String? monospaceFontFamily;

  const GitStampCommitListElement({
    super.key,
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
                      child: GitStampCommitListHeader(commit: commit),
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

class GitStampCommitListHeader extends StatelessWidget {
  final GitStampCommit commit;

  const GitStampCommitListHeader({super.key, required this.commit});

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

  const GitStampDoubleText(this.left, this.right, {super.key});

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

class GitStampRepoDetails extends StatelessWidget {
  const GitStampRepoDetails({
    super.key,
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
                        _showRepoReflogBottomSheet(context, gitStamp: gitStamp);
                      },
                      icon: const Icon(Icons.history),
                    ),
                    IconButton(
                      onPressed: () {
                        _showRepoBranchesBottomSheet(context,
                            gitStamp: gitStamp);
                      },
                      icon: const Icon(Icons.call_split),
                    ),
                    IconButton(
                      onPressed: () {
                        _showRepoTagsBottomSheet(context, gitStamp: gitStamp);
                      },
                      icon: const Icon(Icons.tag),
                    ),
                    IconButton(
                      onPressed: () {
                        _showRepoFilesBottomSheet(context, gitStamp: gitStamp);
                      },
                      icon: const Icon(Icons.folder),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _showMoreBottomSheet(context),
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
        GitStampDoubleText('Version: ', gitStampVersion),
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
            GitStampDoubleText('Date: ', gitStamp.buildDateTime),
            GitStampDoubleText('Path: ', gitStamp.repoPath),
            GitStampDoubleText('Branch: ', gitStamp.buildBranch),
            GitStampDoubleText('Tag: ', gitStamp.tagList.first.name),
            GitStampDoubleText('SHA: ', gitStamp.sha),
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
            GitStampDoubleText('Global: ', gitStamp.gitConfigGlobalUser),
            GitStampDoubleText('Local: ', gitStamp.gitConfigUser),
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
            }.entries.map((e) => GitStampDoubleText(e.key, e.value)),
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
        GitStampDoubleText('App Name: ', gitStamp.appName),
        GitStampDoubleText('App Version: ', gitStamp.appVersionFull),
        GitStampDoubleText('Created: ', gitStamp.repoCreationDate),
        GitStampDoubleText(
          'Commit count: ',
          gitStamp.isEncrypted ? 'ENCRYPTED' : gitStamp.commitCount.toString(),
        ),
        ...commitCountByAuthor(gitStamp).entries.map(
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

class GitStampRepoFiles extends StatelessWidget {
  const GitStampRepoFiles({super.key, required this.gitStamp});

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
              GitStampLabel(
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

class GitStampRepoTags extends StatelessWidget {
  const GitStampRepoTags({super.key, required this.gitStamp});

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
              GitStampLabel(
                first: 'Repository tags',
                second: !gitStamp.isEncrypted
                    ? gitStamp.tagListCount.toString()
                    : 'ENCRYPTED',
              ),
              SizedBox(height: 16.0),
              if (!gitStamp.isEncrypted) ...[
                ...gitStamp.tagList
                    .map((e) => GitStampDoubleText('${e.date} - ', e.name)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class GitStampRepoReflog extends StatelessWidget {
  const GitStampRepoReflog({super.key, required this.gitStamp});

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
              GitStampLabel(first: 'Repository reflog'),
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

class GitStampRepoBranches extends StatelessWidget {
  const GitStampRepoBranches({super.key, required this.gitStamp});

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
              GitStampLabel(
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

class GitStampFilterList extends StatelessWidget {
  final GitStampNode gitStamp;
  final String? selectedUser;
  final void Function(String? commiter) onFilterPressed;

  const GitStampFilterList({
    super.key,
    required this.gitStamp,
    required this.selectedUser,
    required this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    final commitCount = commitCountByAuthor(gitStamp);

    /// null -> no filter
    final users = <String?>[null, ...commitAuthors(gitStamp)];

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

class GitStampMore extends StatelessWidget {
  const GitStampMore({super.key});

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

class GitStampLabel extends StatelessWidget {
  final String first;
  final String? second;

  const GitStampLabel({super.key, required this.first, this.second});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(first, style: TextStyle(fontSize: 20)),
        if (second != null) ...[
          SizedBox(width: 8.0),
          GitStampTextLabel(text: second!),
        ],
      ],
    );
  }
}

class GitStampArrowIcon extends StatefulWidget {
  final VoidCallback? onPressed;

  const GitStampArrowIcon({super.key, this.onPressed});

  @override
  State<GitStampArrowIcon> createState() => _GitStampArrowIconState();
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
