[<img src="https://www.gov.pl/photo/f98cae42-2b90-4596-904c-752278f85606" height="100" align="right">](https://www.gov.pl/web/rolnictwo/produkt-polski1)

# Git Stamp 🏷

#### Build-Time Git History Integration in Your Flutter App

[![Latest Tag](https://img.shields.io/github/v/tag/arononak/git_stamp?labelColor=orange&color=white)](https://github.com/arononak/git_stamp/tags)
[![Pub Package](https://img.shields.io/pub/v/git_stamp.svg?labelColor=purple&color=white)](https://pub.dev/packages/git_stamp)
[![Commits](https://img.shields.io/github/commit-activity/m/arononak/git_stamp?labelColor=blue&color=white)](https://github.com/arononak/git_stamp/graphs/contributors)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/arononak/git_stamp/.github%2Fworkflows%2Fpublish.yml?labelColor=yellow&color=white)

<!-- https://carbon.now.sh/ -->
![https://github.com/arononak/git_stamp](https://github.com/arononak/git_stamp/blob/main/usage.png?raw=true)

## Table of contents
  
- [Git Stamp 🏷](#git-stamp-)
      - [Build-Time Git History Integration in Your Flutter App](#build-time-git-history-integration-in-your-flutter-app)
  - [Table of contents](#table-of-contents)
  - [🏞️ Preview](#️-preview)
  - [🛠️ Installation](#️-installation)
  - [🏗️ Generating](#️-generating)
  - [💻 Usage](#-usage)
      - [Default usage:](#default-usage)
      - [Advanced usage:](#advanced-usage)
  - [🔧 Development](#-development)
  - [📝 License](#-license)

## 🏞️ Preview

|                                      Light                                      |                                      Dark                                      |
| :-----------------------------------------------------------------------------: | :----------------------------------------------------------------------------: |
| ![](https://github.com/arononak/git_stamp/blob/main/preview_light.png?raw=true) | ![](https://github.com/arononak/git_stamp/blob/main/preview_dark.png?raw=true) |

## 🛠️ Installation

```
  dart pub add git_stamp
```

or

```yaml
dev_dependencies:
  git_stamp: ^2.6.0
```

or

```yaml
dependencies:
  url_launcher: ^6.2.3
dev_dependencies:
  git_stamp:
    git:
      url: https://github.com/arononak/git_stamp
      ref: main
```

## 🏗️ Generating

| CLI Command                                                  | Build type | Use ```url_launcher``` |
| ------------------------------------------------------------ | ---------- | ---------------------- |
| `dart run git_stamp`                                         | LITE       | DISABLED               |
| `dart run git_stamp --buildtype full --url_launcher enabled` | FULL       | ENABLED                |

> [!CAUTION]
> Generating requires the use of the `git` command-line interface (CLI).

> [!IMPORTANT]  
> If you use Github Action, you only get a single commit because GitHub Actions by default only retrieves the latest version (single commit) and does not include the full history of the repository. This is normal behavior to optimize the build process and improve performance, especially for large repositories. Try configuring github actions or generating Git Stamp files before `git push`.

## 💻 Usage

#### Default usage:

```dart
if (isProd == false) ...[
  IconButton(
    onPressed: () => showGitStampPage(context: context),
    icon: const Icon(Icons.book),
  ),
],
```

![](https://github.com/arononak/git_stamp/blob/main/development.png?raw=true)

#### Advanced usage:

Central **GitStamp** node:

```dart
class GitStamp {
  static const buildBranch
  static const buildDateTime
  static const buildSystemInfo
  static const repoCreationDate
  static const diffOutput
  static const isLiteVersion
  static const jsonOutput
  static const repoPath

  static List<GitStampCommit> commitList
  static GitStampCommit latestCommit;
}
```

Example usage:

```dart
import 'git_stamp.dart';

Text(GitStamp.latestCommit.hash),
```

## [🔧 Development](./TODO.md)

| Step                    | Description                  |
| ----------------------- | ---------------------------- |
| 🔧 Run `pana` command   | Check 160/160 points         |
| 📸 New SS               | Create a new screenshots     |
| 🏷️ New tag and push     | Deploy every **Wednesday !** |

## 📝 License

> [!NOTE]
> Copyright © 2024 Aron Onak. All rights reserved.<br>
> Licensed under the [MIT](LICENSE) license.<br>
> If you have any feedback, please contact me at arononak@gmail.com
