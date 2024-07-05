class GitStampBuild {
  final bool commitList;
  final bool diffList;
  final bool buildBranch;
  final bool buildDateTime;
  final bool buildSystemInfo;
  final bool repoCreationDate;
  final bool repoPath;
  final bool observedFilesList;
  final bool appVersion;
  final bool generateFlutterFiles;

  const GitStampBuild({
    this.commitList = false,
    this.diffList = false,
    this.buildBranch = false,
    this.buildDateTime = false,
    this.buildSystemInfo = false,
    this.repoCreationDate = false,
    this.repoPath = false,
    this.observedFilesList = false,
    this.appVersion = false,
    this.generateFlutterFiles = false,
  });

  const GitStampBuild.all({
    this.commitList = true,
    this.diffList = true,
    this.buildBranch = true,
    this.buildDateTime = true,
    this.buildSystemInfo = true,
    this.repoCreationDate = true,
    this.repoPath = true,
    this.observedFilesList = true,
    this.appVersion = true,
    this.generateFlutterFiles = true,
  });

  GitStampBuild.custom(List<String> args)
      : commitList = args.contains('commit-list'),
        diffList = args.contains('diff-list'),
        buildBranch = args.contains('build-branch'),
        buildDateTime = args.contains('build-date-time'),
        buildSystemInfo = args.contains('build-system-info'),
        repoCreationDate = args.contains('repo-creation-date'),
        repoPath = args.contains('repo-path'),
        observedFilesList = args.contains('observed-files-list'),
        appVersion = args.contains('app-version'),
        generateFlutterFiles = false;
}
