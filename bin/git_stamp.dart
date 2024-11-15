// Copyright © 2024 Aron Onak. All rights reserved.
// Licensed under the MIT license.
// If you have any feedback, please contact me at arononak@gmail.com

import 'dart:convert';
import 'dart:io';
import 'dart:core';

import 'package:args/args.dart';

import 'git_stamp_build_model.dart';
import 'git_stamp_logger.dart';
import 'git_stamp_encrypt.dart';
import 'git_stamp_file_utils.dart';
import 'git_stamp_version.dart';

import 'files/git_stamp_files.dart';

final _parser = ArgParser()
  ..addFlag(
    'help',
    abbr: 'h',
    negatable: false,
  )
  ..addFlag(
    'version',
    abbr: 'v',
    negatable: false,
  )
  ..addFlag(
    'encrypt',
    abbr: 'e',
    negatable: false,
    help:
        'Encrypts data using AES which can be decrypted in runtime. Only LITE & FULL build-type.',
  )
  ..addFlag(
    'gen-only-options',
    negatable: false,
    help: 'Displays possible parameters of custom build-type',
  )
  ..addFlag(
    'gen-only-all',
    negatable: false,
    help: 'Runs custom build-type with all parameters.',
  )
  ..addFlag(
    'debug-compile-key',
    negatable: false,
    help:
        'Adds key to compiled version to avoid manual entry upon startup for encrypted version. Not recommended for production.',
  )
  ..addFlag(
    'benchmark',
    negatable: false,
    help:
        'Runs benchmarks of ICON, LITE and FULL types and saves the result to benchmark.json file.',
  )
  ..addOption(
    'build-type',
    abbr: 'b',
    allowed: ['full', 'lite', 'icon', 'custom'],
    help: 'https://github.com/arononak/git_stamp/blob/main/BENCHMARK.md',
    allowedHelp: {
      'full': 'Full version with commit list screen with commit diff.',
      'lite':
          'Default version with commit list screen, but without commit diff.',
      'icon': 'Only icon with tip.',
      'custom': 'Unused. Use --gen-only build-branch,app-name',
    },
    defaultsTo: 'lite',
  )
  ..addOption(
    'adding-packages',
    abbr: 'a',
    allowed: ['enabled', 'disabled'],
    defaultsTo: 'enabled',
    help:
        'Whether to add the project to pubspec.yaml to add the encrypt package while generating.',
  )
  ..addMultiOption(
    'gen-only',
    abbr: 'o',
    allowed: GitStampBuildModel.genOnlyOptions,
    defaultsTo: null,
    help: 'Parameter with data selection for custom build-type.',
  )
  ..addOption(
    'limit',
    abbr: 'l',
    help: 'Limits the number of commits in history.',
    defaultsTo: null,
  );

class _GenerationResult {
  String generationTimeSeconds;
  String filesSize;
  int filesCount;

  _GenerationResult({
    required this.generationTimeSeconds,
    required this.filesSize,
    required this.filesCount,
  });

  void print() {
    GitStampLogger.lightGreen('Generation time: ${generationTimeSeconds}s');
    GitStampLogger.lightGreen(
        'Size of generated $filesCount files: $filesSize');
  }

  Map<String, dynamic> get asMap => {
        'generationTimeSeconds': generationTimeSeconds,
        'filesSize': filesSize,
        'filesCount': filesCount,
      };

