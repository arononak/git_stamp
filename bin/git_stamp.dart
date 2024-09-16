import 'dart:io';
import 'dart:core';
import 'package:args/args.dart';

import 'git_stamp_logger.dart';
import 'src/git_stamp_build.dart';
import 'src/git_stamp_file.dart';
import 'src/files/dynamic/git_stamp_dynamic_files.dart';
import 'src/files/static/git_stamp_static_files.dart';

const gitStampVersion = 'Version 4.8.0';

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
        'diff-stat-list',
        'repo-creation-date',
        'build-branch',
        'build-date-time',
        'build-system-info',
        'build-machine',
        'repo-path',
        'observed-files-list',
        'app-version',
        'app-build',
        'app-name',
        'git-config',
        'git-remote',
        'git-config-list',
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
    final usage = parser.usage.split('\n').map((e) => '    $e').join('\n');

    if (results['help']) {
      GitStampLogger().logger.config(usage);
      return;
    } else if (results['version']) {
      GitStampLogger().logger.config(gitStampVersion);
      return;
    }

    final stopwatch = Stopwatch()..start();

    final genOnly = results['gen-only'];
    final isCustom = genOnly?.isNotEmpty ?? false;
    final buildType = isCustom ? 'custom' : results['build-type'].toLowerCase();
    final type = 'Build type: ${isCustom ? 'custom ($genOnly)' : buildType}\n';

    GitStampLogger().logger.config(gitStampVersion);
    GitStampLogger().logger.config(type);
    gitStampAscii.split('\n').forEach((line) {
      GitStampLogger().logger.fine(line);
    });

    await GitStampDirectory.recreateDirectories();

    switch (buildType) {
      case 'lite':
        _generateDataFiles(GitStampBuild.all(), true);
        _generateFlutterInterface(true);
        _generateFlutterIcon();
        _addPackageToPubspec('aron_gradient_line');
        _addPackageToPubspec('url_launcher');
        break;
      case 'full':
        _generateDataFiles(GitStampBuild.all(), false);
        _generateFlutterInterface(false);
        _generateFlutterIcon();
        _addPackageToPubspec('aron_gradient_line');
        _addPackageToPubspec('url_launcher');
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

    final gitStampSize = directorySize('./lib/git_stamp');
    final filesCount = directoryFilesCount('./lib/git_stamp');
    GitStampLogger().logger.config(
          'Size of generated $filesCount files: $gitStampSize',
        );
  } on FormatException catch (e) {
    GitStampLogger().logger.severe(e.message);
    GitStampLogger().logger.severe('Usage: dart run git_stamp [options]');
    exit(1);
  }
}

void _generateDataFiles(
  GitStampBuild files,
  bool isLiteVersion,
) {
  GitStampMain(files.generateFlutterFiles).generate();
  GitStampNode(files).generate();
  GitStampVersion().generate();

  if (files.commitList) {
    GitStampCommit().generate();
    CommitList().generate();
  }

  if (files.diffList) {
    DiffList(isLiteVersion).generate();
  }

  if (files.diffStatList) {
    DiffStatList(isLiteVersion).generate();
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

  if (files.buildMachine) {
    BuildMachine().generate();
    GitStampBuildMachine().generate();
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

  if (files.gitConfig) {
    GitConfig().generate();
  }

  if (files.gitRemote) {
    GitRemote().generate();
  }

  if (files.gitConfigList) {
    GitConfigList().generate();
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
  final formatted = package.padRight(18);
  Process.runSync('dart', ['pub', 'add', package]).exitCode == 0
      ? GitStampLogger().logger.info('Adding package  [$formatted]  Success')
      : GitStampLogger().logger.severe('Adding package  [$formatted]  Failed');
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
