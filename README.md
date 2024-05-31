[<img src="https://www.gov.pl/photo/f98cae42-2b90-4596-904c-752278f85606" height="100" align="right">](https://www.gov.pl/web/rolnictwo/produkt-polski1)

# Git Stamp 🏷

### Build-Time Git History Integration in Your Flutter App

[![Latest Tag](https://img.shields.io/github/v/tag/arononak/git_stamp?labelColor=orange&color=white)](https://github.com/arononak/git_stamp/tags)

[![Pub Package](https://img.shields.io/pub/v/git_stamp.svg?labelColor=purple&color=white)](https://pub.dev/packages/git_stamp)

[![Commits](https://img.shields.io/github/commit-activity/m/arononak/git_stamp?labelColor=blue&color=white)](https://github.com/arononak/git_stamp/graphs/contributors)

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/arononak/git_stamp/.github%2Fworkflows%2Fpublish.yml?labelColor=yellow&color=white)

# 🏞️ Preview

| Light                                                                            | Dark                                                                            |
|:--------------------------------------------------------------------------------:|:-------------------------------------------------------------------------------:|
| ![](https://github.com/arononak/git_stamp/blob/main/preview_light.png?raw=true)  | ![](https://github.com/arononak/git_stamp/blob/main/preview_dark.png?raw=true)  |

# 🛠️ Installation

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

# 🏗️ Generating Files

| CLI Command                                                  | Build type | Use ```url_launcher``` |
|--------------------------------------------------------------|------------|------------------------|
| `dart run git_stamp`                                         | LITE       | DISABLED               |
| `dart run git_stamp --buildtype full --url_launcher enabled` | FULL       | ENABLED                |

> [!CAUTION]
> Generating requires the use of the `git` command-line interface (CLI).

> [!IMPORTANT]  
> If you use Github Action, you only get a single commit because GitHub Actions by default only retrieves the latest version (single commit) and does not include the full history of the repository. This is normal behavior to optimize the build process and improve performance, especially for large repositories. Try configuring github actions or generating Git Stamp files before `git push`.

```
|-- android/
|-- assets/
|-- build/
|-- ios/
|-- lib/
|   |-- git_stamp/
|       |-- data/
|           |-- branch_output.dart
|           |-- build_date_time_output.dart
|           |-- build_system_info_output.dart
|           |-- creation_date_output.dart
|           |-- diff_output.dart
|           |-- generated_version.dart
|           |-- json_output.dart
|           |-- repo_path_output.dart
|       |-- git_stamp_commit.dart
|       |-- git_stamp_details_page.dart
|       |-- git_stamp_launcher.dart
|       |-- git_stamp_page.dart
|       |-- git_stamp_utils.dart
|       |-- git_stamp.dart
|   |-- main.dart
|-- linux/
|-- macos/
|-- test/
|-- web/
|-- windows/
|-- pubspec.yaml
```

# 💻 Usage

### Default usage:

```dart
if (isProd == false) ...[
  IconButton(
    onPressed: () => showGitStampPage(context: context),
    icon: const Icon(Icons.book),
  ),
],
```

![](https://github.com/arononak/git_stamp/blob/main/development.png?raw=true)

### Advanced usage:

Central GitStamp node:

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
}
```

Example usage:

```dart
import 'git_stamp.dart';

Text(GitStamp.buildDateTime),
```

# 🔧 Development - Git Stamp ([TODO](./TODO.md))

| Step                     | Description                                                     |
|--------------------------|-----------------------------------------------------------------|
| 🔧 Run `pana` command    | Check 140/140 points                                            |
| 📸 New SS                | Create a new screenshots                                        |
| 🔍 Generated file names  | In README.md                                                    |
| 🏷️ New tag and push      | Deploy every **Wednesday !**                                    |

# 📝 License

> [!NOTE]
> Copyright © 2024 Aron Onak. All rights reserved.<br>
> Licensed under the [MIT](LICENSE) license.<br>
> If you have any feedback, please contact me at arononak@gmail.com
