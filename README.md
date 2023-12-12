# Git Stamp 🏷️

[![MIT License](https://img.shields.io/badge/License-MIT-orange.svg?labelColor=orange&color=white)](https://opensource.org/licenses)

### 🚀 Build-Time Git History Integration in Your App

##### Have you ever struggled with pushing or merging changes into the automatic build system? Worry no more! Now, effortlessly track the specific commits that shaped the final build.

## Preview

![](https://github.com/arononak/git_stamp/blob/main/preview.png?raw=true)

## Installation

```yaml
dev_dependencies:
  git_stamp:
    git:
      url: https://github.com/arononak/git_stamp
      ref: main
```

## Generating Files

```
flutter pub run git_stamp:generate.dart
```

![](https://github.com/arononak/git_stamp/blob/main/files.png?raw=true)

## Usage

```dart
IconButton(
  onPressed: () => showGitStampPage(context: context),
  icon: const Icon(Icons.book),
),
```

Explore the power of Git Stamp and enhance your development workflow! 🚀
