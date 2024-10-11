import 'package:meta/meta.dart';

@immutable
class GitStampBuildModel {
  final bool encrypt;
  final bool commitList;
  final bool diffList;
  final bool diffStatList;
  final bool buildBranch;
  final bool buildDateTime;
  final bool buildSystemInfo;
  final bool buildMachine;
  final bool repoCreationDate;
  final bool repoPath;
  final bool observedFilesList;
  final bool appVersion;
  final bool appBuild;
  final bool appName;
  final bool gitConfig;
  final bool gitRemote;
  final bool gitConfigList;
  final bool gitCountObjects;
  final bool gitTagList;
  final bool generateFlutterFiles;
  final bool generateFlutterIcon;

  const GitStampBuildModel({
    this.encrypt = false,
    this.commitList = false,
    this.diffList = false,
    this.diffStatList = false,
    this.buildBranch = false,
    this.buildDateTime = false,
    this.buildSystemInfo = false,
    this.buildMachine = false,
    this.repoCreationDate = false,
    this.repoPath = false,
    this.observedFilesList = false,
    this.appVersion = false,
    this.appBuild = false,
    this.appName = false,
    this.gitConfig = false,
    this.gitRemote = false,
    this.gitConfigList = false,
    this.gitCountObjects = false,
    this.gitTagList = false,
    this.generateFlutterFiles = false,
    this.generateFlutterIcon = false,
  });

  const GitStampBuildModel.all({
    this.encrypt = false,
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
    this.gitTagList = true,
    this.generateFlutterFiles = true,
    this.generateFlutterIcon = true,
  });

  const GitStampBuildModel.icon({
    this.encrypt = false,
    this.appVersion = true,
    this.appBuild = true,
    this.buildBranch = true,
    this.buildDateTime = true,
    this.commitList = true,
    this.diffList = false,
    this.diffStatList = false,
    this.buildSystemInfo = false,
    this.buildMachine = false,
    this.repoCreationDate = false,
    this.repoPath = false,
    this.observedFilesList = false,
    this.appName = false,
    this.gitConfig = false,
    this.gitRemote = false,
    this.gitConfigList = false,
    this.gitCountObjects = false,
    this.gitTagList = false,
    this.generateFlutterFiles = false,
    this.generateFlutterIcon = true,
  });

  GitStampBuildModel.custom(List<String> args)
      : encrypt = false,
        commitList = args.contains('commit-list'),
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
        gitTagList = args.contains('git-tag-list'),
        generateFlutterFiles = false,
        generateFlutterIcon = false;

  static Iterable<String> get genOnlyOptions => [
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
        'git-tag-list',
      ];

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
      gitTagList == false &&
      generateFlutterFiles == false &&
      generateFlutterIcon == true;
}
