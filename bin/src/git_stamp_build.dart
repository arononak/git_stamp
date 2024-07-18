class GitStampBuild {
  bool commitList = false;
  bool diffList = false;
  bool buildBranch = false;
  bool buildDateTime = false;
  bool buildSystemInfo = false;
  bool repoCreationDate = false;
  bool repoPath = false;
  bool observedFilesList = false;
  bool appVersion = false;
  bool generateFlutterFiles = false;
  bool generateFlutterIcon = false;

  GitStampBuild.all({
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
    this.generateFlutterIcon = true,
  });

  GitStampBuild.tooltip({
    this.commitList = true,
    this.buildBranch = true,
    this.buildDateTime = true,
    this.generateFlutterIcon = true,
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
        generateFlutterFiles = false,
        generateFlutterIcon = false;
}
