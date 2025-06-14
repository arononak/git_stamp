// Copyright © 2024 Aron Onak. All rights reserved.
// Licensed under the MIT license.
// If you have any feedback, please contact me at arononak@gmail.com

import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:pub_semver/pub_semver.dart';

import 'raw_git_stamp.dart';
import 'git_stamp_file_utils.dart';
import 'git_stamp_build_model.dart';

/// Generated by ChatGPT
String _removeTokens(String input) {
  return input
      .split('\n')
      .map((line) {
        int authIndex = line.indexOf('AUTHORIZATION:');
        if (authIndex != -1) {
          int startIndex = authIndex + 'AUTHORIZATION:'.length;
          String prefix = line.substring(0, startIndex);
          String content = line.substring(startIndex).trim();
          String replaced = content
              .split('')
              .map((char) => char.trim().isEmpty ? char : '*')
              .join();
          return '$prefix $replaced';
        }
        return line;
      })
      .join('\n');
}

String exec(List<String> args) {
  return Process.runSync(
    args.first,
    args.sublist(1),
    runInShell: true,
  ).stdout.toString().trimRight();
}

extension StringExtension on String {
  String valueOr(String empty) => isNotEmpty ? this : empty;
}

class GitStampMain extends GitStampMainFile {
  final GitStampBuildModel model;
  final String decryptedTestText;
  final dynamic encryptedTestText;

  GitStampMain(this.model, this.decryptedTestText, this.encryptedTestText);

  @override
  String get filename => 'git_stamp.dart';

  @override
  String get content =>
      rawGitStampNode(model, decryptedTestText, encryptedTestText);
}

class EncryptDebugKey extends GitStampMainFile {
  final String? key;
  final String? iv;

  EncryptDebugKey(this.key, this.iv);

  @override
  String get filename => 'git_stamp_encrypt_debug_key.dart';

  @override
  String get content =>
      '''
    class GitStampEncryptDebugKey {
      static String? key = ${key == null ? 'null' : "'$key'"};
      static String? iv = ${iv == null ? 'null' : "'$iv'"};
    }
  ''';
}

class ToolBuildType extends GitStampDataFile {
  final String type;

  ToolBuildType(this.type);

  @override
  String get filename => 'tool_build_type.dart';

  @override
  String get variableName => 'gitStampToolBuildType';

  @override
  String get variableContent => type;
}

class ToolVersion extends GitStampDataFile {
  @override
  String get filename => 'tool_version.dart';

  @override
  String get variableName => 'gitStampToolVersion';

  @override
  String get variableContent =>
      exec(['dart', 'run', 'git_stamp', '--version']).toString().trim();
}

class CommitList extends GitStampDataFile {
  int? count;

  CommitList(super.encrypt, {this.count});

  @override
  String get filename => 'commit_list.dart';

  @override
  String get variableName => 'gitStampCommitList';

  @override
  String get variableContent {
    final gitLogJson = exec([
      'git',
      'log',
      if (count != null) ...['-n', '$count'],
      '--pretty=format:%H%x1f%s%x1f%ad%x1f%an%x1f%ae%x1e',
      '--date=format-local:%Y-%m-%d %H:%M:%S %z',
    ]);

    final logs = gitLogJson.split('\x1e').where((e) => e.isNotEmpty).map((e) {
      final fields = e.split('\x1f').map((e) => e.trim()).toList();
      return {
        'hash': fields[0],
        'subject': fields[1],
        'date': fields[2],
        'authorName': fields[3],
        'authorEmail': fields[4],
      };
    }).toList();

    return jsonEncode(logs);
  }
}

class DiffList extends GitStampDataFile {
  int? count;
  bool generateEmpty;

  DiffList(super.encrypt, this.generateEmpty, {this.count});

  @override
  String get filename => 'diff_list.dart';

  @override
  String get variableName => 'gitStampDiffList';

  @override
  String get variableContent {
    Map<String, String> map = {};

    if (generateEmpty == false) {
      final hashes = exec([
        'git',
        'rev-list',
        '--all',
        if (count != null) ...['-n $count'],
      ]).trim().split('\n');

      for (var hash in hashes) {
        map[hash] = exec(['git', 'show', hash]);
      }
    }

    return jsonEncode(map).replaceAll("'", r"\'");
  }
}

class DiffStatList extends GitStampDataFile {
  int? count;
  bool generateEmpty;

  DiffStatList(super.encrypt, this.generateEmpty, {this.count});

  @override
  String get filename => 'diff_stat_list.dart';

  @override
  String get variableName => 'gitStampDiffStatList';

