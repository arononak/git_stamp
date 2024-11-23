// Copyright © 2024 Aron Onak. All rights reserved.
// Licensed under the MIT license.
// If you have any feedback, please contact me at arononak@gmail.com

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:aron_gradient_line/aron_gradient_line.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/dateable.dart';
import 'model/commit.dart';
import 'model/package.dart';
import 'model/tag.dart';
import 'git_stamp_node.dart';

const _textDefault = TextStyle(fontSize: 12);
const _textBold = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
const _textTitle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

extension _GitStampNode on GitStampNode {
  Map<String, int> get commitCountByAuthor {
    Map<String, int> map = {};

    for (Commit commit in commitList) {
      map.update(commit.authorName, (value) => (value) + 1, ifAbsent: () => 1);
    }

    return map;
  }

  List<String> get commitAuthors {
    Set<String> authors = {};

    for (Commit commit in commitList) {
      authors.add(commit.authorName);
    }

    return authors.toList();
  }
}

extension _String on String {
  String get asOnlyDate {
    final date = DateTime.parse(this);

    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
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

void _showPackagesDialog(BuildContext context, GitStampNode gitStamp) {
  Widget buildItem(Package item) {
    final version = item.current?.version;
    final latest = item.latest?.version;
    final possibleUpdate =
        version != null && latest != null && version != latest;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                '${item.package}: ',
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$version',
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (possibleUpdate) ...[
            Text(
              'latest: $latest',
              style: TextStyle(
                fontSize: 8,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
              ),
            ),
          ] else ...[
            Text(
              'The newest',
              style: TextStyle(
                fontSize: 8,
              ),
            ),
          ],
        ],
      ),
    );
  }

  final items = gitStamp.packageList;
  items.sort((a, b) => a.kind?.compareTo(b.kind ?? '') ?? 0);
  final groupedItems = groupBy(items, (item) => item.kind);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: _GitStampLabel(
          first: 'Dependencies',
          second: items.length.toString(),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            children: [
              ...{
                'dependencies:': groupedItems['direct'] ?? [],
                'dev_dependencies:': groupedItems['dev'] ?? [],
                'transitive:': groupedItems['transitive'] ?? [],
              }.entries.map(
                (entry) {
                  final values = entry.value;
                  return ExpansionTile(
                    tilePadding: EdgeInsets.symmetric(horizontal: 8.0),
                    childrenPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    title: Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${values.length} packages',
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    children: values.map((item) => buildItem(item)).toList(),
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}

/// The [GitStampPage] displays a main GitStamp page.
///
/// You should use [GitStamp.listTile] or the [GitStamp.showMainPage] function.
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
                      return _GitStampDecryptForm(
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
              filterName: _filterAuthorName,
              isLiteVersion: widget.isLiteVersion,
              itemLargeType: itemLargeType,
              monospaceFontFamily: widget.monospaceFontFamily,
            ),
    );
  }
}

/// The [GitStampDetailsPage] displays a page with commit diff.
///
/// You should use [GitStampListTile] or the [showGitStampPage] function.
class GitStampDetailsPage extends StatefulWidget {
  final GitStampNode gitStamp;
  final Commit commit;
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
  String get _hash => widget.commit.hash;

  String get _diff => widget.gitStamp.diffList.elementForHash(_hash);

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
                        diffList: _diff,
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
        onPressed: () => _copyToClipboard(context, _diff),
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
  final String? filterName;
  final bool isLiteVersion;
  final bool itemLargeType;
  final String? monospaceFontFamily;

  const _GitStampCommitList({
    required this.gitStamp,
    this.filterName,
    this.isLiteVersion = true,
    this.itemLargeType = true,
    this.monospaceFontFamily,
  });

  @override
  Widget build(BuildContext context) {
    List<dynamic> listElement = [];

    final commitAndTags = <Dateable>[
      ...gitStamp.tagList,
      ...gitStamp.commitList,
    ];

    commitAndTags.sort(
        (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));

    groupBy(
      commitAndTags.where(
        (e) => e is! Commit
            ? true
            : filterName == null
                ? true
                : e.authorName == filterName,
      ),
      (e) => e.date.asOnlyDate,
    ).forEach((key, dateable) {
      listElement.add(_GitStampCommitHeader(date: key, count: dateable.length));
      listElement.addAll(dateable);
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
          case Commit():
            return _GitStampCommitListElement(
              gitStamp: gitStamp,
              commit: element,
              isLiteVersion: isLiteVersion,
              itemLargeType: itemLargeType,
              monospaceFontFamily: monospaceFontFamily,
            );
          case Tag():
            return _GitStampTagListElement(
              tag: element,
              itemLargeType: itemLargeType,
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
  final Commit commit;
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

  bool get _isBotCommit => commit.authorEmail.contains('[bot]');

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
                        _isBotCommit ? Icons.auto_mode : Icons.code,
                        size: 36,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(_isBotCommit ? 0.1 : 1.0),
                      ),
            title: _GitStampCommitListHeader(commit: commit),
            subtitle: itemLargeType == false
                ? null
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => _openEmail(email: commit.authorEmail),
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
                          fontSize: 14.0,
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
              onPressed: () => _copyToClipboard(context, commit.hash),
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
                      gitStamp.diffStatList.elementForHash(commit.hash),
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

class _GitStampTagListElement extends StatelessWidget {
  final Tag tag;
  final bool itemLargeType;

  const _GitStampTagListElement({
    required this.tag,
    required this.itemLargeType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      margin: EdgeInsets.symmetric(
        horizontal: 0.0,
        vertical: itemLargeType == false ? 0.0 : 4.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
      elevation: 0.0,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: itemLargeType == false ? 8.0 : 16,
        ),
        child: ListTile(
          dense: true,
          minTileHeight: 0.0,
          contentPadding: const EdgeInsets.all(0),
          leading: itemLargeType == false
              ? null
              : _isMobile(context)
                  ? null
                  : Icon(
                      Icons.local_offer,
                      size: 36,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
          title: Text(
            tag.name,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          subtitle: itemLargeType == false
              ? null
              : Text(
                  tag.date,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer
                        .withOpacity(0.7),
                  ),
                ),
        ),
      ),
    );
  }
}

class _GitStampCommitListHeader extends StatelessWidget {
  final Commit commit;

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
        Text(left, style: _textDefault),
        Text(right, style: _textBold),
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
                        _showSnackbar(
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
                        _showSnackbar(
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
                        _showSnackbar(
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
                        _showSnackbar(
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
                      icon: const Icon(
                        key: Key('show_tags_icon'),
                        Icons.local_offer,
                      ),
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
                        _showPackagesDialog(context, gitStamp);
                      },
                      icon: Icon(Icons.integration_instructions),
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
                      icon: Icon(Icons.more, color: Colors.orange),
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
        Text('GitStamp', style: _textTitle),
        const SizedBox(height: 4),
        _GitStampDoubleText('Version: ', gitStampVersion),
        Row(
          children: [
            Text('Build type: [', style: _textDefault),
            Text('LITE', style: isLiteVersion ? _textBold : _textDefault),
            Text(', ', style: _textDefault),
            Text('FULL', style: isLiteVersion ? _textDefault : _textBold),
            Text(']', style: _textDefault),
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
        Text('Environment', style: _textTitle),
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
        Text('Repository', style: _textTitle),
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
              Text('${entry.key}: ', style: _textDefault),
              Text(entry.value.toString(), style: _textBold),
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
                Text(gitStamp.observedFiles, style: _textDefault)
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
                Text(gitStamp.gitReflog, style: _textDefault)
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
                Text(gitStamp.branchListString, style: _textDefault)
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
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  onTap: () => _openEmail(email: 'arononak@gmail.com'),
                  title: Text('Have a great idea for GitStamp?'),
                  leading: Icon(Icons.mail),
                ),
                ListTile(
                  onTap: () => _openProjectHomepage(),
                  title: Text('You love GitStamp?'),
                  leading: Icon(Icons.star),
                ),
                ListTile(
                  onLongPress: () => _openProjectHomepage(),
                  title: Text('Become a contributor!'),
                  subtitle: Text(
                    'Create a Pull Request and agree to be listed.\nIf it gets merged you will be in the README.md file.\nPress LongPress to get started.',
                  ),
                  tileColor: Colors.orange.withOpacity(0.5),
                  splashColor: Colors.orange,
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

/// Generated by ChatGPT
Uint8List _hexToUint8List(String hex) {
  return Uint8List.fromList(hex
      .replaceAll(' ', '')
      .replaceAllMapped(RegExp(r'..'),
          (match) => String.fromCharCode(int.parse(match.group(0)!, radix: 16)))
      .codeUnits);
}

class _GitStampDecryptForm extends StatefulWidget {
  const _GitStampDecryptForm({
    required this.gitStamp,
    this.startKey,
    this.startIv,
    this.onSuccess,
  });

  final GitStampNode gitStamp;
  final String? startKey;
  final String? startIv;
  final VoidCallback? onSuccess;

  @override
  State<_GitStampDecryptForm> createState() => _GitStampDecryptFormState();
}

class _GitStampDecryptFormState extends State<_GitStampDecryptForm> {
  late final TextEditingController _keyController;
  late final TextEditingController _ivController;

  @override
  void initState() {
    _keyController = TextEditingController(text: widget.startKey);
    _ivController = TextEditingController(text: widget.startIv);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Data Decryption', style: _textTitle),
          SizedBox(height: 12),
          _buildHexTextField(
            text: 'KEY',
            length: 64,
            controller: _keyController,
          ),
          SizedBox(height: 12),
          _buildHexTextField(
            text: 'IV',
            length: 32,
            controller: _ivController,
          ),
          TextButton(
            onPressed: () {
              final success = widget.gitStamp.decrypt(
                _hexToUint8List(_keyController.text),
                _hexToUint8List(_ivController.text),
              );

              if (!success) {
                _showSnackbar(context: context, message: 'Error');
                Navigator.of(context).pop();
                return;
              }

              _showSnackbar(context: context, message: 'Success');
              Navigator.of(context).pop();
              widget.onSuccess?.call();
            },
            child: Text('Decrypt'),
          ),
        ],
      ),
    );
  }

  Widget _buildHexTextField({
    String? text,
    int? length,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        label: Text(text ?? ''),
      ),
      keyboardType: TextInputType.text,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'[0-9a-fA-F]'),
        ),
      ],
      maxLength: length ?? 32,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
    );
  }
}

void _openEmail({
  String? email,
  String? subject,
}) {
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  launchUrl(
    Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{'subject': subject ?? ''}),
    ),
  );
}

void _openProjectHomepage() {
  launchUrl(Uri(
    scheme: 'https',
    host: 'github.com',
    path: 'arononak/git_stamp',
  ));
}

void _showSnackbar({
  required BuildContext context,
  required String message,
  bool floating = true,
  bool showCloseIcon = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      closeIconColor: Colors.white,
      showCloseIcon: showCloseIcon,
      behavior: floating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
      duration: floating ? Duration(seconds: 3) : Duration(seconds: 15),
      backgroundColor: Colors.orange.withOpacity(0.9),
      content: Stack(
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void _copyToClipboard(BuildContext context, String text) {
  Clipboard.setData(ClipboardData(text: text));
  _showSnackbar(
    context: context,
    message: 'Copied to clipboard!',
    showCloseIcon: true,
  );
}
