[<img src="https://www.gov.pl/photo/f98cae42-2b90-4596-904c-752278f85606" height="100" align="right">](https://www.gov.pl/web/rolnictwo/produkt-polski1)

# Git Stamp 🏷

Provides information about the project's Git repository and more. From simple information such as `build-branch` to a screen with Flutter code with commits and change history.

[![Latest Tag](https://img.shields.io/github/v/tag/arononak/git_stamp?style=flat&logo=github&labelColor=black&color=white)](https://github.com/arononak/git_stamp/tags)
[![GitHub stars](https://img.shields.io/github/stars/arononak/git_stamp.svg?style=flat&label=Star&labelColor=black&color=white)](https://github.com/arononak/git_stamp/)
[![Commits](https://img.shields.io/github/commit-activity/m/arononak/git_stamp?style=flat&labelColor=black&color=white)](https://github.com/arononak/git_stamp/graphs/contributors)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/arononak/git_stamp/.github%2Fworkflows%2Fpublish.yml?style=flat&labelColor=black&color=white)

[![Pub Package](https://img.shields.io/pub/v/git_stamp.svg?style=flat&logo=dart&labelColor=fuchsia&color=white)](https://pub.dev/packages/git_stamp)
[![Likes](https://img.shields.io/pub/likes/git_stamp?style=flat&labelColor=fuchsia&color=white)](https://pub.dev/packages/git_stamp)
[![package publisher](https://img.shields.io/pub/publisher/git_stamp?style=flat&labelColor=fuchsia&color=white)](https://pub.dev/packages/git_stamp/publisher)

The motivation was **Minecraft** with information like this, which is being built for multiple platforms: PC, Android, iOS, Xbox, PlayStation and much more.

```
Version: v1.20.81
Build: 24130126
Branch: r/20_u8
SHA: a9081c5429038dcf3f26269f7351d89f
```

## Table of contents
  
- [Git Stamp 🏷](#git-stamp-)
      - [Build-Time Git Integration in Your Flutter App](#build-time-git-history-integration-in-your-flutter-app)
  - [Table of contents](#table-of-contents)
  - [🏞️ Preview](#️-preview)
  - [🕯️ Mechanism](#️-mechanism)
  - [🛠️ Installation](#️-installation)
  - [🏗️ Generating](#️-generating)
  - [💻 Usage](#-usage)
      - [Default usage:](#default-usage)
      - [Advanced usage:](#advanced-usage)
  - [🔧 Git Stamp - Development](#-git-stamp-development)
  - [📝 License](#-license)

## 🏞️ Preview

|                                      Light                                      |                                      Dark                                      |
| :-----------------------------------------------------------------------------: | :----------------------------------------------------------------------------: |
| ![](https://github.com/arononak/git_stamp/blob/main/preview_light.png?raw=true) | ![](https://github.com/arononak/git_stamp/blob/main/preview_dark.png?raw=true) |

## 🕯️ Mechanism

```mermaid
graph TD
    CODE((SOURCE CODE))-->SYNC(flutter pub get)
    SYNC-->BUILD(flutter build ...)

    subgraph "App"
        CODE
        PUB
        PUB((PACKAGES))-->CODE
    end

    subgraph "Git Stamp"
        GIT_CLI(GIT CLI)-->GENERATOR
        DART_CLI(DART CLI)-->GENERATOR
        FLUTTER_CLI(FLUTTER CLI)-->GENERATOR
    end

    subgraph "Git Stamp CLI"
        GENERATE
        ADD
    end

    GENERATOR((GENERATOR))-->ADD(~$ dart pub add git_stamp)
    ADD-->|Add package|PUB

    GENERATOR-->GENERATE(~$ dart run git_stamp)
    GENERATE-->|Create ./git_stamp directory with .dart files|CODE
```

## 🛠️ Installation

<!-- https://snappify.com/ -->
![](https://github.com/arononak/git_stamp/blob/main/generating.png?raw=true)

If you use `url_launcher` generation, add the package to `pubspec.yaml`:

```yaml
dependencies:
  url_launcher: ^6.2.3
dev_dependencies:
  git_stamp:
    git:
      url: https://github.com/arononak/git_stamp
      ref: main
```

> [!WARNING]
> Add badge to your `README.md`
>
> [![Git Stamp](https://img.shields.io/badge/i%20love%20Git%20Stamp-ffff99?style=flat)](https://github.com/arononak/git_stamp)
>
>```
>[![Git Stamp](https://img.shields.io/badge/i%20love%20Git%20Stamp-ffff99?style=flat)](https://github.com/arononak/git_stamp)
>```

> [!IMPORTANT]
> Add **git_stamp** to .gitignore.
> 
> ```echo "lib/git_stamp/" >> .gitignore```.

## 🏗️ Generating

| CLI Command                                                       | Build type | Use ```url_launcher``` | Generate Flutter UI Files |
| ----------------------------------------------------------------- | ---------- | ---------------------- | ------------------------- |
| `dart run git_stamp`                                              | LITE       | DISABLED               | YES                       |
| `dart run git_stamp --build-type full --gen-url-launcher enabled` | FULL       | ENABLED                | YES                       |
| `dart run git_stamp --gen-only build-branch,build-date-time`      | CUSTOM     | DISABLED               | NO                        |

> [!CAUTION]
> Generating requires the use of the `git` command-line interface (CLI).

| `gen-only` parameters |
| --------------------- |
| `commit-list`         |
| `diff-list`           |
| `repo-creation-date`  |
| `build-branch`        |
| `build-date-time`     |
| `build-system-info`   |
| `repo-path`           |
| `observed-files-list` |
| `app-version`         |

> [!IMPORTANT]
> If you use Github Action, you only get a single commit because GitHub Actions by default only retrieves the latest version (single commit) and does not include the full history of the repository. This is normal behavior to optimize the build process and improve performance, especially for large repositories. Try configuring github actions or generating Git Stamp files before `git push`.

## 💻 Usage

<!-- https://carbon.now.sh/ -->
![https://github.com/arononak/git_stamp](https://github.com/arononak/git_stamp/blob/main/usage.png?raw=true)

#### Default usage:

```dart
if (isProd == false) ...[
  IconButton(
    onPressed: () => showGitStampPage(context: context),
    icon: const Icon(Icons.book),
  ),
],
```

#### Advanced usage:

Central **GitStamp** node:

```dart
class GitStamp {
   static List<GitStampCommit> commitList
   static GitStampCommit latestCommit

   static const Map<String, String> diffList

   static const String buildBranch
   static const String buildDateTime
   static const String buildSystemInfo
   static const String repoCreationDate
   static const String repoPath
   static const String observedFilesList

   static const bool isLiteVersion
}
```

Example usage:

```dart
import 'git_stamp.dart';

Text('Version: v1.2.3'),
Text('Build: 1234'),
Text('Branch: ${GitStamp.buildBranch}'),
Text('SHA: ${GitStamp.latestCommit.hash}'),
```

## [🔧 Git Stamp - Development](./TODO.md)

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
