class GitStampBuildModel {
  bool commitList = false;
  bool diffList = false;
  bool diffStatList = false;
  bool buildBranch = false;
  bool buildDateTime = false;
  bool buildSystemInfo = false;
  bool buildMachine = false;
  bool repoCreationDate = false;
  bool repoPath = false;
  bool observedFilesList = false;
  bool appVersion = false;
  bool appBuild = false;
  bool appName = false;
  bool gitConfig = false;
  bool gitRemote = false;
  bool gitConfigList = false;
  bool generateFlutterFiles = false;
  bool generateFlutterIcon = false;

  GitStampBuildModel.all({
    this.commitList = true,
    this.diffList = true,
    this.diffStatList = true,
    this.buildBranch = true,
    this.buildDateTime = true,
    this.buildSystemInfo = true,
    this.buildMachine = true,
    this.repoCreationDate = true,
    this.repoPath = true,
    this.observedFilesList = true,
    this.appVersion = true,
    this.appBuild = true,
    this.appName = true,
    this.gitConfig = true,
    this.gitRemote = true,
    this.gitConfigList = true,
    this.generateFlutterFiles = true,
    this.generateFlutterIcon = true,
  });

  GitStampBuildModel.icon({
    this.appVersion = true,
    this.appBuild = true,
    this.buildBranch = true,
    this.buildDateTime = true,
    this.commitList = true,
    this.generateFlutterIcon = true,
  });

  GitStampBuildModel.custom(List<String> args)
      : commitList = args.contains('commit-list'),
        diffList = args.contains('diff-list'),
        diffStatList = args.contains('diff-stat-list'),
        buildBranch = args.contains('build-branch'),
        buildDateTime = args.contains('build-date-time'),
        buildSystemInfo = args.contains('build-system-info'),
        buildMachine = args.contains('build-machine'),
        repoCreationDate = args.contains('repo-creation-date'),
        repoPath = args.contains('repo-path'),
        observedFilesList = args.contains('observed-files-list'),
        appVersion = args.contains('app-version'),
        appBuild = args.contains('app-build'),
        appName = args.contains('app-name'),
        gitConfig = args.contains('git-config'),
        gitRemote = args.contains('git-remote'),
        gitConfigList = args.contains('git-config-list'),
        generateFlutterFiles = false,
        generateFlutterIcon = false;

  bool get isIcon =>
      commitList == true &&
      diffList == false &&
      diffStatList == false &&
      buildBranch == true &&
      buildDateTime == true &&
      buildSystemInfo == false &&
      buildMachine == false &&
      repoCreationDate == false &&
      repoPath == false &&
      observedFilesList == false &&
      appVersion == true &&
      appBuild == true &&
      appName == false &&
      gitConfig == false &&
      gitRemote == false &&
      gitConfigList == false &&
      generateFlutterFiles == false &&
      generateFlutterIcon == true;
}
