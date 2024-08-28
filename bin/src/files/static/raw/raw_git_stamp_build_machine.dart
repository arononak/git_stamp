const rawGitStampBuildMachine = '''
class GitStampBuildMachine {
  final String frameworkVersion;
  final String channel;
  final String repositoryUrl;
  final String frameworkRevision;
  final String frameworkCommitDate;
  final String engineRevision;
  final String dartSdkVersion;
  final String devToolsVersion;
  final String flutterVersion;
  final String flutterRoot;

  GitStampBuildMachine({
    required this.frameworkVersion,
    required this.channel,
    required this.repositoryUrl,
    required this.frameworkRevision,
    required this.frameworkCommitDate,
    required this.engineRevision,
    required this.dartSdkVersion,
    required this.devToolsVersion,
    required this.flutterVersion,
    required this.flutterRoot,
  });

  factory GitStampBuildMachine.fromJson(Map<String, dynamic> json) => GitStampBuildMachine(
        frameworkVersion: json['frameworkVersion'],
        channel: json['channel'],
        repositoryUrl: json['repositoryUrl'],
        frameworkRevision: json['frameworkRevision'],
        frameworkCommitDate: json['frameworkCommitDate'],
        engineRevision: json['engineRevision'],
        dartSdkVersion: json['dartSdkVersion'],
        devToolsVersion: json['devToolsVersion'],
        flutterVersion: json['flutterVersion'],
        flutterRoot: json['flutterRoot'],
      );
}
''';
