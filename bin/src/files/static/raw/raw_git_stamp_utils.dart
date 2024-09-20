const rawGitStampUtils = '''
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../git_stamp.dart';

void showSnackbar({
  required BuildContext context,
  required String message,
  bool showCloseIcon = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      closeIconColor: Colors.white,
      showCloseIcon: showCloseIcon,
      duration: Duration(seconds: 15),
      backgroundColor: Colors.orange,
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

void copyToClipboard(BuildContext context, String text) {
  Clipboard.setData(ClipboardData(text: text));
  showSnackbar(
    context: context,
    message: 'Copied to clipboard!',
    showCloseIcon: true,
  );
}

Map<String, int> commitCountByAuthor() {
  Map<String, int> map = {};

  for (GitStampCommit commit in GitStamp.commitList) {
    map.update(commit.authorName, (value) => (value) + 1, ifAbsent: () => 1);
  }

  return map;
}

List<String> commitAuthors() {
  Set<String> authors = {};

  for (GitStampCommit commit in GitStamp.commitList) {
    authors.add(commit.authorName);
  }

  return authors.toList();
}

''';