  @override
  String get variableContent {
    Map<String, String> map = {};

    if (generateEmpty == false) {
      final hashes = exec([
        'git',
        'rev-list',
        '--all',
        if (count != null) ...['-n $count'],
      ]).trim().split('\n');

      for (var hash in hashes) {
        map[hash] = exec(['git', 'show', '--stat=160', hash]);
      }
    }

    return jsonEncode(map).replaceAll("'", r"\'");
  }
}

class RepoCreationDate extends GitStampDataFile {
  RepoCreationDate(super.encrypt);

  @override
  String get filename => 'repo_creation_date.dart';

  @override
  String get variableName => 'gitStampRepoCreationDate';

  @override
  String get variableContent {
    final creationDate = exec([
      'git',
      'log',
      '--reverse',
      '--pretty=format:%ad',
      '--date=format:%Y-%m-%d %H:%M:%S %z',
    ]);

    final dates = creationDate.toString().split('\n');

    return dates.first.trim();
  }
}

class BuildBranch extends GitStampDataFile {
  BuildBranch(super.encrypt);

  @override
  String get filename => 'build_branch.dart';

  @override
  String get variableName => 'gitStampBuildBranch';

  @override
  String get variableContent {
    final currentBranch = exec(['git', 'rev-parse', '--abbrev-ref', 'HEAD']);

    return currentBranch.toString().trim();
  }
}

class BuildDateTime extends GitStampDataFile {
  BuildDateTime(super.encrypt);

  @override
  String get filename => 'build_date_time.dart';

  @override
  String get variableName => 'gitStampBuildDateTime';

  @override
  String get variableContent {
    final now = DateTime.now();

    /// TO DO Add "Z" parameter after implementing this in intl package.
    final buildDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    final timeZoneOffset = now.timeZoneOffset.inHours;
    final sign = timeZoneOffset >= 0 ? '+' : '-';
    final timeZoneFormatted = timeZoneOffset.abs().toString().padLeft(2, '0');

    return '${buildDateTime.toString().trim()} $sign${timeZoneFormatted}00';
  }
}

class BuildSystemInfo extends GitStampDataFile {
  BuildSystemInfo(super.encrypt);

  @override
  String get filename => 'build_system_info.dart';

  @override
  String get variableName => 'gitStampBuildSystemInfo';

  @override
  String get variableContent {
    final systemInfo = exec(['flutter', 'doctor', '--verbose']);

    return systemInfo.toString().trim();
  }
}

class BuildMachine extends GitStampDataFile {
  BuildMachine(super.encrypt);

  @override
  String get filename => 'build_machine.dart';

  @override
  String get variableName => 'gitStampBuildMachine';

  @override
  String get variableContent {
    final buildMachine = exec([
      'flutter',
      '--no-version-check',
      '--version',
      '--machine',
    ]);

    return buildMachine.toString().trim().replaceAll('\\', '\\\\');
  }
}

class RepoPath extends GitStampDataFile {
  RepoPath(super.encrypt);

  @override
  String get filename => 'repo_path.dart';

  @override
  String get variableName => 'gitStampRepoPath';

  @override
  String get variableContent {
    final repoPath = exec(['git', 'rev-parse', '--show-toplevel']);

    return repoPath.toString().trim();
  }
}

class ObservedFilesList extends GitStampDataFile {
  ObservedFilesList(super.encrypt);

  @override
  String get filename => 'observed_files_list.dart';

  @override
  String get variableName => 'gitStampObservedFilesList';

  @override
  String get variableContent {
    final toplevel = exec(['git', 'rev-parse', '--show-toplevel']).trim();
    final files = exec(['git', '-C', toplevel, 'ls-files']);

    return files;
  }
}

class AppVersion extends GitStampDataFile {
  AppVersion(super.encrypt);

  @override
  String get filename => 'app_version.dart';

  @override
  String get variableName => 'gitStampAppVersion';

  @override
  String get variableContent {
    final file = File('pubspec.yaml');
    final content = file.readAsStringSync();
    final pubspec = Pubspec.parse(content);
    final version = pubspec.version ?? Version(0, 0, 0, build: '0');

    return '${version.major}.${version.minor}.${version.patch}';
  }
}

class AppBuild extends GitStampDataFile {
  AppBuild(super.encrypt);

  @override
  String get filename => 'app_build.dart';

  @override
  String get variableName => 'gitStampAppBuild';

  @override
  String get variableContent {
    final file = File('pubspec.yaml');
    final content = file.readAsStringSync();
    final pubspec = Pubspec.parse(content);
    final version = pubspec.version ?? Version(0, 0, 0, build: '0');
    final buildNumber = version.build.firstOrNull ?? 'NO BUILD NUMBER';

    return buildNumber.toString();
  }
}

