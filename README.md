[<img src="https://www.gov.pl/photo/f98cae42-2b90-4596-904c-752278f85606" height="100" align="right">](https://www.gov.pl/web/rolnictwo/produkt-polski1)

# [Git Stamp 🏷](./TODO.md)

Advanced await-less information provider. From simple information such as `build-branch` to a screen with Flutter code with commits and change history. [How it work?](./MECHANISM.md)

[![Latest Tag](https://img.shields.io/github/v/tag/arononak/git_stamp?style=flat&logo=github&labelColor=black&color=white)](https://github.com/arononak/git_stamp/tags)
[![GitHub stars](https://img.shields.io/github/stars/arononak/git_stamp.svg?style=flat&label=Star&labelColor=black&color=white)](https://github.com/arononak/git_stamp/)
[![Commits](https://img.shields.io/github/commit-activity/m/arononak/git_stamp?style=flat&labelColor=black&color=white)](https://github.com/arononak/git_stamp/graphs/contributors)
![Dev](https://img.shields.io/github/actions/workflow/status/arononak/git_stamp/.github%2Fworkflows%2Fdev.yml?style=flat&labelColor=black&color=white&label=dev)
![Prod](https://img.shields.io/github/actions/workflow/status/arononak/git_stamp/.github%2Fworkflows%2Fprod.yml?style=flat&labelColor=black&color=white&label=prod)

[![Pub Package](https://img.shields.io/pub/v/git_stamp.svg?style=flat&logo=dart&labelColor=fuchsia&color=white)](https://pub.dev/packages/git_stamp)
[![Likes](https://img.shields.io/pub/likes/git_stamp?style=flat&labelColor=fuchsia&color=white)](https://pub.dev/packages/git_stamp)
[![package publisher](https://img.shields.io/pub/publisher/git_stamp?style=flat&labelColor=fuchsia&color=white)](https://pub.dev/packages/git_stamp/publisher)

**Check out the [Example](https://gitstamp.web.app) 🌀**

<details>
<summary>Table of Contents</summary>
  
- [Git Stamp 🏷](#git-stamp-)
  - [🏞️ Preview](#️-preview)
  - [📑️ About](#️-about)
      - [Goal](#goal)
      - [Motivation](#motivation)
      - [Roadmap](#roadmap)
        - [Changelogs (Text) (Image)](#changelogs-text-image)
  - [🛠️ Installation](#️-installation)
      - [1. `pubspec.yaml`](#1-pubspecyaml)
      - [2. `.gitignore`](#2-gitignore)
      - [3. `analysis_options.yaml`](#3-analysis_optionsyaml)
      - [4. `README.md`](#4-readmemd)
  - [🏗️ Generating](#️-generating)
      - [1. Examples](#1-examples)
      - [2. Tip](#2-tip)
      - [3. Custom `gen-only` parameters](#3-custom-gen-only-parameters)
  - [💻 Usage](#-usage)
      - [1. ListTile](#1-listtile)
      - [2. IconButton](#2-iconbutton)
      - [3. showGitStampLicensePage()](#3-showgitstamplicensepage)
      - [4. Central **GitStamp** node for advanced usage:](#4-central-gitstamp-node-for-advanced-usage)
  - [📦 Integration](#-integration)
      - [GitHub Actions](#github-actions)
  - [📝 License](#-license)

</details>

## 🏞️ Preview

| List                      | Icon                      |
| :-----------------------: | :-----------------------: |
| ![](screenshots/list.png) | ![](screenshots/icon.png) |

| Files                      | Details                      |
| :------------------------: | :--------------------------: |
| ![](screenshots/files.png) | ![](screenshots/details.png) |

## 📑️ About

#### Goal

The main goal is to help locate errors in the full process of building STAGE, TEST and PROD versions.

#### Motivation

The main motivation was **Minecraft** with information like this:
```
Version: v1.20.81
Build: 24130126
Branch: r/20_u8
SHA: a9081c5429038dcf3f26269f7351d89f
```

Git Stamp code:
```dart
import 'git_stamp/git_stamp.dart';

Text('Version: ${GitStamp.appVersion}'),
Text('Build: ${GitStamp.appBuild}'),
Text('Branch: ${GitStamp.buildBranch}'),
Text('SHA: ${GitStamp.sha}'),
```

#### Roadmap

##### Changelogs ([Text](./CHANGELOG.md)) ([Image](./changelog/CHANGELOG.md))

| 🆕 **Version** | 🗓️ **Date**        |  📝 **Change Description**        |
|----------------|--------------------|-----------------------------------|
| Version 6      | Someday it will be | 📦 JSON data export               |
| Version 5      | Someday it will be | 🔐 Data encription                |
| Version 4      | 24.07.2024         | 🌟 New `icon` build-type          |
| Version 3      | 30.06.2024         | 🔧 New `gen-only` build-type      |
| Version 2      | 10.04.2024         | 🛠️ Commit diff                    |
| Version 1      | 11.12.2023         | 🚀 First version                  |


## 🛠️ Installation

#### 1. `pubspec.yaml`

```
dart pub add git_stamp
```

#### 2. `.gitignore`

> [!IMPORTANT]
> Add **git_stamp** to .gitignore.
> 
> ```echo -e "\n/lib/git_stamp/" >> .gitignore```.
> 
> If you add a **/git_stamp** folder for the repository and use the `FULL` version, the size of the repository will grow EXPONENTIALLY.

#### 3. `analysis_options.yaml`

```yaml
analyzer:
  exclude:
    - lib/git_stamp/**
```

#### 4. `README.md`

> [!WARNING]
> Add badge to your `README.md` 😄️
>
> [![Git Stamp](https://img.shields.io/badge/i%20love%20Git%20Stamp-ffff99?style=flat)](https://github.com/arononak/git_stamp)
>
>```
>[![Git Stamp](https://img.shields.io/badge/i%20love%20Git%20Stamp-ffff99?style=flat)](https://github.com/arononak/git_stamp)
>```

## 🏗️ Generating

#### 1. Examples

| Build type | Pure Dart                  | CLI Command                                                  |
| ---------- | -------------------------- | ------------------------------------------------------------ |
| LITE       | NO                         | `dart run git_stamp`                                         |
| FULL       | NO                         | `dart run git_stamp --build-type full`                       |
| ICON       | NO                         | `dart run git_stamp --build-type icon`                       |
| CUSTOM     | YES                        | `dart run git_stamp --gen-only build-branch,build-date-time` |

#### 2. Tip

> [!CAUTION]
> Generating requires the use of the `git` command-line interface (CLI).

#### 3. Custom `gen-only` parameters 

| #  | Parameter          |
|----|--------------------|
| 1  | commit-list        |
| 2  | diff-list          |
| 3  | diff-stat-list     |
| 4  | repo-creation-date |
| 5  | build-branch       |
| 6  | build-date-time    |
| 7  | build-system-info  |
| 8  | build-machine      |
| 9  | repo-path          |
| 10 | observed-files-list|
| 11 | app-version        |
| 12 | app-build          |
| 13 | app-name           |
| 14 | git-config         |
| 15 | git-remote         |
| 15 | git-remote-list    |

## 💻 Usage

#### 1. ListTile

```dart
if (kDebugMode) ...[
  ListTile(
    title: const Text('Git Stamp'),
    subtitle: Text(GitStamp.sha),
    leading: const Icon(Icons.commit, monospaceFontFamily: GoogleFonts.spaceMono().fontFamily),
    onTap: () => showGitStampPage(context: context),
  ),
],
```

#### 2. IconButton
```dart
if (isProd == false) ...[
  IconButton(
    onPressed: () => showGitStampPage(context: context, monospaceFontFamily: GoogleFonts.spaceMono().fontFamily),
    icon: const Icon(Icons.book),
  ),
],
```

#### 3. showGitStampLicensePage()

> [!NOTE]
> Use function `GitStamp.showLicensePage` instead of `showLicensePage` if you want the `name` and `version` to be added automatically.

#### 4. Central **GitStamp** node for advanced usage:

```dart
class GitStamp {
  static List<GitStampCommit> get commitList
  static GitStampCommit? get latestCommit
  static String get sha
  static int get commitCount

  static Map<String, dynamic> diffList
  static Map<String, dynamic> diffStatList

  static const String buildBranch
  static const String buildDateTime
  static const String buildSystemInfo
  static GitStampBuildMachine buildMachine
  static const String repoCreationDate
  static const String repoPath

  static String observedFiles
  static List<String> observedFilesList
  static int observedFilesCount

  static const String appVersion
  static const String appBuild
  static const String appName

  static const String gitConfigGlobalUserName
  static const String gitConfigGlobalUserEmail
  static const String gitConfigUserName
  static const String gitConfigUserEmail

  static const String gitRemote

  static showLicensePage({
    required BuildContext context,
    Widget? applicationIcon,
    String? applicationLegalese,
    bool useRootNavigator = false,
  })
}
```

## 📦 Integration

#### GitHub Actions

<details>
<summary>.github/workflows/build_and_deploy.yml</summary>

```yml
name: build_and_deploy

on:
  push:
    branches: [main]
  pull_request_target:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.22.2'
          channel: 'stable'
      - run: flutter --version
      - uses: actions/setup-java@v1
        with:
          java-version: "12.x"
      - run: flutter pub get
      - run: dart run git_stamp
      - run: flutter build web --release --web-renderer canvaskit
      - uses: actions/upload-artifact@master
        with:
          name: build
          path: build/web
  deploy:
    name: "Deploy"
    runs-on: ubuntu-latest
    needs: build
    steps:
      - uses: actions/checkout@v3
      - uses: actions/download-artifact@master
        with:
          name: build
          path: build/web
      - uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: "${{ secrets.GITHUB_TOKEN }}"
          firebaseServiceAccount: "${{ secrets.FIREBASE_SERVICE_ACCOUNT }}"
          projectId: xxx
          channelId: live
```

</details>

## 📝 License

> [!NOTE]
> Copyright © 2024 Aron Onak. All rights reserved.<br>
> Licensed under the [MIT](LICENSE) license.<br>
> If you have any feedback, please contact me at arononak@gmail.com
