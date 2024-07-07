const rawGitStampUtils = '''
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../git_stamp.dart';

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      showCloseIcon: true,
      duration: Duration(seconds: 5),
    ),
  );
}

void copyToClipboard(BuildContext context, String text) {
  Clipboard.setData(ClipboardData(text: text));
  showSnackbar(context, 'Copied to clipboard !');
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

List<String> parseBuildSystemInfo(text) {
  List<String> elements = RegExp(r'\\((.*?)\\)').firstMatch(text)?.group(1)?.split(', ') ?? [];

  return elements.isEmpty ? ["No data :/"] : elements;
}
''';
