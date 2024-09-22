const rawGitStampDetailsPage = '''
import 'package:example/git_stamp/src/ui/git_stamp_page.dart';
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

class GitStampDetailsPage extends StatelessWidget {
  final GitStampCommit commit;
  final String? monospaceFontFamily;

  const GitStampDetailsPage({
    Key? key,
    required this.commit,
    this.monospaceFontFamily,
  }) : super(key: key);

  Color _backgroundColor(BuildContext context, String line) {
    if (line.startsWith('diff --git ') ||
        line.startsWith('index ') ||
        line.startsWith('--- ') ||
        line.startsWith('+++ ') ||
        line.startsWith('@@ ') ||
        line.startsWith('new file mode ')) {
      return Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.2);
    } else if (line.startsWith('-') && !line.startsWith('--- ')) {
      return Theme.of(context).colorScheme.errorContainer;
    } else if (line.startsWith('+') && !line.startsWith('+++ ')) {
      return Theme.of(context).colorScheme.primaryContainer;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: GitStampCommitListHeader(commit: commit),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: AronGradientLine(),
        ),
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
                  ...(GitStamp.diffList[commit.hash] ?? '')
                      .toString()
                      .split('\\n')
                      .map(
                        (line) => Container(
                          color: _backgroundColor(context, line),
                          child: Text(
                            line,
                            style: TextStyle(
                              fontFamily: monospaceFontFamily,
                              fontSize: 12,
                              color: _textColor(context, line),
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

''';
