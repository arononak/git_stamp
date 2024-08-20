import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:pub_semver/pub_semver.dart';

import '../../git_stamp_directory.dart';
import '../../git_stamp_file.dart';

String exec(List<String> args) {
  return Process.runSync(args.first, args.sublist(1)).stdout.toString().trim();
}

extension StringExtension on String {
  String valueOr(String empty) => isNotEmpty ? this : empty;
}

class CommitList extends GitStampFile {
  @override
  String directory() => GitStampDirectory.dataFolder;

  @override
  String filename() => 'commit_list.dart';

  @override
  String content() {
    final gitLogJson = exec([
      'git',
      'log',
      '--pretty=format:{"hash":"%H","subject":"%s","date":"%ad","authorName":"%an","authorEmail":"%ae"}',
      '--date=format-local:%Y-%m-%d %H:%M %z'
    ]);

    final logs = LineSplitter.split(gitLogJson)
        .map((line) => json.decode(line))
        .toList();

    return '''const gitStampCommitList = \'\'\'\n${jsonEncode(logs)}\n\'\'\';''';
  }
}

class DiffList extends GitStampFile {
  bool generateEmpty;

  DiffList(this.generateEmpty);

  @override
  String directory() => GitStampDirectory.dataFolder;

  @override
  String filename() => 'diff_list.dart';

  @override
  String content() {
    Map<String, String> gitShowMap = {};

    if (generateEmpty == false) {
      final hashes = exec(['git', 'rev-list', '--all']).trim().split('\n');

      for (var hash in hashes) {
        gitShowMap[hash] = exec(['git', 'show', hash]);
      }
    }

    return 'const gitStampDiffList = <String, String>${jsonEncode(gitShowMap).replaceAll(r'$', r'\$')};';
  }
}

class RepoCreationDate extends GitStampFile {
  @override
  String directory() => GitStampDirectory.dataFolder;

  @override
  String filename() => 'repo_creation_date.dart';

  @override
  String content() {
    final creationDate = exec([
      'git',
      'log',
      '--reverse',
      '--pretty=format:%ad',
      '--date=format:%Y-%m-%d %H:%M:%S %z',
    ]);

    final dates = creationDate.toString().split('\n');

    return 'const gitStampRepoCreationDate = "${dates.first.trim()}";';
  }
}

class BuildBranch extends GitStampFile {
  @override
  String directory() => GitStampDirectory.dataFolder;

  @override
  String filename() => 'build_branch.dart';

  @override
  String content() {
    final currentBranch = exec(['git', 'rev-parse', '--abbrev-ref', 'HEAD']);

    return 'const gitStampBuildBranch = "${currentBranch.toString().trim()}";';
  }
}

class BuildDateTime extends GitStampFile {
  @override
  String directory() => GitStampDirectory.dataFolder;

  @override
  String filename() => 'build_date_time.dart';

  @override
  String content() {
    final now = DateTime.now();

    /// TODO Add "Z" parameter after implementing this in intl package.
    final buildDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    final timeZoneOffset = now.timeZoneOffset.inHours;
    final sign = timeZoneOffset >= 0 ? '+' : '-';
    final timeZoneFormatted = timeZoneOffset.abs().toString().padLeft(2, '0');

    return 'const gitStampBuildDateTime = "${buildDateTime.toString().trim()} $sign${timeZoneFormatted}00";';
  }
}

class BuildSystemInfo extends GitStampFile {
  @override
  String directory() => GitStampDirectory.dataFolder;

  @override
  String filename() => 'build_system_info.dart';

  @override
  String content() {
    final systemInfo = exec(['flutter', 'doctor']);

    String? systemInfoParsed = systemInfo
        .toString()
        .split('\n')
        .where((line) => line.contains('] Flutter'))
        .toList()
        .firstOrNull;

    return 'const gitStampBuildSystemInfo = "${systemInfoParsed?.toString().trim()}";';
  }
}

