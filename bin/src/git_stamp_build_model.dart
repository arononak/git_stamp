// Copyright © 2024 Aron Onak. All rights reserved.
// Licensed under the MIT license.
// If you have any feedback, please contact me at arononak@gmail.com

import 'package:meta/meta.dart';

@immutable
class GitStampBuildModel {
  final String toolBuildType;
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
  final bool gitBranchList;
  final bool gitReflog;
  final bool generateFlutterFiles;
  final bool generateFlutterIcon;
  final bool packages;
  final bool deps;

  const GitStampBuildModel({
    this.toolBuildType = '',
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
    this.gitBranchList = false,
    this.gitReflog = false,
    this.generateFlutterFiles = false,
    this.generateFlutterIcon = false,
    this.packages = false,
    this.deps = false,
  });

  const GitStampBuildModel.all({
    this.toolBuildType = '',
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
    this.gitBranchList = true,
    this.gitReflog = true,
    this.generateFlutterFiles = true,
    this.generateFlutterIcon = true,
    this.packages = true,
    this.deps = true,
  });

  const GitStampBuildModel.icon({
    this.toolBuildType = 'ICON',
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
    this.gitBranchList = false,
    this.gitReflog = false,
    this.generateFlutterFiles = false,
    this.generateFlutterIcon = true,
    this.packages = false,
    this.deps = false,
  });

  GitStampBuildModel.custom(List<String> args)
      : toolBuildType = 'CUSTOM',
        encrypt = false,
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
        gitBranchList = args.contains('git-branch-list'),
        gitReflog = args.contains('git-reflog'),
        packages = args.contains('packages'),
        deps = args.contains('deps'),
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
        'git-branch-list',
        'git-reflog',
        'packages',
        'deps',
      ];

  bool get isIcon => toolBuildType == 'ICON';
  bool get isLiteVersion => toolBuildType == 'LITE';
}
