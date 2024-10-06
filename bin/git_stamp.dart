import 'dart:io';
import 'dart:core';
import 'package:args/args.dart';

import 'git_stamp_logger.dart';
import 'git_stamp_encrypt.dart';
import 'src/git_stamp_file.dart';
import 'src/files/dynamic/git_stamp_dynamic_files.dart';
import 'src/files/static/git_stamp_static_files.dart';

const gitStampVersion = 'Version 5.0.0';

/// Generated by: https://patorjk.com/
const gitStampAscii = r'''
 ┏┓•   ┏┓          ┏┓               
 ┃┓┓╋  ┗┓╋┏┓┏┳┓┏┓  ┃┓┏┓┏┓┏┓┏┓┏┓╋┏┓┏┓
 ┗┛┗┗  ┗┛┗┗┻┛┗┗┣┛  ┗┛┗ ┛┗┗ ┛ ┗┻┗┗┛┛ 
               ┛                    
''';

class GitStampBuildModel {
  bool encrypt = false;
  bool commitList = false;
  bool diffList = false;
  bool diffStatList = false;
  bool buildBranch = false;
  bool buildDateTime = false;
  bool buildSystemInfo = false;
  bool buildMachine = false;
  bool repoCreationDate = false;
  bool repoPath = false;
  bool observedFilesList = false;
  bool appVersion = false;
  bool appBuild = false;
  bool appName = false;
  bool gitConfig = false;
  bool gitRemote = false;
  bool gitConfigList = false;
  bool gitCountObjects = false;
  bool generateFlutterFiles = false;
  bool generateFlutterIcon = false;

  GitStampBuildModel.all({
    this.commitList = true,
    this.diffList = true,
    this.diffStatList = true,
    this.buildBranch = true,
    this.buildDateTime = true,
    this.buildSystemInfo = true,
    this.buildMachine = true,
    this.repoCreationDate = true,
    this.repoPath = true,
    this.observedFilesList = true,
    this.appVersion = true,
    this.appBuild = true,
    this.appName = true,
    this.gitConfig = true,
    this.gitRemote = true,
    this.gitConfigList = true,
    this.gitCountObjects = true,
    this.generateFlutterFiles = true,
    this.generateFlutterIcon = true,
  });

  GitStampBuildModel.icon({
    this.appVersion = true,
    this.appBuild = true,
    this.buildBranch = true,
    this.buildDateTime = true,
    this.commitList = true,
    this.generateFlutterIcon = true,
  });

  GitStampBuildModel.custom(List<String> args)
      : commitList = args.contains('commit-list'),
        diffList = args.contains('diff-list'),
        diffStatList = args.contains('diff-stat-list'),
        buildBranch = args.contains('build-branch'),
        buildDateTime = args.contains('build-date-time'),
        buildSystemInfo = args.contains('build-system-info'),
        buildMachine = args.contains('build-machine'),
        repoCreationDate = args.contains('repo-creation-date'),
        repoPath = args.contains('repo-path'),
        observedFilesList = args.contains('observed-files-list'),
        appVersion = args.contains('app-version'),
        appBuild = args.contains('app-build'),
        appName = args.contains('app-name'),
        gitConfig = args.contains('git-config'),
        gitRemote = args.contains('git-remote'),
        gitConfigList = args.contains('git-config-list'),
        gitCountObjects = args.contains('git-count-objects'),
        generateFlutterFiles = false,
        generateFlutterIcon = false;

  bool get isIcon =>
      commitList == true &&
      diffList == false &&
      diffStatList == false &&
      buildBranch == true &&
      buildDateTime == true &&
      buildSystemInfo == false &&
      buildMachine == false &&
      repoCreationDate == false &&
      repoPath == false &&
      observedFilesList == false &&
      appVersion == true &&
      appBuild == true &&
      appName == false &&
      gitConfig == false &&
      gitRemote == false &&
      gitConfigList == false &&
      gitCountObjects == false &&
      generateFlutterFiles == false &&
      generateFlutterIcon == true;
}

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false)
    ..addFlag('version', abbr: 'v', negatable: false)
    ..addFlag('encrypt', abbr: 'e', negatable: false)
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
        'git-count-objects',
      ],
      defaultsTo: null,
    );

  try {
    final results = parser.parse(arguments);
    final usage = parser.usage.split('\n').map((e) => '    $e').join('\n');

    if (results['help']) {
      GitStampLogger.lightGrey(usage);
      return;
    } else if (results['version']) {
      GitStampLogger.lightGrey(gitStampVersion);
      return;
    }

    final stopwatch = Stopwatch()..start();

    final encryptEnabled = results['encrypt'];
    final genOnly = results['gen-only'];
    final isCustom = genOnly?.isNotEmpty ?? false;
    final buildType = isCustom ? 'custom' : results['build-type'].toLowerCase();
    final type = 'Build type: ${isCustom ? 'custom ($genOnly)' : buildType}\n';

    GitStampLogger.lightGreen(gitStampVersion);
    GitStampLogger.lightGreen(type);
    gitStampAscii.split('\n').forEach((line) {
      GitStampLogger.lightYellow(line);
    });

    await GitStampDirectory.recreateDirectories();

    switch (buildType) {
      case 'lite':
        _generateDataFiles(
            GitStampBuildModel.all()..encrypt = encryptEnabled, true);
        _generateFlutterInterface(true, encryptEnabled);
        _generateFlutterIcon();

        _addPackageToPubspec('aron_gradient_line');
        _addPackageToPubspec('url_launcher');
        if (encryptEnabled) _addPackageToPubspec('encrypt');

        break;
      case 'full':
        _generateDataFiles(
            GitStampBuildModel.all()..encrypt = encryptEnabled, false);
        _generateFlutterInterface(false, encryptEnabled);
        _generateFlutterIcon();

        _addPackageToPubspec('aron_gradient_line');
        _addPackageToPubspec('url_launcher');
        if (encryptEnabled) _addPackageToPubspec('encrypt');

        break;
      case 'icon':
        _generateDataFiles(GitStampBuildModel.icon(), true);
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

    final gitStampSize = directorySize('./lib/git_stamp');
    final filesCount = directoryFilesCount('./lib/git_stamp');
    GitStampLogger.lightGreen(
      'Size of generated $filesCount files: $gitStampSize',
    );
  } on FormatException catch (e) {
    GitStampLogger.red(e.message);
    GitStampLogger.red('Usage: dart run git_stamp [options]');
    exit(1);
  }
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
