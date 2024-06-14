import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';

import '../../git_stamp_directory.dart';
import '../../git_stamp_file.dart';

class GitLog extends GitStampFile {
  @override
  String filename() => '${GitStampDirectory.dataFolder}/json_output.dart';

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

    final logsOutput =
        '''const generatedJsonOutput = \'\'\'\n${jsonEncode(logs)}\n\'\'\';''';

    return logsOutput;
  }
}

class GitCreationDate extends GitStampFile {
  @override
  String filename() =>
      '${GitStampDirectory.dataFolder}/creation_date_output.dart';

  @override
  String content() {
    final date = Process.runSync(
      'git',
      [
        'log',
        '--reverse',
        '--pretty=format:%ad',
        '--date=format:%Y-%m-%d %H:%M:%S'
      ],
    ).stdout;

    final dateOutput =
        'const generatedRepoCreationDate = "${date.toString().split('\n').first.trim()}";';

    return dateOutput;
  }
}

class GitBranch extends GitStampFile {
  @override
  String filename() => '${GitStampDirectory.dataFolder}/branch_output.dart';

  @override
  String content() {
    final branch =
        Process.runSync('git', ['rev-parse', '--abbrev-ref', 'HEAD']).stdout;

    final branchOutput =
        'const generatedBuildBranch = "${branch.toString().trim()}";';

    return branchOutput;
  }
}

class BuildDateTime extends GitStampFile {
  @override
  String filename() =>
      '${GitStampDirectory.dataFolder}/build_date_time_output.dart';

  @override
  String content() {
    final buildDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    final buildDateTimeOutput =
        'const generatedBuildDateTime = "${buildDateTime.toString().trim()}";';

    return buildDateTimeOutput;
  }
}

class BuildSystemInfo extends GitStampFile {
  @override
  String filename() =>
      '${GitStampDirectory.dataFolder}/build_system_info_output.dart';

  @override
  String content() {
    final systemInfo = Process.runSync('flutter', ['doctor']).stdout;

    String? systemInfoParsed = systemInfo
        .toString()
        .split('\n')
        .where((line) => line.contains('] Flutter'))
        .toList()
        .firstOrNull;

    final systemInfoOutput =
        'const generatedBuildSystemInfo = "${systemInfoParsed.toString().trim()}";';

    return systemInfoOutput;
  }
}

class RepoPath extends GitStampFile {
  @override
  String filename() => '${GitStampDirectory.dataFolder}/repo_path_output.dart';

  @override
  String content() {
    final repoPath =
        Process.runSync('git', ['rev-parse', '--show-toplevel']).stdout;

    final repoPathOutput =
        'const generatedRepoPath = "${repoPath.toString().trim()}";';

    return repoPathOutput;
  }
}

class GitDiff extends GitStampFile {
  bool generateEmpty;

  GitDiff(this.generateEmpty);

  @override
  String filename() => '${GitStampDirectory.dataFolder}/diff_output.dart';

  @override
  String content() {
    Map<String, String> gitShowMap = {};

    if (generateEmpty == false) {
      final hashes = Process.runSync('git', ['rev-list', '--all'])
          .stdout
          .toString()
          .trim()
          .split('\n');

      for (var hash in hashes) {
        gitShowMap[hash] =
            Process.runSync('git', ['show', hash]).stdout.toString();
      }
    }

    final diffOutput =
        'const generatedDiffOutput = <String, String>${jsonEncode(gitShowMap).replaceAll(r'$', r'\$')};';

    return diffOutput;
  }
}

class GeneratedGitStampVersion extends GitStampFile {
  final bool isLiteVersion;

  GeneratedGitStampVersion(this.isLiteVersion);

  @override
  String filename() => '${GitStampDirectory.dataFolder}/generated_version.dart';

  @override
  String content() => 'const generatedIsLiteVersion = $isLiteVersion;';
}

class ObservedFiles extends GitStampFile {
  @override
  String filename() => '${GitStampDirectory.dataFolder}/observed_files.dart';

  @override
  String content() {
    final toplevel = Process.runSync('git', ['rev-parse', '--show-toplevel'])
        .stdout
        .toString()
        .trim();
    final files = Process.runSync('git', ['-C', toplevel, 'ls-files']).stdout;

    return 'const generatedObservedFiles = """$files""";';
  }
}