  static String benchmark(full, lite, icon, commitCount) => jsonEncode({
        'full': full.asMap,
        'lite': lite.asMap,
        'icon': icon.asMap,
        'commitCount': commitCount,
      });
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

Future<void> main(List<String> arguments) async {
  try {
    final results = _parser.parse(arguments);

    if (results['help']) {
      final usage = _parser.usage.split('\n').map((e) => '    $e').join('\n');
      GitStampLogger.lightGrey(usage);
      return;
    } else if (results['version']) {
      GitStampLogger.lightGrey(gitStampVersion);
      return;
    } else if (results['gen-only-options']) {
      GitStampLogger.lightGrey(GitStampBuildModel.genOnlyOptions.toString());
      return;
    } else if (results['benchmark']) {
      GitStampFile.loggingEnabled = false;
      final full = await _generate(buildType: 'full', encryptEnabled: false);
      final lite = await _generate(buildType: 'lite', encryptEnabled: false);
      final icon = await _generate(buildType: 'icon', encryptEnabled: false);
      final commitCount = exec(['git', 'rev-list', '--count', 'HEAD']);
      final json = _GenerationResult.benchmark(full, lite, icon, commitCount);
      File('./benchmark.json').writeAsStringSync(json);
      GitStampLogger.lightGreen('File `benchmark.json` was saved!');
      return;
    } else if (results['gen-only-all']) {
      final result = await _generate(
        buildType: 'custom',
        encryptEnabled: false,
        genOnly: GitStampBuildModel.genOnlyOptions.toList(),
      );
      result.print();
      return;
    }

    final encryptEnabled = results['encrypt'];
    final debugCompileKey = results['debug-compile-key'];
    final genOnly = results['gen-only'];
    final addingPackageEnabled = results['adding-packages'] == 'enabled';
    final isCustom = genOnly?.isNotEmpty ?? false;
    final buildType = isCustom ? 'custom' : results['build-type'].toLowerCase();
    final limit = results['limit'] == null ? null : int.parse(results['limit']);

    final result = await _generate(
      buildType: buildType,
      encryptEnabled: encryptEnabled,
      debugCompileKey: debugCompileKey,
      addingPackageEnabled: addingPackageEnabled,
      limit: limit,
    );
    result.print();
  } on FormatException catch (e) {
    GitStampLogger.red(e.message);
    GitStampLogger.red('Usage: dart run git_stamp [options]');
    exit(1);
  }
}

Future<_GenerationResult> _generate({
  required String buildType,
  required bool encryptEnabled,
  bool debugCompileKey = false,
  bool addingPackageEnabled = false,
  int? limit,
  List<String>? genOnly,
}) async {
  if (GitStampFile.loggingEnabled) {
    GitStampLogger.lightGreen(gitStampVersion);
    GitStampLogger.lightGreen(
      'Build type: ${buildType == 'custom' ? 'custom ($genOnly)' : buildType}',
    );
    GitStampLogger.lightGreen('Adding packages: $addingPackageEnabled');
    GitStampLogger.lightGreen('');
    GitStampLogger.logo();
  }

  final stopwatch = Stopwatch()..start();

  await GitStampDirectory.recreateDirectories();

  switch (buildType) {
    case 'full':
      _generateDataFiles(
        model: GitStampBuildModel.all(
          toolBuildType: 'FULL',
          encrypt: encryptEnabled,
        ),
        debugCompileKey: debugCompileKey,
        limit: limit,
      );

      if (addingPackageEnabled && encryptEnabled) {
        _addPackageToPubspec('encrypt');
      }

      break;
    case 'lite':
      _generateDataFiles(
        model: GitStampBuildModel.all(
          toolBuildType: 'LITE',
          encrypt: encryptEnabled,
        ),
        debugCompileKey: debugCompileKey,
        limit: limit,
      );

      if (addingPackageEnabled && encryptEnabled) {
        _addPackageToPubspec('encrypt');
      }

      break;
    case 'icon':
      _generateDataFiles(
        model: const GitStampBuildModel.icon(),
        limit: 1,
      );
      break;
    case 'custom':
      _generateDataFiles(
        model: GitStampBuildModel.custom(genOnly ?? []),
        limit: limit,
      );
      break;
    default:
  }

  stopwatch.stop();

  final seconds = stopwatch.elapsed.format();
  final filesSize = directorySize('./lib/git_stamp');
  final filesCount = directoryFilesCount('./lib/git_stamp');

  return _GenerationResult(
    generationTimeSeconds: seconds,
    filesSize: filesSize,
    filesCount: filesCount,
  );
}

void _generateDataFiles({
  required GitStampBuildModel model,
  int? limit,
  bool debugCompileKey = false,
}) {
  EncryptFunction? encrypt;

  if (model.encrypt) {
    final key = GitStampEncrypt.generateKey();
    final iv = GitStampEncrypt.generateIv();

    GitStampEncrypt.printKeyAndIv(key, iv);

    EncryptDebugKey(
      debugCompileKey == false ? null : key.bytes.asHex.join(''),
      debugCompileKey == false ? null : iv.bytes.asHex.join(''),
    ).generate();

    encrypt = model.encrypt == false
        ? null
        : (data) => GitStampEncrypt.encrypt(data, key, iv);
  }

  const decryptedTestText =
      'Aron Aron uber alles, a napewno ponad mojego wspaniałego i cudownego Łukaszka i jego przyjaciela cwaniaka misiora z żółtymi zębami jak koń. Po wyroku sądu dopisze tu jego przeklęte nazwisko xd';
  final encryptedTestText =
      model.encrypt ? encrypt?.call(decryptedTestText) : null;

  GitStampMain(model, decryptedTestText, encryptedTestText).generate();
  ToolVersion().generate();
  ToolBuildType(model.toolBuildType).generate();

  if (model.commitList) {
    CommitList(encrypt, count: limit).generate();
  }

  if (model.diffList) {
    DiffList(encrypt, count: limit, model.isLiteVersion).generate();
  }

  if (model.diffStatList) {
    DiffStatList(encrypt, count: limit, model.isLiteVersion).generate();
  }

  if (model.repoCreationDate) {
    RepoCreationDate(encrypt).generate();
  }

  if (model.buildBranch) {
    BuildBranch(encrypt).generate();
  }

  if (model.buildDateTime) {
    BuildDateTime(encrypt).generate();
  }

  if (model.buildSystemInfo) {
    BuildSystemInfo(encrypt).generate();
  }

  if (model.buildMachine) {
    BuildMachine(encrypt).generate();
  }

  if (model.repoPath) {
    RepoPath(encrypt).generate();
  }

  if (model.observedFilesList) {
    ObservedFilesList(encrypt).generate();
  }

  if (model.appVersion) {
    AppVersion(encrypt).generate();
  }

  if (model.appBuild) {
    AppBuild(encrypt).generate();
  }

  if (model.appName) {
    AppName(encrypt).generate();
  }

  if (model.gitConfig) {
    GitConfigUserName(encrypt).generate();
    GitConfigUserEmail(encrypt).generate();
    GitConfigGlobalUserName(encrypt).generate();
    GitConfigGlobalUserEmail(encrypt).generate();
  }

  if (model.gitRemote) {
    GitRemote(encrypt).generate();
  }

  if (model.gitConfigList) {
    GitConfigList(encrypt).generate();
  }

  if (model.gitCountObjects) {
    GitCountObjects(encrypt).generate();
  }

  if (model.gitTagList) {
    GitTagList(encrypt).generate();
  }

  if (model.gitBranchList) {
    GitBranchList(encrypt).generate();
  }

  if (model.gitReflog) {
    GitReflog(encrypt).generate();
  }

  if (model.packages) {
    Packages(encrypt).generate();
  }
}

void _addPackageToPubspec(String package) {
  final formatted = package.padRight(18);
  Process.runSync('dart', ['pub', 'add', package]).exitCode == 0
      ? GitStampLogger.lightGrey('Adding package  [$formatted]  Success')
      : GitStampLogger.red('Adding package  [$formatted]  Failed');
}
