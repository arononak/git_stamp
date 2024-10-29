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
bool _isMobile(context) => MediaQuery.of(context).size.width < 600;
      return _GitStampRepoDetails(
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return _GitStampRepoFiles(gitStamp: widget.gitStamp);
          },
        title: _GitStampLabel(
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
                  _GitStampArrowIcon(
          : _GitStampCommitList(
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
  const _GitStampTextLabel({required this.text});
class _GitStampCommitHeader {
  const _GitStampCommitHeader({
class _GitStampCommitList extends StatelessWidget {
  const _GitStampCommitList({
      listElement.add(_GitStampCommitHeader(date: key, count: commits.length));
          case _GitStampCommitHeader():
            return _GitStampDateListElement(
            return _GitStampCommitListElement(
class _GitStampDateListElement extends StatelessWidget {
  const _GitStampDateListElement({
class _GitStampCommitListElement extends StatelessWidget {
  const _GitStampCommitListElement({
                : _isMobile(context)
            title: _GitStampCommitListHeader(commit: commit),
                      child: _GitStampCommitListHeader(commit: commit),
class _GitStampCommitListHeader extends StatelessWidget {
  const _GitStampCommitListHeader({required this.commit});
class _GitStampDoubleText extends StatelessWidget {
  const _GitStampDoubleText(this.left, this.right);
class _GitStampRepoDetails extends StatelessWidget {
  const _GitStampRepoDetails({
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return _GitStampRepoReflog(gitStamp: gitStamp);
                          },
                        );
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return _GitStampRepoBranches(gitStamp: gitStamp);
                          },
                        );
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return _GitStampRepoTags(gitStamp: gitStamp);
                          },
                        );
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return _GitStampRepoFiles(gitStamp: gitStamp);
                          },
                        );
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) => _GitStampMore(),
                        );
                      },
        _GitStampDoubleText('Version: ', gitStampVersion),
            _GitStampDoubleText('Date: ', gitStamp.buildDateTime),
            _GitStampDoubleText('Path: ', gitStamp.repoPath),
            _GitStampDoubleText('Branch: ', gitStamp.buildBranch),
            _GitStampDoubleText('Tag: ', gitStamp.tagList.first.name),
            _GitStampDoubleText('SHA: ', gitStamp.sha),
            _GitStampDoubleText('Global: ', gitStamp.gitConfigGlobalUser),
            _GitStampDoubleText('Local: ', gitStamp.gitConfigUser),
            }.entries.map((e) => _GitStampDoubleText(e.key, e.value)),
        _GitStampDoubleText('App Name: ', gitStamp.appName),
        _GitStampDoubleText('App Version: ', gitStamp.appVersionFull),
        _GitStampDoubleText('Created: ', gitStamp.repoCreationDate),
        _GitStampDoubleText(
        ...gitStamp.commitCountByAuthor.entries.map(
          (entry) => Row(
            children: [
              SizedBox(width: 16),
              Text('${entry.key}: ', style: textDefault),
              Text(entry.value.toString(), style: textBold),
            ],
          ),
        ),
class _GitStampRepoFiles extends StatelessWidget {
  const _GitStampRepoFiles({required this.gitStamp});
              _GitStampLabel(
class _GitStampRepoTags extends StatelessWidget {
  const _GitStampRepoTags({required this.gitStamp});
              _GitStampLabel(
                    .map((e) => _GitStampDoubleText('${e.date} - ', e.name)),
class _GitStampRepoReflog extends StatelessWidget {
  const _GitStampRepoReflog({required this.gitStamp});
              _GitStampLabel(first: 'Repository reflog'),
class _GitStampRepoBranches extends StatelessWidget {
  const _GitStampRepoBranches({required this.gitStamp});
              _GitStampLabel(
class _GitStampFilterList extends StatelessWidget {
  const _GitStampFilterList({
    final commitCount = gitStamp.commitCountByAuthor;
    final users = <String?>[null, ...gitStamp.commitAuthors];
class _GitStampMore extends StatelessWidget {
  const _GitStampMore();
class _GitStampLabel extends StatelessWidget {
  const _GitStampLabel({required this.first, this.second});
          _GitStampTextLabel(text: second!),
class _GitStampArrowIcon extends StatefulWidget {
  const _GitStampArrowIcon({super.key, this.onPressed});
  State<_GitStampArrowIcon> createState() => _GitStampArrowIconState();
class _GitStampArrowIconState extends State<_GitStampArrowIcon>

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