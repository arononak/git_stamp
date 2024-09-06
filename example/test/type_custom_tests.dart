import 'dart:io';

import 'package:example/git_stamp/git_stamp_node.dart';
import 'package:example/git_stamp/git_stamp_tool_version.dart';
import 'package:test/test.dart';

void main() {
  singleValueTests();
}

void runGenOnlyCommand(param, field, matcher) {
  final result = Process.runSync(
    'dart',
    ['run', 'git_stamp', '--gen-only', param],
  );

  expect(result.exitCode, 0);
  expect(result.stderr, isEmpty);
  expect(field, matcher);
}

void singleValueTests() {
  [
    {
      'param': 'commit-list',
      'field': GitStamp.commitList.isNotEmpty,
      'matcher': isTrue,
    },
    {
      'param': 'commit-list',
      'field': GitStamp.latestCommit?.authorName.isNotEmpty,
      'matcher': isTrue,
    },
    {
      'param': 'commit-list',
      'field': GitStamp.sha.isNotEmpty,
      'matcher': isTrue,
    },
    {
      'param': 'diff-list',
      'field': GitStamp.diffList.isNotEmpty,
      'matcher': isTrue,
    },
    {
      'param': 'diff-stat-list',
      'field': GitStamp.diffStatList.isNotEmpty,
      'matcher': isTrue,
    },
    {
      'param': 'build-branch',
      'field': GitStamp.buildBranch,
      'matcher': isNotEmpty,
    },
    {
      'param': 'build-date-time',
      'field': GitStamp.buildDateTime,
      'matcher': isNotEmpty,
    },
    {
      'param': 'build-system-info',
      'field': GitStamp.buildSystemInfo,
      'matcher': isNotEmpty,
    },
    {
      'param': 'repo-creation-date',
      'field': GitStamp.repoCreationDate,
      'matcher': isNotEmpty,
    },
    {
      'param': 'repo-path',
      'field': GitStamp.repoPath,
      'matcher': isNotEmpty,
    },
    {
      'param': 'observed-files-list',
      'field': GitStamp.observedFilesList,
      'matcher': isNotEmpty,
    },
    {
      'param': 'app-version',
      'field': GitStamp.appVersion,
      'matcher': isNotEmpty,
    },
    {
      'param': 'app-build',
      'field': GitStamp.appBuild,
      'matcher': isNotEmpty,
    },
    {
      'param': 'app-name',
      'field': GitStamp.appName,
      'matcher': isNotEmpty,
    },
    {
      /* app-name only for run generate command */
      'param': 'app-name',
      'field': gitStampToolVersion,
      'matcher': isNotEmpty,
    },
    {
      'param': 'git-config',
      'field': GitStamp.gitConfigGlobalUserName,
      'matcher': isNotEmpty,
    },
    {
      'param': 'git-config',
      'field': GitStamp.gitConfigGlobalUserEmail,
      'matcher': isNotEmpty,
    },
    {
      'param': 'git-config',
      'field': GitStamp.gitConfigUserName,
      'matcher': isNotEmpty,
    },
    {
      'param': 'git-config',
      'field': GitStamp.gitConfigUserEmail,
      'matcher': isNotEmpty,
    },
    {
      'param': 'git-remote',
      'field': GitStamp.gitRemote,
      'matcher': isNotEmpty,
    },
    /* Build Machine */
    {
      'param': 'build-machine',
      'field': GitStamp.buildMachine.channel,
      'matcher': isNotEmpty,
    },
    {
      'param': 'build-machine',
      'field': GitStamp.buildMachine.dartSdkVersion,
      'matcher': isNotEmpty,
    },
    {
      'param': 'build-machine',
      'field': GitStamp.buildMachine.devToolsVersion,
      'matcher': isNotEmpty,
    },
    {
      'param': 'build-machine',
      'field': GitStamp.buildMachine.engineRevision,
      'matcher': isNotEmpty,
    },
    {
      'param': 'build-machine',
      'field': GitStamp.buildMachine.flutterRoot,
      'matcher': isNotEmpty,
    },
    {
      'param': 'build-machine',
      'field': GitStamp.buildMachine.flutterVersion,
      'matcher': isNotEmpty,
    },
    {
      'param': 'build-machine',
      'field': GitStamp.buildMachine.frameworkCommitDate,
      'matcher': isNotEmpty,
    },
    {
      'param': 'build-machine',
      'field': GitStamp.buildMachine.frameworkRevision,
      'matcher': isNotEmpty,
    },
    {
      'param': 'build-machine',
      'field': GitStamp.buildMachine.frameworkVersion,
      'matcher': isNotEmpty,
    },
    {
      'param': 'build-machine',
      'field': GitStamp.buildMachine.repositoryUrl,
      'matcher': isNotEmpty,
    },
  ].forEach(
    (json) {
      test('GitStamp ${json['param']} should be not empty', () {
        runGenOnlyCommand(json['param'], json['field'], json['matcher']);
      });
    },
  );
}