class RepoPath extends GitStampFile {
  @override
  String directory() => GitStampDirectory.dataFolder;

  @override
  String filename() => 'repo_path.dart';

  @override
  String content() {
    final repoPath = exec(['git', 'rev-parse', '--show-toplevel']);

    return 'const gitStampRepoPath = "${repoPath.toString().trim()}";';
  }
}

class IsLiteVersion extends GitStampFile {
  final bool isLiteVersion;

  IsLiteVersion(this.isLiteVersion);

  @override
  String directory() => GitStampDirectory.uiFolder;

  @override
  String filename() => 'is_lite_version.dart';

  @override
  String content() => 'const gitStampIsLiteVersion = $isLiteVersion;';
}

class ObservedFilesList extends GitStampFile {
  @override
  String directory() => GitStampDirectory.dataFolder;

  @override
  String filename() => 'observed_files_list.dart';

  @override
  String content() {
    final toplevel = exec(['git', 'rev-parse', '--show-toplevel']).trim();
    final files = exec(['git', '-C', toplevel, 'ls-files']);

    return 'const gitStampObservedFilesList = """$files""";';
  }
}

class AppVersion extends GitStampFile {
  @override
  String directory() => GitStampDirectory.dataFolder;

  @override
  String filename() => 'app_version.dart';

  @override
  String content() {
    final file = File('pubspec.yaml');
    final content = file.readAsStringSync();
    final pubspec = Pubspec.parse(content);
    final version = pubspec.version ?? Version(0, 0, 0, build: '0');

    return '''
      const gitStampAppVersion = "${version.major}.${version.minor}.${version.patch}";
    ''';
  }
}

class AppBuild extends GitStampFile {
  @override
  String directory() => GitStampDirectory.dataFolder;

  @override
  String filename() => 'app_build.dart';

  @override
  String content() {
    final file = File('pubspec.yaml');
    final content = file.readAsStringSync();
    final pubspec = Pubspec.parse(content);
    final version = pubspec.version ?? Version(0, 0, 0, build: '0');
    final buildNumber = version.build.firstOrNull ?? 'NO BUILD NUMBER';

    return '''
      const gitStampAppBuild = "$buildNumber";
    ''';
  }
}

class AppName extends GitStampFile {
  @override
  String directory() => GitStampDirectory.dataFolder;

  @override
  String filename() => 'app_name.dart';

  @override
  String content() {
    final file = File('pubspec.yaml');
    final content = file.readAsStringSync();
    final pubspec = Pubspec.parse(content);

    return '''
      const gitStampAppName = '${pubspec.name}';
    ''';
  }
}

class GitStampVersion extends GitStampFile {
  @override
  String directory() => GitStampDirectory.mainFolder;

  @override
  String filename() => 'git_stamp_tool_version.dart';

  @override
  String content() {
    final versionStdout = exec(['dart', 'run', 'git_stamp', '--version']);

    final gitStampVersion =
        versionStdout.toString().trim().split(' ').last.split('').first;

    return '''
      const gitStampToolVersion = "$gitStampVersion";
    ''';
  }
}

class GitConfig extends GitStampFile {
  @override
  String directory() => GitStampDirectory.dataFolder;

  @override
  String filename() => 'git_config.dart';

  @override
  String content() {
    final userName = exec(['git', 'config', 'user.name']);
    final userEmail = exec(['git', 'config', 'user.email']);

    final globalUserName = exec(['git', 'config', '--global', 'user.name']);
    final globalUserEmail = exec(['git', 'config', '--global', 'user.email']);

    return '''
      const gitStampGitConfigGlobalUserName = "${globalUserName.valueOr('EMPTY USER')}";
      const gitStampGitConfigGlobalUserEmail = "${globalUserEmail.valueOr('EMPTY EMAIL')}";
      const gitStampGitConfigUserName = "${userName.valueOr('EMPTY USER')}";
      const gitStampGitConfigUserEmail = "${userEmail.valueOr('EMPTY EMAIL')}";
    ''';
  }
}
