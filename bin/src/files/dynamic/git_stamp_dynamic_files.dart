import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:pub_semver/pub_semver.dart';

import '../../git_stamp_file.dart';

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

class CommitList extends GitStampDataFile {
  @override
  String get filename => 'commit_list.dart';

  @override
  String get content {
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

class DiffList extends GitStampDataFile {
  bool generateEmpty;

  DiffList(this.generateEmpty);

  @override
  String get filename => 'diff_list.dart';

  @override
  String get content {
    Map<String, String> map = {};

    if (generateEmpty == false) {
      final hashes = exec(['git', 'rev-list', '--all']).trim().split('\n');

      for (var hash in hashes) {
        map[hash] = exec(['git', 'show', hash]);
      }
    }

    String jsonString = jsonEncode(map).replaceAll("'", r"\'");

    return '''
      const String gitStampDiffList = r\'\'\'$jsonString\'\'\';
    ''';
  }
}

class DiffStatList extends GitStampDataFile {
  bool generateEmpty;

  DiffStatList(this.generateEmpty);

  @override
  String get filename => 'diff_stat_list.dart';

  @override
  String get content {
    Map<String, String> map = {};

    if (generateEmpty == false) {
      final hashes = exec(['git', 'rev-list', '--all']).trim().split('\n');

      for (var hash in hashes) {
        map[hash] = exec(['git', 'show', '--stat=160', hash]);
      }
    }

    String jsonString = jsonEncode(map).replaceAll("'", r"\'");

    return '''
      const String gitStampDiffStatList = r\'\'\'$jsonString\'\'\';
    ''';
  }
}

class RepoCreationDate extends GitStampDataFile {
  @override
  String get filename => 'repo_creation_date.dart';

  @override
  String get content {
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

class BuildBranch extends GitStampDataFile {
  @override
  String get filename => 'build_branch.dart';

  @override
  String get content {
    final currentBranch = exec(['git', 'rev-parse', '--abbrev-ref', 'HEAD']);

    return 'const gitStampBuildBranch = "${currentBranch.toString().trim()}";';
  }
}

class BuildDateTime extends GitStampDataFile {
  @override
  String get filename => 'build_date_time.dart';

  @override
  String get content {
    final now = DateTime.now();

    /// TO DO Add "Z" parameter after implementing this in intl package.
    final buildDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    final timeZoneOffset = now.timeZoneOffset.inHours;
    final sign = timeZoneOffset >= 0 ? '+' : '-';
    final timeZoneFormatted = timeZoneOffset.abs().toString().padLeft(2, '0');

    return 'const gitStampBuildDateTime = "${buildDateTime.toString().trim()} $sign${timeZoneFormatted}00";';
  }
}

class BuildSystemInfo extends GitStampDataFile {
  @override
  String get filename => 'build_system_info.dart';

  @override
  String get content {
    final systemInfo = exec(['flutter', 'doctor', '--verbose']);

    return 'const gitStampBuildSystemInfo = \'\'\'${systemInfo.toString().trim()}\'\'\';';
  }
}

class BuildMachine extends GitStampDataFile {
  @override
  String get filename => 'build_machine.dart';

  @override
  String get content {
    final buildMachine =
        exec(['flutter', '--no-version-check', '--version', '--machine']);

    return 'const gitStampBuildMachine = \'\'\'${buildMachine.toString().trim()}\'\'\';';
  }
}

class RepoPath extends GitStampDataFile {
  @override
  String get filename => 'repo_path.dart';

  @override
  String get content {
    final repoPath = exec(['git', 'rev-parse', '--show-toplevel']);

    return 'const gitStampRepoPath = "${repoPath.toString().trim()}";';
  }
}

class IsLiteVersion extends GitStampUiFile {
  final bool isLiteVersion;

  IsLiteVersion(this.isLiteVersion);

  @override
  String get filename => 'is_lite_version.dart';

  @override
  String get content => 'const gitStampIsLiteVersion = $isLiteVersion;';
}

class ObservedFilesList extends GitStampDataFile {
  @override
  String get filename => 'observed_files_list.dart';

  @override
  String get content {
    final toplevel = exec(['git', 'rev-parse', '--show-toplevel']).trim();
    final files = exec(['git', '-C', toplevel, 'ls-files']);

    return 'const gitStampObservedFilesList = """$files""";';
  }
}

class AppVersion extends GitStampDataFile {
  @override
  String get filename => 'app_version.dart';

  @override
  String get content {
    final file = File('pubspec.yaml');
    final content = file.readAsStringSync();
    final pubspec = Pubspec.parse(content);
    final version = pubspec.version ?? Version(0, 0, 0, build: '0');

    return '''
      const gitStampAppVersion = "${version.major}.${version.minor}.${version.patch}";
    ''';
  }
}

class AppBuild extends GitStampDataFile {
  @override
  String get filename => 'app_build.dart';

  @override
  String get content {
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

class AppName extends GitStampDataFile {
  @override
  String get filename => 'app_name.dart';

  @override
  String get content {
    final file = File('pubspec.yaml');
    final content = file.readAsStringSync();
    final pubspec = Pubspec.parse(content);

    return '''
      const gitStampAppName = '${pubspec.name}';
    ''';
  }
}

class GitStampVersion extends GitStampMainFile {
  @override
  String get filename => 'git_stamp_tool_version.dart';

  @override
  String get content {
    final versionStdout = exec(['dart', 'run', 'git_stamp', '--version']);

    final gitStampVersion =
        versionStdout.toString().trim().split(' ').last.split('').first;

    return '''
      const gitStampToolVersion = "$gitStampVersion";
    ''';
  }
}

class GitConfig extends GitStampDataFile {
  @override
  String get filename => 'git_config.dart';

  @override
  String get content {
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

class GitRemote extends GitStampDataFile {
  @override
  String get filename => 'git_remote.dart';

  @override
  String get content {
    final gitRemote = exec(['git', 'remote', '-v']);

    return 'const gitStampGitRemoteList = """$gitRemote""";';
  }
}
