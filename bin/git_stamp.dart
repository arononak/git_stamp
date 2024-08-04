// ignore_for_file: avoid_print

import 'dart:io';
import 'package:args/args.dart';

import 'src/git_stamp_build.dart';
import 'src/git_stamp_directory.dart';
import 'src/files/dynamic/git_stamp_dynamic_files.dart';
import 'src/files/static/git_stamp_static_files.dart';

Future<void> main(List<String> arguments) async {
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

    /// Generated by: https://patorjk.com/
    const gitStampAscii = r'''
    ┏┓•   ┏┓          ┏┓               
    ┃┓┓╋  ┗┓╋┏┓┏┳┓┏┓  ┃┓┏┓┏┓┏┓┏┓┏┓╋┏┓┏┓
    ┗┛┗┗  ┗┛┗┗┻┛┗┗┣┛  ┗┛┗ ┛┗┗ ┛ ┗┻┗┗┛┛ 
                  ┛                    
    ''';

    final List<String>? genOnly = results['gen-only'];
    final isCustom = genOnly?.isNotEmpty ?? false;
    final String buildType =
        isCustom ? 'custom' : results['build-type'].toLowerCase();

    print('');
    print(gitStampAscii);
    print('Build Type: ${isCustom ? 'custom ($genOnly)' : buildType}');
    print('');

    await GitStampDirectory.recreateDirectories();

    switch (buildType) {
      case 'lite':
        _addPackageToPubspec('aron_gradient_line');
        _addPackageToPubspec('url_launcher');
        _generateDataFiles(GitStampBuild.all());
        _generateFlutterInterface();
        _generateFlutterIcon();
        return;
      case 'full':
        _addPackageToPubspec('aron_gradient_line');
        _addPackageToPubspec('url_launcher');
        _generateDataFiles(GitStampBuild.all(), isLiteVersion: false);
        _generateFlutterInterface(isLiteVersion: false);
        _generateFlutterIcon();
        return;
      case 'icon':
        _generateDataFiles(GitStampBuild.tooltip());
        _generateFlutterIcon();
        return;
      case 'custom':
        _generateDataFiles(GitStampBuild.custom(genOnly ?? []));
        return;
      default:
    }
  } on FormatException catch (e) {
    print(e.message);
    print('Usage: dart run git_stamp [options]');
    print(parser.usage);
    exit(1);
  }
}

void _generateDataFiles(
  GitStampBuild files, {
  bool isLiteVersion = true,
}) {
  GitStampMainFile(files.generateFlutterFiles).generate();
  GitStampNode(files).generate();

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

void _generateFlutterInterface({bool isLiteVersion = true}) {
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

void _addPackageToPubspec(String packageName) {
  final result = Process.runSync('dart', ['pub', 'add', packageName]);
  final success = result.exitCode == 0;
  print('Adding package: [$packageName]: ${success ? 'Success' : 'Failed'}');
}
