// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:args/args.dart';
import 'package:intl/intl.dart';

import 'generated_files/generated_git_stamp.dart';
import 'generated_files/generated_git_stamp_commit.dart';
import 'generated_files/generated_git_stamp_details_page.dart';
import 'generated_files/generated_git_stamp_launcher.dart';
import 'generated_files/generated_git_stamp_launcher_empty.dart';
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
      '''const generatedJsonOutput = \'\'\'\n${jsonEncode(logs)}\n\'\'\';''';

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
      'const generatedRepoCreationDate = "${date.toString().split('\n').first.trim()}";';

  return dateOutput;
}

String gitBranchOutput() {
  final branch =
      Process.runSync('git', ['rev-parse', '--abbrev-ref', 'HEAD']).stdout;

  final branchOutput =
      'const generatedBuildBranch = "${branch.toString().trim()}";';

  return branchOutput;
}

String buildDateOutput() {
  final buildDateTime =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  final buildDateTimeOutput =
      'const generatedBuildDateTime = "${buildDateTime.toString().trim()}";';

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
      'const generatedBuildSystemInfo = "${systemInfoParsed.toString().trim()}";';

  return systemInfoOutput;
}

String gitRepoPathOutput() {
  final repoPath =
      Process.runSync('git', ['rev-parse', '--show-toplevel']).stdout;

  final repoPathOutput =
      'const generatedRepoPath = "${repoPath.toString().trim()}";';

  return repoPathOutput;
}

String gitDiffOutput(bool generateEmpty) {
  Map<String, String> gitShowMap = {};

  if (generateEmpty == false) {
    final hashes = Process.runSync('git', ['rev-list', '--all'])
        .stdout
        .toString()
        .trim()
        .split('\n');

    for (var hash in hashes) {
      gitShowMap[hash] =
          Process.runSync('git', ['show', hash]).stdout.toString();
    }
  }

  final diffOutput =
      'const generatedDiffOutput = <String, String>${jsonEncode(gitShowMap).replaceAll(r'$', r'\$')};';

  return diffOutput;
}

String getFileSize(String filepath, int decimals) {
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  final bytes = File(filepath).lengthSync();

  if (bytes <= 0) {
    return "0 B";
  }

  final i = (log(bytes) / log(1024)).floor();

  return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}

String getGeneratedVersion(bool isLiteVersion) {
  return 'const generatedIsLiteVersion = $isLiteVersion;';
}

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption(
      'buildtype',
      abbr: 'b',
      allowed: ['full', 'lite'],
      defaultsTo: 'lite',
    )
    ..addOption(
      'url_launcher',
      abbr: 'u',
      allowed: ['enabled', 'disabled'],
      defaultsTo: 'disabled',
    )
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
    );

  try {
    final results = parser.parse(arguments);
    if (results['help']) {
      print(parser.usage);
      return;
    }

    final buildtype = results['buildtype'];
    final urlLauncher = results['url_launcher'];

    final isLiteVersion = buildtype.toLowerCase() == 'lite';
    final generateUrlLauncher = urlLauncher.toLowerCase() == 'enabled';

    _generateFiles(isLiteVersion, generateUrlLauncher);
  } on FormatException catch (e) {
    print(e.message);
    print('Usage: dart pub run git_stamp.dart [options]');
    print(parser.usage);
    exit(1);
  }
}

void _saveFile(String filename, String content) {
  File(filename).writeAsStringSync(content);
}

void _generateFiles(bool isLiteVersion, bool urlLauncher) {
  print('');
  print('Generation version: ${isLiteVersion ? 'LITE' : 'FULL'}');
  print('Use \'url_launcher\' package: ${urlLauncher ? 'true' : 'false'}');
  print('');

  const mainFolder = 'lib/git_stamp';
  const dataFolder = 'lib/git_stamp/data';

  Directory(mainFolder).deleteSync(recursive: true);
  Directory(mainFolder).createSync(recursive: true);
  Directory(dataFolder).createSync(recursive: true);

  _saveFile(
    '$dataFolder/generated_version.dart',
    getGeneratedVersion(isLiteVersion),
  );

  // List
  _saveFile('$dataFolder/json_output.dart', gitLogOutput());

  // Details
  _saveFile('$dataFolder/diff_output.dart', gitDiffOutput(isLiteVersion));

  final listSize = getFileSize('$dataFolder/json_output.dart', 2);
  final detailsSize = getFileSize('$dataFolder/diff_output.dart', 2);
  print('Generated files size: <List: $listSize, Details: $detailsSize>');

  _saveFile('$dataFolder/creation_date_output.dart', gitCreationDateOutput());
  _saveFile('$dataFolder/branch_output.dart', gitBranchOutput());
  _saveFile('$dataFolder/build_date_time_output.dart', buildDateOutput());
  _saveFile('$dataFolder/build_system_info_output.dart', buildSystemInfo());
  _saveFile('$dataFolder/repo_path_output.dart', gitRepoPathOutput());

  _saveFile('$mainFolder/git_stamp_utils.dart', generatedGitStampUtils);

  urlLauncher
      ? _saveFile(
          '$mainFolder/git_stamp_launcher.dart',
          generatedGitStampLauncher,
        )
      : _saveFile(
          '$mainFolder/git_stamp_launcher.dart',
          generatedGitStampLauncherEmpty,
        );

  _saveFile('$mainFolder/git_stamp_commit.dart', generatedGitStampCommit);
  _saveFile('$mainFolder/git_stamp_page.dart', generatedGitStampPage);
  _saveFile(
      '$mainFolder/git_stamp_details_page.dart', generatedGitStampDetailsPage);

  _saveFile('$mainFolder/git_stamp.dart', generatedGitStamp);
}
