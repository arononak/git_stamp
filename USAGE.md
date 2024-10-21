# 💻 Usage

### 1. GitStampListTile

```dart
if (kDebugMode) ...[
  GitStampListTile(monospaceFontFamily: GoogleFonts.spaceMono().fontFamily),
],
```

### 2. GitStampIcon
```dart
if (isProd == false) ...[
  GitStampIcon(),
],
```

### 3. Custom
```dart
if (isProd == false) ...[
  IconButton(
    onPressed: () => showGitStampPage(context: context, monospaceFontFamily: GoogleFonts.spaceMono().fontFamily),
    icon: const Icon(Icons.book),
  ),
],
```

### 4. showGitStampLicensePage()

> [!NOTE]
> Use function `GitStamp.showLicensePage` instead of `showLicensePage` if you want the `name` and `version` to be added automatically.

### 5. Central **GitStamp** node for advanced usage:

<details>
<summary>GitStampNode</summary>

```dart
abstract class GitStampNode {
  String get commitListString;
  List<GitStampCommit> get commitList;
  GitStampCommit? get latestCommit;
  String get sha;
  int get commitCount;

  String get diffListString;
  Map<String, dynamic> get diffList;
  String get diffStatListString;
  Map<String, dynamic> get diffStatList;

  String get buildMachineString;
  GitStampBuildMachine get buildMachine;

  String get buildBranch;
  String get buildDateTime;
  String get buildSystemInfo;
  String get repoCreationDate;
  String get repoPath;

  String get observedFiles;
  List<String> get observedFilesList;
  int get observedFilesCount;

  String get tagListString;
  List<String> get tagList;
  int get tagListCount;

  String get branchListString;
  List<String> get branchList;
  int get branchListCount;

  String get appVersionFull => appVersion + ' (' + appBuild + ')';
  String get appVersion;
  String get appBuild;
  String get appName;

  String get gitConfigGlobalUser => gitConfigGlobalUserName + ' (' + gitConfigGlobalUserEmail + ')';
  String get gitConfigGlobalUserName;
  String get gitConfigGlobalUserEmail;

  String get gitConfigUser => gitConfigUserName + ' (' + gitConfigUserEmail + ')';
  String get gitConfigUserName;
  String get gitConfigUserEmail;

  String get gitRemote;
  String get gitConfigList;
  String get gitCountObjects;

  void showLicensePage({
    required BuildContext context,
    Widget? applicationIcon,
    String? applicationLegalese,
    bool useRootNavigator = false,
  });
}
```

</details>