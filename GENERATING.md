# 🏗️ Generating

`dart run git_stamp --build-type full --encrypt`

### 1. Examples

| Build type | Pure Dart | Can encrypt | CLI Command                                                  |
| ---------- | --------- | ----------- | ------------------------------------------------------------ |
| FULL       | NO        | YES         | `dart run git_stamp --build-type full --encrypt`             |
| LITE       | NO        | YES         | `dart run git_stamp --adding-packages disabled`              |
| ICON       | NO        | NO          | `dart run git_stamp --build-type icon`                       |
| CUSTOM     | YES       | NO          | `dart run git_stamp --gen-only build-branch,build-date-time` |

> [!NOTE]
> To optimize the generation you can disable adding packages to the project for LITE & FULL versions by adding a flag in CLI `--adding-packages disabled` .

### 2. [Benchmarks](./BENCHMARK.md)

```dart run git_stamp --benchmark```

### 3. Tip

> [!CAUTION]
> Generating requires the use of the `git` command-line interface (CLI).

### 4. Custom `gen-only` parameters 

| #   | Parameter           |
| --- | ------------------- |
| 1   | commit-list         |
| 2   | diff-list           |
| 3   | diff-stat-list      |
| 4   | repo-creation-date  |
| 5   | build-branch        |
| 6   | build-date-time     |
| 7   | build-system-info   |
| 8   | build-machine       |
| 9   | repo-path           |
| 10  | observed-files-list |
| 11  | app-version         |
| 12  | app-build           |
| 13  | app-name            |
| 14  | git-config          |
| 15  | git-remote          |
| 16  | git-remote-list     |
| 17  | git-tag-list        |
| 18  | git-branch-list     |