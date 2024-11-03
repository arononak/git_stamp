# 💻 Usage

| BUILD TYPE                              | INTERNAL TESTING | PUBLIC STORES  | DATA AWAIT-LESS PROVIDER |
| --------------------------------------- | ---------------- | -------------- | ------------------------ |
| FULL                                    | YES              | ONLY ENCRYPTED | NO                       |
| LITE                                    | YES              | ONLY ENCRYPTED | NO                       |
| ICON                                    | YES              | YES            | NO                       |
| [CUSTOM](./lib/src/git_stamp_node.dart) | YES              | YES            | YES                      |

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
