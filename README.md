[<img src="https://www.gov.pl/photo/f98cae42-2b90-4596-904c-752278f85606" height="100" align="right">](https://www.gov.pl/web/rolnictwo/produkt-polski1)

# Git Stamp 🐡

[![MIT License](https://img.shields.io/badge/License-MIT-orange.svg?labelColor=orange&color=white)](https://opensource.org/licenses)
[![Pub Package](https://img.shields.io/pub/v/git_stamp.svg?labelColor=purple&color=white)](https://pub.dev/packages/git_stamp)

## 🚀 Build-Time Git History Integration in Your Flutter App [MORE](https://medium.com/@arononak/git-stamp-a-new-tool-for-testing-flutter-applications-in-2024-bdf4f9c5f8ab)


##### Have you ever struggled with pushing or merging changes into the automatic build system? Worry no more! Now, effortlessly track the specific commits that shaped the final build.

# 🏞️ Preview

| Light                                                                            | Dark                                                                            |
|:--------------------------------------------------------------------------------:|:-------------------------------------------------------------------------------:|
| ![](https://github.com/arononak/git_stamp/blob/main/preview_light.png?raw=true)  | ![](https://github.com/arononak/git_stamp/blob/main/preview_dark.png?raw=true)  |

# 🛠️ Installation from source

`url_launcher` is required.

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

```
flutter pub run git_stamp:generate.dart
```

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
|       |-- branch_output.dart
|       |-- build_date_time_output.dart
|       |-- build_system_info_output.dart
|       |-- creation_date_output.dart
|       |-- diff_output.dart
|       |-- git_stamp_commit.dart
|       |-- git_stamp_page.dart
|       |-- json_output.dart
|       |-- repo_path_output.dart
|   |-- main.dart
|-- linux/
|-- macos/
|-- test/
|-- web/
|-- windows/
|-- pubspec.yaml
```

# 💻 Usage

```dart
if (isProd == false) ...[
  IconButton(
    onPressed: () => showGitStampPage(context: context),
    icon: const Icon(Icons.book),
  ),
],
```

# 🔧 Pre-Deployment Steps ([TODO](./TODO.md))

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