class AppName extends GitStampDataFile {
  AppName(super.encrypt);

  @override
  String get filename => 'app_name.dart';

  @override
  String get variableName => 'gitStampAppName';

  @override
  String get variableContent {
    final file = File('pubspec.yaml');
    final content = file.readAsStringSync();
    final pubspec = Pubspec.parse(content);

    return pubspec.name;
  }
}

class GitConfigGlobalUserName extends GitStampDataFile {
  GitConfigGlobalUserName(super.encrypt);

  @override
  String get filename => 'git_config_global_user_name.dart';

  @override
  String get variableName => 'gitStampGitConfigGlobalUserName';

  @override
  String get variableContent =>
      exec(['git', 'config', '--global', 'user.name']).valueOr('EMPTY USER');
}

class GitConfigGlobalUserEmail extends GitStampDataFile {
  GitConfigGlobalUserEmail(super.encrypt);

  @override
  String get filename => 'git_config_global_user_email.dart';

  @override
  String get variableName => 'gitStampGitConfigGlobalUserEmail';

  @override
  String get variableContent =>
      exec(['git', 'config', '--global', 'user.email']).valueOr('EMPTY EMAIL');
}

class GitConfigUserName extends GitStampDataFile {
  GitConfigUserName(super.encrypt);

  @override
  String get filename => 'git_config_user_name.dart';

  @override
  String get variableName => 'gitStampGitConfigUserName';

  @override
  String get variableContent =>
      exec(['git', 'config', 'user.name']).valueOr('EMPTY USER');
}

class GitConfigUserEmail extends GitStampDataFile {
  GitConfigUserEmail(super.encrypt);

  @override
  String get filename => 'git_config_user_email.dart';

  @override
  String get variableName => 'gitStampGitConfigUserEmail';

  @override
  String get variableContent =>
      exec(['git', 'config', 'user.email']).valueOr('EMPTY EMAIL');
}

class GitRemote extends GitStampDataFile {
  GitRemote(super.encrypt);

  @override
  String get filename => 'git_remote.dart';

  @override
  String get variableName => 'gitStampGitRemoteList';

  @override
  String get variableContent => exec(['git', 'remote', '-v']);
}

class GitConfigList extends GitStampDataFile {
  GitConfigList(super.encrypt);

  @override
  String get filename => 'git_config_list.dart';

  @override
  String get variableName => 'gitStampGitConfigList';

  @override
  String get variableContent {
    final gitConfig = exec(['git', 'config', '--list']);

    return _removeTokens(gitConfig);
  }
}

class GitCountObjects extends GitStampDataFile {
  GitCountObjects(super.encrypt);

  @override
  String get filename => 'git_count_objects.dart';

  @override
  String get variableName => 'gitStampGitCountObjects';

  @override
  String get variableContent => exec(['git', 'count-objects', '-vH']);
}

class GitTagList extends GitStampDataFile {
  GitTagList(super.encrypt);

  @override
  String get filename => 'git_tag_list.dart';

  @override
  String get variableName => 'gitStampGitTagList';

  @override
  String get variableContent {
    final tagsList = exec([
      'git',
      'for-each-ref',
      '--sort=-creatordate',
      '--format={"name": "%(refname:short)", "date": "%(creatordate:iso8601)"}',
      'refs/tags',
    ]);

    final tags = LineSplitter.split(
      tagsList,
    ).map((line) => json.decode(line)).toList();

    return jsonEncode(tags);
  }
}

class GitBranchList extends GitStampDataFile {
  GitBranchList(super.encrypt);

  @override
  String get filename => 'git_branch_list.dart';

  @override
  String get variableName => 'gitStampGitBranchList';

  @override
  String get variableContent => exec(['git', 'branch', '-a']);
}

class GitReflog extends GitStampDataFile {
  GitReflog(super.encrypt);

  @override
  String get filename => 'git_reflog.dart';

  @override
  String get variableName => 'gitStampGitReflog';

  @override
  String get variableContent => exec(['git', 'reflog']);
}

class Packages extends GitStampDataFile {
  Packages(super.encrypt);

  @override
  String get filename => 'packages.dart';

  @override
  String get variableName => 'gitStampPackages';

  @override
  String get variableContent => exec([
    'flutter',
    '--no-version-check',
    'pub',
    'pub',
    'outdated',
    '--json',
    '--up-to-date',
  ]);
}

class Deps extends GitStampDataFile {
  Deps(super.encrypt);

  @override
  String get filename => 'deps.dart';

  @override
  String get variableName => 'gitStampDeps';

  @override
  String get variableContent =>
      exec(['flutter', 'pub', 'deps', '--style=list']);
}
