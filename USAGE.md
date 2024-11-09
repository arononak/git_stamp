# 💻 Usage

| BUILD TYPE                              | DEVELOPMENT | INTERNAL TESTING | PUBLIC STORES  | DATA AWAIT-LESS PROVIDER |
| --------------------------------------- | ----------- | ---------------- | -------------- | ------------------------ |
| FULL                                    | YES         | YES              | ONLY ENCRYPTED | YES                      |
| LITE                                    | YES         | YES              | ONLY ENCRYPTED | YES                      |
| ICON                                    | YES         | YES              | YES            | YES                      |
| [CUSTOM](./lib/src/git_stamp_node.dart) | YES         | YES              | YES            | YES                      |

### 1. GitStampListTile

```dart
if (kDebugMode) ...[
  GitStamp.listTile(
    context: context,
    monospaceFontFamily: GoogleFonts.spaceMono().fontFamily,
  ),
],
```

### 2. GitStampIcon
```dart
if (isProd == false) ...[
  GitStamp.icon(),
],
```

### 3. Custom buttom
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
