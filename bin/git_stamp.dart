import 'dart:io';
import 'dart:core';
import 'package:args/args.dart';

import 'git_stamp_build_model.dart';
import 'git_stamp_logger.dart';
import 'git_stamp_encrypt.dart';
import 'git_stamp_files.dart';
import 'git_stamp_version.dart';
import 'files/dynamic/git_stamp_dynamic_files.dart';
import 'files/static/git_stamp_static_files.dart';

final parser = ArgParser()
  ..addFlag('help', abbr: 'h', negatable: false)
  ..addFlag('version', abbr: 'v', negatable: false)
  ..addFlag('encrypt', abbr: 'e', negatable: false)
  ..addFlag('gen-only-options', negatable: false)
  ..addFlag('gen-only-all', negatable: false)
  ..addFlag('debug-compile-key', negatable: false)
  ..addOption(
    'build-type',
    abbr: 'b',
    allowed: ['lite', 'full', 'icon', 'custom'],
    defaultsTo: 'lite',
  )
  ..addOption(
    'adding-packages',
    abbr: 'a',
    allowed: ['enabled', 'disabled'],
    defaultsTo: 'enabled',
  )
  ..addMultiOption(
    'gen-only',
    abbr: 'o',
    allowed: GitStampBuildModel.genOnlyOptions,
    defaultsTo: null,
  );

Future<void> main(List<String> arguments) async {
  try {
    final results = parser.parse(arguments);
    final usage = parser.usage.split('\n').map((e) => '    $e').join('\n');

    if (results['help']) {
      GitStampLogger.lightGrey(usage);
      return;
    } else if (results['version']) {
      GitStampLogger.lightGrey(gitStampVersion);
      return;
    } else if (results['gen-only-options']) {
      GitStampLogger.lightGrey(GitStampBuildModel.genOnlyOptions.toString());
      return;
    } else if (results['gen-only-all']) {
      _generate(
        encryptEnabled: false,
        buildType: 'custom',
        genOnly: GitStampBuildModel.genOnlyOptions.toList(),
      );
      return;
    }

    final encryptEnabled = results['encrypt'];
    final genOnly = results['gen-only'];
    final addingPackageEnabled = results['adding-packages'] == 'enabled';

    final isCustom = genOnly?.isNotEmpty ?? false;
    final buildType = isCustom ? 'custom' : results['build-type'].toLowerCase();

    _generate(
      encryptEnabled: encryptEnabled,
      buildType: buildType,
      addingPackageEnabled: addingPackageEnabled,
    );
  } on FormatException catch (e) {
    GitStampLogger.red(e.message);
    GitStampLogger.red('Usage: dart run git_stamp [options]');
    exit(1);
  }
}

Future<void> _generate({
  required String buildType,
  required bool encryptEnabled,
  bool addingPackageEnabled = false,
  List<String>? genOnly,
}) async {
  GitStampLogger.lightGreen(gitStampVersion);
  GitStampLogger.lightGreen(
      'Build type: ${buildType == 'custom' ? 'custom ($genOnly)' : buildType}');
  GitStampLogger.lightGreen('Adding packages: $addingPackageEnabled');
  GitStampLogger.lightGreen('');
  GitStampLogger.logo();

  final stopwatch = Stopwatch()..start();

  await GitStampDirectory.recreateDirectories();

  switch (buildType) {
    case 'lite':
      _generateDataFiles(GitStampBuildModel.all(encrypt: encryptEnabled), true);
      _generateFlutterInterface(true, encryptEnabled);
      _generateFlutterIcon();

      if (addingPackageEnabled) {
        _addPackageToPubspec('aron_gradient_line');
        _addPackageToPubspec('url_launcher');
        if (encryptEnabled) {
          _addPackageToPubspec('encrypt');
        }
      }

      break;
    case 'full':
      _generateDataFiles(
          GitStampBuildModel.all(encrypt: encryptEnabled), false);
      _generateFlutterInterface(false, encryptEnabled);
      _generateFlutterIcon();

      if (addingPackageEnabled) {
        _addPackageToPubspec('aron_gradient_line');
        _addPackageToPubspec('url_launcher');
        if (encryptEnabled) {
          _addPackageToPubspec('encrypt');
        }
      }

      break;
    case 'icon':
      _generateDataFiles(const GitStampBuildModel.icon(), true);
      _generateFlutterIcon();
      break;
    case 'custom':
      _generateDataFiles(GitStampBuildModel.custom(genOnly ?? []), false);
      break;
    default:
  }

  stopwatch.stop();

  final seconds = stopwatch.elapsed.format();
  GitStampLogger.lightGreen('Generation time: ${seconds}s');

  final filesSize = directorySize('./lib/git_stamp');
  final filesCount = directoryFilesCount('./lib/git_stamp');
  GitStampLogger.lightGreen('Size of generated $filesCount files: $filesSize');
}

void _generateDataFiles(
  GitStampBuildModel model,
  bool isLiteVersion,
) {
  EncryptFunction? encrypt;

  if (model.encrypt) {
    final key = GitStampEncrypt.generateKey();
    final iv = GitStampEncrypt.generateIv();

    GitStampEncrypt.printKeyAndIv(key, iv);

    encrypt = model.encrypt == false
        ? null
        : (data) => GitStampEncrypt.encrypt(data, key, iv);
  }

  const decryptedTestText =
      'Aron Aron uber alles, a napewno ponad mojego wspaniałego i cudownego Łukaszka i jego przyjaciela cwaniaka misiora z żółtymi zębami jak koń. Po wyroku sądu dopisze tu jego przeklęte nazwisko xd';
  final encryptedTestText =
      model.encrypt ? encrypt?.call(decryptedTestText) : null;

  GitStampMain(model).generate();
  GitStampNode(model, decryptedTestText, encryptedTestText).generate();
  GitStampVersion().generate();

  if (model.commitList) {
    GitStampCommit().generate();
    CommitList(encrypt, count: model.isIcon ? 1 : null).generate();
  }

  if (model.diffList) {
    DiffList(encrypt, isLiteVersion).generate();
  }

  if (model.diffStatList) {
    DiffStatList(encrypt, isLiteVersion).generate();
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
    GitStampBuildMachine().generate();
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
}

void _generateFlutterInterface(bool isLiteVersion, bool encryptEnabled) {
  final gitStampUi = [
    IsLiteVersion(isLiteVersion),
    GitStampPage(),
    GitStampDetailsPage(),
    GitStampUtils(),
    GitStampLauncher(),
    GitStampLicensePage(),
    GitStampListTile(),
    GitStampDecryptBottomSheet(!encryptEnabled),
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
      ? GitStampLogger.lightGrey('Adding package  [$formatted]  Success')
      : GitStampLogger.red('Adding package  [$formatted]  Failed');
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
