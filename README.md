[<img src="https://www.gov.pl/photo/f98cae42-2b90-4596-904c-752278f85606" height="100" align="right">](https://www.gov.pl/web/rolnictwo/produkt-polski1)

# Git Stamp 🏷️

[![MIT License](https://img.shields.io/badge/License-MIT-orange.svg?labelColor=orange&color=white)](https://opensource.org/licenses)

### 🚀 Build-Time Git History Integration in Your App

##### Have you ever struggled with pushing or merging changes into the automatic build system? Worry no more! Now, effortlessly track the specific commits that shaped the final build.

## 🏞️ Preview

| Light                                                                           | Dark                                                                           |
|:-------------------------------------------------------------------------------:|:------------------------------------------------------------------------------:|
| ![](https://github.com/arononak/git_stamp/blob/main/preview_light.png?raw=true) | ![](https://github.com/arononak/git_stamp/blob/main/preview_dark.png?raw=true) |

## 🛠️ Installation

```yaml
dev_dependencies:
  git_stamp:
    git:
      url: https://github.com/arononak/git_stamp
      ref: main
```

## 🏗️ Generating Files

```
flutter pub run git_stamp:generate.dart
```

> [!CAUTION]
> Generating requires the use of the `git` command-line interface (CLI).

![](https://github.com/arononak/git_stamp/blob/main/files.png?raw=true)

## 💻 Usage

```dart
if (isProd == false) ...[
  IconButton(
    onPressed: () => showGitStampPage(context: context),
    icon: const Icon(Icons.book),
  ),
],
```

Explore the power of Git Stamp and enhance your development workflow! 🚀
