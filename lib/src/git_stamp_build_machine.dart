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

  factory GitStampBuildMachine.fromJson(Map<String, dynamic> json) =>
      GitStampBuildMachine(
        frameworkVersion: json['frameworkVersion'] ?? 'null',
        channel: json['channel'] ?? 'null',
        repositoryUrl: json['repositoryUrl'] ?? 'null',
        frameworkRevision: json['frameworkRevision'] ?? 'null',
        frameworkCommitDate: json['frameworkCommitDate'] ?? 'null',
        engineRevision: json['engineRevision'] ?? 'null',
        dartSdkVersion: json['dartSdkVersion'] ?? 'null',
        devToolsVersion: json['devToolsVersion'] ?? 'null',
        flutterVersion: json['flutterVersion'] ?? 'null',
        flutterRoot: json['flutterRoot'] ?? 'null',
      );

  factory GitStampBuildMachine.all(String value) => GitStampBuildMachine(
        frameworkVersion: value,
        channel: value,
        repositoryUrl: value,
        frameworkRevision: value,
        frameworkCommitDate: value,
        engineRevision: value,
        dartSdkVersion: value,
        devToolsVersion: value,
        flutterVersion: value,
        flutterRoot: value,
      );
}
