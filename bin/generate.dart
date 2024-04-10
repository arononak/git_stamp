import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';

import 'generated_files/generated_git_stamp_commit.dart';
import 'generated_files/generated_git_stamp_page.dart';
import 'generated_files/generated_git_stamp_utils.dart';

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

String gitCreationDateOutput() {
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

String gitRepoPathOutput() {
  final repoPath =
      Process.runSync('git', ['rev-parse', '--show-toplevel']).stdout;

  final repoPathOutput = 'const repoPath = "${repoPath.toString().trim()}";';

  return repoPathOutput;
}

String gitDiffOutput() {
  final hashes = Process.runSync('git', ['rev-list', '--all'])
      .stdout
      .toString()
      .trim()
      .split('\n');

  Map<String, String> gitShowMap = {};

  for (var hash in hashes) {
    gitShowMap[hash] = Process.runSync('git', ['show', hash]).stdout.toString();
    print('git show $hash');
  }

  final diffOutput =
      'const diffOutput = <String, String>${jsonEncode(gitShowMap).replaceAll(r'$', r'\$')};';

  return diffOutput;
}

void main() {
  const mainFolder = 'lib/git_stamp';
  const dataFolder = 'lib/git_stamp/data';

  Directory(mainFolder)
    ..deleteSync(recursive: true)
    ..createSync(recursive: true);

  Directory(dataFolder).createSync(recursive: true);

  void saveFile(String filename, String content) {
    File(filename).writeAsStringSync(content);
  }

  saveFile('$dataFolder/json_output.dart', gitLogOutput()); // List
  saveFile('$dataFolder/diff_output.dart', gitDiffOutput()); // Details
  saveFile('$dataFolder/creation_date_output.dart', gitCreationDateOutput());
  saveFile('$dataFolder/branch_output.dart', gitBranchOutput());
  saveFile('$dataFolder/build_date_time_output.dart', buildDateOutput());
  saveFile('$dataFolder/build_system_info_output.dart', buildSystemInfo());
  saveFile('$dataFolder/repo_path_output.dart', gitRepoPathOutput());

  saveFile('$mainFolder/git_stamp_commit.dart', generatedGitStampCommit);
  saveFile('$mainFolder/git_stamp_utils.dart', generatedGitStampUtils);
  saveFile('$mainFolder/git_stamp_page.dart', generatedGitStampPage);
}
