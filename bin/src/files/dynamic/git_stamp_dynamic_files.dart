import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:pub_semver/pub_semver.dart';

import '../../git_stamp_directory.dart';
import '../../git_stamp_file.dart';

class CommitList extends GitStampFile {
  @override
  String filename() => '${GitStampDirectory.dataFolder}/commit_list.dart';

  @override
  String content() {
    final gitLogJson = Process.runSync(
      'git',
      [
        'log',
        '--pretty=format:{"hash":"%H","subject":"%s","date":"%ad","authorName":"%an","authorEmail":"%ae"}',
        '--date=format-local:%Y-%m-%d %H:%M',
      ],
    ).stdout;

    final logs = LineSplitter.split(gitLogJson)
        .map((line) => json.decode(line))
        .toList();

    return '''const gitStampCommitList = \'\'\'\n${jsonEncode(logs)}\n\'\'\';''';
  }
}

class RepoCreationDate extends GitStampFile {
  @override
  String filename() =>
      '${GitStampDirectory.dataFolder}/repo_creation_date.dart';

  @override
  String content() {
    final creationDate = Process.runSync(
      'git',
      [
        'log',
        '--reverse',
        '--pretty=format:%ad',
        '--date=format:%Y-%m-%d %H:%M:%S',
      ],
    ).stdout;

    return 'const gitStampRepoCreationDate = "${creationDate.toString().split('\n').first.trim()}";';
  }
}

class BuildBranch extends GitStampFile {
  @override
  String filename() => '${GitStampDirectory.dataFolder}/build_branch.dart';

  @override
  String content() {
    final currentBranch = Process.runSync(
      'git',
      [
        'rev-parse',
        '--abbrev-ref',
        'HEAD',
      ],
    ).stdout;

    return 'const gitStampBuildBranch = "${currentBranch.toString().trim()}";';
  }
}

class BuildDateTime extends GitStampFile {
  @override
  String filename() => '${GitStampDirectory.dataFolder}/build_date_time.dart';

  @override
  String content() {
    final buildDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    return 'const gitStampBuildDateTime = "${buildDateTime.toString().trim()}";';
  }
}

class BuildSystemInfo extends GitStampFile {
  @override
  String filename() => '${GitStampDirectory.dataFolder}/build_system_info.dart';

  @override
  String content() {
    final systemInfo = Process.runSync(
      'flutter',
      [
        'doctor',
      ],
    ).stdout;

    String? systemInfoParsed = systemInfo
        .toString()
        .split('\n')
        .where(
          (line) => line.contains('] Flutter'),
        )
        .toList()
        .firstOrNull;

    return 'const gitStampBuildSystemInfo = "${systemInfoParsed?.toString().trim()}";';
  }
}

class RepoPath extends GitStampFile {
  @override
  String filename() => '${GitStampDirectory.dataFolder}/repo_path.dart';

  @override
  String content() {
    final repoPath = Process.runSync(
      'git',
      [
        'rev-parse',
        '--show-toplevel',
      ],
    ).stdout;

    return 'const gitStampRepoPath = "${repoPath.toString().trim()}";';
  }
}

class DiffList extends GitStampFile {
  bool generateEmpty;

  DiffList(this.generateEmpty);

  @override
  String filename() => '${GitStampDirectory.dataFolder}/diff_list.dart';

  @override
  String content() {
    Map<String, String> gitShowMap = {};

    if (generateEmpty == false) {
      final hashes = Process.runSync(
        'git',
        [
          'rev-list',
          '--all',
        ],
      ).stdout.toString().trim().split('\n');

      for (var hash in hashes) {
        gitShowMap[hash] = Process.runSync(
          'git',
          [
            'show',
            hash,
          ],
        ).stdout.toString();
      }
    }

    return 'const gitStampDiffList = <String, String>${jsonEncode(gitShowMap).replaceAll(r'$', r'\$')};';
  }
}

class IsLiteVersion extends GitStampFile {
  final bool isLiteVersion;

  IsLiteVersion(this.isLiteVersion);

  @override
  String filename() => '${GitStampDirectory.dataFolder}/is_lite_version.dart';

  @override
  String content() => 'const gitStampIsLiteVersion = $isLiteVersion;';
}

class ObservedFilesList extends GitStampFile {
  @override
  String filename() =>
      '${GitStampDirectory.dataFolder}/observed_files_list.dart';

  @override
  String content() {
    final toplevel = Process.runSync(
      'git',
      [
        'rev-parse',
        '--show-toplevel',
      ],
    ).stdout.toString().trim();

    final files = Process.runSync(
      'git',
      [
        '-C',
        toplevel,
        'ls-files',
      ],
    ).stdout;

    return 'const gitStampObservedFilesList = """$files""";';
  }
}

class AppVersion extends GitStampFile {
  @override
  String filename() => '${GitStampDirectory.dataFolder}/app_version.dart';

  @override
  String content() {
    final file = File('pubspec.yaml');
    final content = file.readAsStringSync();
    final pubspec = Pubspec.parse(content);
    final version = pubspec.version ?? Version(0, 0, 0, build: '0');

    return '''
      const gitStampAppVersion = "${version.major}.${version.minor}.${version.patch}";
      const gitStampAppBuild = "${version.build.first}";
    ''';
  }
}