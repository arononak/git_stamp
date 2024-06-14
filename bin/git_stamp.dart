// ignore_for_file: avoid_print

import 'dart:io';
import 'package:args/args.dart';

import 'src/git_stamp_directory.dart';
import 'src/files/dynamic/git_stamp_dynamic_files.dart';
import 'src/files/static/git_stamp_static_files.dart';

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
    print('Usage: dart run git_stamp [options]');
    print(parser.usage);
    exit(1);
  }
}

void _generateFiles(bool isLiteVersion, bool urlLauncher) {
  print('');
  print('Generation version: ${isLiteVersion ? 'lite' : 'full'}');
  print('Use \'url_launcher\': ${urlLauncher ? 'true' : 'false'}');
  print('');

  GitStampDirectory.recreateDirectories();

  final gitStampFiles = [
    GitStampMainFile(),
    GitStampUtils(),
    GitStampLauncher(urlLauncher),
    GitStampCommit(),
    GitStampPage(),
    GitStampDetailsPage(),
    GeneratedGitStampVersion(isLiteVersion),
    GitLog(),
    GitDiff(isLiteVersion),
    GitCreationDate(),
    GitBranch(),
    BuildDateTime(),
    BuildSystemInfo(),
    RepoPath(),
    ObservedFiles(),
  ];

  for (var element in gitStampFiles) {
    element.generate();
  }
}
