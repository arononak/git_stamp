const rawGitStampDetailsPage = '''
import 'package:flutter/material.dart';

import 'package:aron_gradient_line/aron_gradient_line.dart';

import '../../git_stamp.dart';

void showGitStampDetailsPage({
  required BuildContext context,
  bool useRootNavigator = false,
  required GitStampCommit commit,
  String? monospaceFontFamily,
}) {
  Navigator.of(
    context,
    rootNavigator: useRootNavigator,
  ).push(MaterialPageRoute<void>(
    builder: (BuildContext context) {
      return GitStampDetailsPage(
        commit: commit,
        monospaceFontFamily: monospaceFontFamily,
      );
    },
  ));
}

class GitStampDetailsPage extends StatefulWidget {
  final GitStampCommit commit;
  final String? monospaceFontFamily;

  const GitStampDetailsPage({
    Key? key,
    required this.commit,
    this.monospaceFontFamily,
  }) : super(key: key);

  @override
  State<GitStampDetailsPage> createState() => _GitStampDetailsPageState();
}

class _GitStampDetailsPageState extends State<GitStampDetailsPage> {
  var _fontSize = 12;

  String get diffList => GitStamp.diffList[widget.commit.hash] ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: GitStampCommitListHeader(commit: widget.commit),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: AronGradientLine(),
        ),
        actions: [
          IconButton(
            onPressed: () => setState(() => _fontSize -= _fontSize <= 1 ? 0 : 1),
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
        child: SingleChildScrollView(
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
                  GitStampDetailsPageText(
                    diffList: diffList,
                    monospaceFontFamily: widget.monospaceFontFamily,
                    fontSize: _fontSize.toDouble(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => copyToClipboard(context, diffList),
        child: Icon(Icons.copy),
      ),
    );
  }
}

class GitStampDetailsPageText extends StatelessWidget {
  final String diffList;
  final double fontSize;
  final String? monospaceFontFamily;

  const GitStampDetailsPageText({
    super.key,
    required this.diffList,
    required this.fontSize,
    this.monospaceFontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        children: [
          ...diffList.split(newLine).map(
            (line) {
              return TextSpan(
                text: line + newLine,
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

''';
