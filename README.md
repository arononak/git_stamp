# Git Stamp 🏷️

### 🚀 Build-Time Git History Integration in Your App

##### Have you ever struggled with pushing or merging changes into the automatic build system? Worry no more! Now, effortlessly track the specific commits that shaped the final build.

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

## Usage

```dart
IconButton(
  onPressed: () => showGitStampPage(context: context),
  icon: const Icon(Icons.book),
),
```

Explore the power of Git Stamp and enhance your development workflow! 🚀
