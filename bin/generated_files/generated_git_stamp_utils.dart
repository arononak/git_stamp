const generatedGitStampUtils = '''
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'git_stamp_commit.dart';

void openEmail({
  required String email,
  String? subject,
}) {
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries.map(
      (MapEntry<String, String> e) {
        return Uri.encodeComponent(e.key) + '=' + Uri.encodeComponent(e.value);
      },
    ).join('&');
  }

  launchUrl(
    Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(
        <String, String>{'subject': subject ?? ''},
      ),
    ),
  );
}

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      showCloseIcon: true,
      duration: Duration(seconds: 5),
    ),
  );
}

void openProjectHomepage() {
  launchUrl(Uri(
    scheme: 'https',
    host: 'github.com',
    path: 'arononak/git_stamp',
  ));
}

void copyToClipboard(BuildContext context, String text) {
  Clipboard.setData(ClipboardData(text: text));
  showSnackbar(context, 'Copied to clipboard !');
}

Map<String, int> commitCountByAuthor() {
  Map<String, int> map = {};

  for (GitStampCommit commit in GitStampCommit.commitList) {
    map.update(commit.authorName, (value) => (value) + 1, ifAbsent: () => 1);
  }

  return map;
}

List<String> parseBuildSystemInfo(text) {
  List<String> elements = RegExp(r'\\((.*?)\\)').firstMatch(text)?.group(1)?.split(', ') ?? [];

  return elements.isEmpty ? ["No data :/"] : elements;
}

''';
