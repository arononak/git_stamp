# [Git Stamp 🏷](TODO.md) Stamp Every App Build!

Advanced await-less **information provider** & **development tool**.

[![Latest Tag](https://img.shields.io/github/v/tag/arononak/git_stamp?style=flat&logo=github&labelColor=black&color=white)](https://github.com/arononak/git_stamp/tags)
[![GitHub stars](https://img.shields.io/github/stars/arononak/git_stamp.svg?style=flat&logo=github&label=Star&labelColor=black&color=white)](https://github.com/arononak/git_stamp/)
[![Commits](https://img.shields.io/github/commit-activity/m/arononak/git_stamp?style=flat&logo=github&labelColor=black&color=white)](https://github.com/arononak/git_stamp/graphs/contributors)
![Dev](https://img.shields.io/github/actions/workflow/status/arononak/git_stamp/.github%2Fworkflows%2Fdev.yml?style=flat&logo=github&labelColor=black&color=white&label=dev)
![Prod](https://img.shields.io/github/actions/workflow/status/arononak/git_stamp/.github%2Fworkflows%2Fprod.yml?style=flat&logo=github&labelColor=black&color=white&label=prod)

[![Pub Package](https://img.shields.io/pub/v/git_stamp.svg?style=flat&logo=dart&labelColor=289ACF&color=white)](https://pub.dev/packages/git_stamp)
[![Likes](https://img.shields.io/pub/likes/git_stamp?style=flat&logo=dart&labelColor=289ACF&color=white)](https://pub.dev/packages/git_stamp)
[![package publisher](https://img.shields.io/pub/publisher/git_stamp?style=flat&logo=dart&labelColor=289ACF&color=white)](https://pub.dev/packages/git_stamp/publisher)

[<img src="https://raw.githubusercontent.com/arononak/git_stamp/refs/heads/main/images/aroncode.png" height="200" align="right">](https://pub.dev/packages/git_stamp)

- [Git Stamp 🏷 Stamp Every App Build!](#git-stamp--stamp-every-app-build)
  - [🏞️ Preview](#️-preview)
  - [📑️ About (Changelog)](#️-about-changelog)
    - [Why Git Stamp?](#why-git-stamp)
    - [Inspiration](#inspiration)
  - [🛠️ Installation](#️-installation)
  - [🏗️ Generating](#️-generating)
  - [💻 Usage](#-usage)
  - [🔥Contributors](#contributors)
  - [💰 Sponsors](#-sponsors)
  - [📝 License](#-license)

## [🏞️ Preview](PREVIEW.md)

<p align="center">
  <a href="https://gitstamp.web.app"><b>Example</b></a> •
  <a href="https://gitstamp-encrypted.web.app"><b>Example Encrypted</b></a> •
  <a href="https://arononak.github.io/git_stamp/doc/api/index.html"><b>API Documentation</b></a>
</p>

<table>
  <tr>
    <td><img src="https://github.com/arononak/git_stamp/blob/main/images/git_config.png?raw=true" alt="Git Config" style="width: 100%;"></td>
    <td><img src="https://github.com/arononak/git_stamp/blob/main/images/details.png?raw=true" alt="Details" style="width: 100%;"></td>
  </tr>
</table>

## 📑️ About ([Changelog](CHANGELOG.md))

[<img src="https://www.gov.pl/photo/f98cae42-2b90-4596-904c-752278f85606" height="100" align="right">](https://www.gov.pl/web/rolnictwo/produkt-polski1)

### Why Git Stamp?

When working with **Flutter** and **Git**, especially in a team environment, human errors such as forgetting to run git pull can lead to issues during branch merges. Git Stamp helps address these problems by offering:
- **Build Date, SHA & Branch Information** - Git Stamp allows you to precisely determine which version of the application was deployed. This is especially useful during debugging or verifying issues, as application versions and build numbers are not always updated correctly.
- **Debugging and Troubleshooting** - Knowing the build date and exact code version (SHA) makes it much easier for the development team to identify the problematic code when users report bugs.
- **Avoiding Lost Changes in Teamwork** - It allows you to quickly see which commits made it into the final version of the application, helping to prevent missing changes due to overlooked `git pull` commands.
- **Caching Issues in the Web Version** - Even if the latest version is deployed, users may still see an older version due to caching. Git Stamp helps identify whether the deployed version or an outdated one was loaded.

<details>
<summary>Mechanism 🕯️</summary>

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

</details>

### Inspiration

The main inspiration was **Minecraft** with information like this:
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

## [🛠️ Installation](INSTALLATION.md)

```yml
dependencies:
  git_stamp: ^5.2.0
dependency_overrides:
  meta: ^1.1.5
```

## [🏗️ Generating](GENERATING.md)

```cli
dart run git_stamp --build-type full
```

## [💻 Usage](USAGE.md)

```dart
if (kDebugMode) ...[
  GitStamp.listTile(
    context: context,
    monospaceFontFamily: GoogleFonts.spaceMono().fontFamily,
  ),
],
```

## 🔥Contributors

<a href="https://github.com/arononak/git_stamp/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=arononak/git_stamp" />
</a>

## 💰 Sponsors

|                         [Aron Code](https://aroncode.com)                         |
| :-------------------------------------------------------------------------------: |
| ![](https://github.com/arononak/git_stamp/blob/main/images/aroncode.png?raw=true) |

## 📝 License

> [!NOTE]
> Copyright © 2024 Aron Onak. All rights reserved.<br>
> Licensed under the [MIT](LICENSE) license.<br>
> If you have any feedback, please contact me at arononak@gmail.com
