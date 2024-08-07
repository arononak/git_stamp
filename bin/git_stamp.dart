import 'dart:io';
import 'dart:core';
import 'package:args/args.dart';

import 'git_stamp_logger.dart';
import 'src/git_stamp_build.dart';
import 'src/git_stamp_directory.dart';
import 'src/files/dynamic/git_stamp_dynamic_files.dart';
import 'src/files/static/git_stamp_static_files.dart';

const gitStampVersion = 'Version 4.2.0';

/// Generated by: https://patorjk.com/
const gitStampAscii = r'''
    ┏┓•   ┏┓          ┏┓               
    ┃┓┓╋  ┗┓╋┏┓┏┳┓┏┓  ┃┓┏┓┏┓┏┓┏┓┏┓╋┏┓┏┓
    ┗┛┗┗  ┗┛┗┗┻┛┗┗┣┛  ┗┛┗ ┛┗┗ ┛ ┗┻┗┗┛┛ 
                  ┛                    
''';

Future<void> main(List<String> arguments) async {
  GitStampLogger().logger.fine('');

  final parser = ArgParser()
    ..addOption(
      'build-type',
      abbr: 'b',
      allowed: [
        'lite',
        'full',
        'icon',
        'custom',
      ],
      defaultsTo: 'lite',
    )
    ..addMultiOption(
      'gen-only',
      abbr: 'o',
      allowed: [
        'commit-list',
        'diff-list',
        'repo-creation-date',
        'build-branch',
        'build-date-time',
        'build-system-info',
        'repo-path',
        'observed-files-list',
        'app-version',
        'app-build',
        'app-name',
      ],
      defaultsTo: null,
    )
    ..addFlag(
      'version',
      abbr: 'v',
      negatable: false,
    )
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
    );

  try {
    final results = parser.parse(arguments);

    if (results['help']) {
      GitStampLogger().logger.config(parser.usage);
      return;
    } else if (results['version']) {
      GitStampLogger().logger.config(gitStampVersion);
      return;
    }

    final stopwatch = Stopwatch()..start();

    final genOnly = results['gen-only'];
    final isCustom = genOnly?.isNotEmpty ?? false;
    final buildType = isCustom ? 'custom' : results['build-type'].toLowerCase();
    final type = 'Build Type: ${isCustom ? 'custom ($genOnly)' : buildType}\n';

    GitStampLogger().logger.fine('\n$gitStampAscii\n');
    GitStampLogger().logger.config(gitStampVersion);
    GitStampLogger().logger.config(type);

    await GitStampDirectory.recreateDirectories();

    switch (buildType) {
      case 'lite':
        _addPackageToPubspec('aron_gradient_line');
        _addPackageToPubspec('url_launcher');
        _generateDataFiles(GitStampBuild.all(), true);
        _generateFlutterInterface(true);
        _generateFlutterIcon();
        break;
      case 'full':
        _addPackageToPubspec('aron_gradient_line');
        _addPackageToPubspec('url_launcher');
        _generateDataFiles(GitStampBuild.all(), false);
        _generateFlutterInterface(false);
        _generateFlutterIcon();
        break;
      case 'icon':
        _generateDataFiles(GitStampBuild.tooltip(), true);
        _generateFlutterIcon();
        break;
      case 'custom':
        _generateDataFiles(GitStampBuild.custom(genOnly ?? []), false);
        break;
      default:
    }

    stopwatch.stop();
    final seconds = stopwatch.elapsed.format();

    GitStampLogger().logger.config('Generation time: ${seconds}s');

  } on FormatException catch (e) {
    GitStampLogger().logger.severe(e.message);
    GitStampLogger().logger.severe('Usage: dart run git_stamp [options]');
    GitStampLogger().logger.severe(parser.usage);
    exit(1);
  }
}

void _generateDataFiles(
  GitStampBuild files,
  bool isLiteVersion,
) {
  GitStampMainFile(files.generateFlutterFiles).generate();
  GitStampNode(files).generate();
  GitStampVersion().generate();

  if (files.commitList) {
    GitStampCommit().generate();
    CommitList().generate();
  }

  if (files.diffList) {
    DiffList(isLiteVersion).generate();
  }

  if (files.repoCreationDate) {
    RepoCreationDate().generate();
  }

  if (files.buildBranch) {
    BuildBranch().generate();
  }

  if (files.buildDateTime) {
    BuildDateTime().generate();
  }

  if (files.buildSystemInfo) {
    BuildSystemInfo().generate();
  }

  if (files.repoPath) {
    RepoPath().generate();
  }

  if (files.observedFilesList) {
    ObservedFilesList().generate();
  }

  if (files.appVersion) {
    AppVersion().generate();
  }

  if (files.appBuild) {
    AppBuild().generate();
  }

  if (files.appName) {
    AppName().generate();
  }
}

void _generateFlutterInterface(bool isLiteVersion) {
  final gitStampUi = [
    IsLiteVersion(isLiteVersion),
    GitStampPage(),
    GitStampDetailsPage(),
    GitStampUtils(),
    GitStampLauncher(),
    GitStampLicensePage(),
  ];

  for (var element in gitStampUi) {
    element.generate();
  }
}

void _generateFlutterIcon() {
  GitStampIcon().generate();
}

void _addPackageToPubspec(String package) {
  Process.runSync('dart', ['pub', 'add', package]).exitCode == 0
      ? GitStampLogger().logger.info('Adding package: [$package]: Success')
      : GitStampLogger().logger.severe('Adding package: [$package]: Failed');
}

extension DurationExtension on Duration {
  String format() {
    if (inHours > 0) {
      return toString();
    }

    if (inMinutes > 10) {
      return inMinutes.toString();
    }

    return (inMilliseconds / 1000).toStringAsFixed(2);
  }
}