import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';

import 'generated_files/generated_git_stamp_commit.dart';
import 'generated_files/generated_git_stamp_page.dart';

String gitLogOutput() {
  final gitLogJson = Process.runSync(
    'git',
    [
      'log',
      '--pretty=format:{"hash":"%H","subject":"%s","date":"%ad","authorName":"%an","authorEmail":"%ae"}',
      '--date=format-local:%Y-%m-%d %H:%M',
    ],
  ).stdout;

  final logs =
      LineSplitter.split(gitLogJson).map((line) => json.decode(line)).toList();

  final logsOutput =
      '''const jsonOutput = \'\'\'\n${jsonEncode(logs)}\n\'\'\';''';

  return logsOutput;
}

String gitRepoCreationDateOutput() {
  final date = Process.runSync(
    'git',
    [
      'log',
      '--reverse',
      '--pretty=format:%ad',
      '--date=format:%Y-%m-%d %H:%M:%S'
    ],
  ).stdout;

  final dateOutput =
      'const repoCreationDate = "${date.toString().split('\n').first.trim()}";';

  return dateOutput;
}

String gitBranchOutput() {
  final branch =
      Process.runSync('git', ['rev-parse', '--abbrev-ref', 'HEAD']).stdout;

  final branchOutput = 'const buildBranch = "${branch.toString().trim()}";';

  return branchOutput;
}

String buildDateOutput() {
  final buildDateTime =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  final buildDateTimeOutput =
      'const buildDateTime = "${buildDateTime.toString().trim()}";';

  return buildDateTimeOutput;
}

String buildSystemInfo() {
  final systemInfo = Process.runSync('flutter', ['doctor']).stdout;

  String? systemInfoParsed = systemInfo
      .toString()
      .split('\n')
      .where((line) => line.contains('] Flutter'))
      .toList()
      .firstOrNull;

  final systemInfoOutput =
      'const buildSystemInfo = "${systemInfoParsed.toString().trim()}";';

  return systemInfoOutput;
}

void main() {
  const outputFolder = 'lib/git_stamp';

  final directory = Directory(outputFolder);
  directory.deleteSync(recursive: true);
  directory.createSync(recursive: true);

  void saveFile(String filename, String content) {
    File(filename).writeAsStringSync(content);
  }

  saveFile('$outputFolder/git_stamp_json_output.dart', gitLogOutput());
  saveFile('$outputFolder/git_stamp_repo_creation_date_output.dart',
      gitRepoCreationDateOutput());
  saveFile('$outputFolder/git_stamp_branch_output.dart', gitBranchOutput());
  saveFile(
      '$outputFolder/git_stamp_build_date_time_output.dart', buildDateOutput());
  saveFile('$outputFolder/git_stamp_build_system_info_output.dart',
      buildSystemInfo());

  saveFile('$outputFolder/git_stamp_commit.dart', generatedGitStampCommit);
  saveFile('$outputFolder/git_stamp_page.dart', generatedGitStampPage);
}
