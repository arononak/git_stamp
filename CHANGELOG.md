# ROADMAP

| 🆕 **Version** | 🗓️ **Date**         | 📝 **Change Description**  |
| ------------- | ------------------ | ---------------------------- |
| Version 7     | Someday it will be | 🧩 Pure Dart - 2 packages    |
| Version 6     | Someday it will be | 📦 JSON data export          |
| Version 5     | 07.10.2024         | 🔐 Data encription           |
| Version 4     | 24.07.2024         | 🌟 New `icon` build-type     |
| Version 3     | 30.06.2024         | 🔧 New `gen-only` build-type |
| Version 2     | 10.04.2024         | 🛠️ Commit diff               |
| Version 1     | 11.12.2023         | 🚀 First version             |

# CHANGELOG

## 5.4.0

* **Tag module** - Added date field
* Added `--help` flag descriptions
* GitStampPage - Added tags to list & refactor
* GitStampPage - Fixed async warnings
* Package /lib folder refactored to /lib/src
* Fixed encrypted git stamp node
* Fixed 'ecrypted' -> 'eNcrypted' typo

<details>
<summary>Image</summary>
<p><img src="https://github.com/arononak/git_stamp/blob/main/changelog/5.4.0.png?raw=true" alt="Image"></p>
</details>

## 5.3.1

* DOCs update

## 5.3.0

* Removed **Pure Dart** for a `custom` build-type
* Added reflog module
* GitStampPage - fixed bottom sheet ScrollViews
* Extracted All UI files to package `/lib` folder

<details>
<summary>Image</summary>
<p><img src="https://github.com/arononak/git_stamp/blob/main/changelog/5.3.0.png?raw=true" alt="Image"></p>
</details>

## 5.2.0

* Added **branch module**
* Structure refactor
* Added `--debug-compile-key` flag & fixed decrypt modal
* Added --benchmark flag

<details>
<summary>Image</summary>
<p><img src="https://github.com/arononak/git_stamp/blob/main/changelog/5.2.0.png?raw=true" alt="Image"></p>
</details>

## 5.1.0

* Added **tag module**
* Added meta package & refactor
* Added CLI flags `--adding-packages disabled`, `--gen-only-options`, `--gen-only-all`
* GitStampPage - Added commit count per day
* GitStampPage - new details icons positions
* Fixed encrypted stubs
* New logo

<details>
<summary>Image</summary>
<p><img src="https://github.com/arononak/git_stamp/blob/main/changelog/5.1.0.png?raw=true" alt="Image"></p>
</details>

## 5.0.0

* Added **encryption module**

<details>
<summary>Image</summary>
<!-- https://snappify.com/ -->
<p><img src="https://github.com/arononak/git_stamp/blob/main/changelog/5.0.0.png?raw=true" alt="Image"></p>
</details>

## 4.11.0

* Added **GitCountObjects module**
* Icon build type optimization
* Fixed SnackBars
* GitStampPage - Commit List Optimization
* GitStampPage - Filter - Added commit count & current selection
* GitStampPage - Added 2 commit item types
* GitStampDetailsPage - AppBar - Added text size

<details>
<summary>Image</summary>
<p><img src="https://github.com/arononak/git_stamp/blob/main/changelog/4.11.0.png?raw=true" alt="Image"></p>
</details>

## 4.10.0

* **Fixed icon build type**
* New GitStampDetailsPage
* New transparent SnackBars
* GitStampPage - refactor
* GitStampIcon - refactor

<details>
<summary>Image</summary>
<p><img src="https://github.com/arononak/git_stamp/blob/main/changelog/4.10.0.png?raw=true" alt="Image"></p>
</details>

## 4.9.0 (Not working)

* New GitStampIcon
* New GitStampLogger
* New orange SnackBar
* GitStampPage - Fixed commit item style
* GitStampDetailsPage - Added diff line colors

<details>
<summary>Image</summary>
<p><img src="https://github.com/arononak/git_stamp/blob/main/changelog/4.9.0.png?raw=true" alt="Image"></p>
</details>

## 4.8.0

* Added **`GitConfigList` module**
* Generator - Added files count
* Generator - Fixed logo colors
* SnackBar's Fixes
* GitStampPage - Fixed commit item responsiveness
* GitStampPage & GitStampDetailsPage - Fixed background colors

<details>
<summary>Image</summary>
<p><img src="https://github.com/arononak/git_stamp/blob/main/changelog/4.8.0.png?raw=true" alt="Image"></p>
</details>

## 4.7.0

* Added **`GitRemote` module**
* Added **`DiffStat` module**
* Update `flutter doctor` -> `flutter doctor --verbose`
* GitStampPage - New design
* GitStampPage - Improved responsiveness
* GitStampPage - Changed commit list texts to single line
* GitStampPage - Added `monospaceFontFamily` parameter
* GitStampPage - Added arrow animation
* GitStampPage - refactor

<details>
<summary>Image</summary>
<p><img src="https://github.com/arononak/git_stamp/blob/main/changelog/4.7.0.png?raw=true" alt="Image"></p>
</details>

## 4.6.0

* Added GitStamp.buildMachine object
* Added full flutter-doctor SnackBar

<details>
<summary>Image</summary>
<p><img src="https://github.com/arononak/git_stamp/blob/main/changelog/4.6.0.png?raw=true" alt="Image"></p>
</details>

## 4.5.0

* Generator OOP refactor
* GitStampPage refactor
* Changed diff_list.dart type Map -> String
* Changed GitStamp.observedFilesList into 3 fields
* Gernerator - Added Size of generated files
* Added GitStamp.commitCount field
* New GitStampIcon style
* Added observed files count label
* RepoDetails - Added GitStamp section
* GitStampPage - Changed AppBar icons positions
* GitStampPage - Commit list fixes

<details>
<summary>Image</summary>
<p><img src="https://github.com/arononak/git_stamp/blob/main/changelog/4.5.0.png?raw=true" alt="Image"></p>
</details>

## 4.4.0

* Added interpolate function `GitStamp.showLicensePage`
* Added **`git config` module**
* Refactor

<details>
<summary>Image</summary>
<p><img src="https://github.com/arononak/git_stamp/blob/main/changelog/4.4.0.png?raw=true" alt="Image"></p>
</details>

## 4.3.0

* New GitStampIcon style
* Added `GitStamp.sha`
* Generator new logs & refactor
* Fixed generation build version for no build number in pubspec.yaml

<details>
<summary>Image</summary>
<p><img src="https://github.com/arononak/git_stamp/blob/main/changelog/4.3.0.png?raw=true" alt="Image"></p>
</details>

## 4.2.0

* Added time zones
* Fixed diff modal for LITE version
* GitStampPage refactor
* Inverted CHANGELOGs positions
* Separated GitStamp class into export GitStamp + data GitStampNode
* Separated appVersion into appVersion + appBuild
* Fixed generation diff-list for custom build-type
* New logger
* Added CLI --version flag and GitStamp tool version during build

<details>
<summary>Image</summary>
<p><img src="https://github.com/arononak/git_stamp/blob/main/changelog/4.2.0.png?raw=true" alt="Image"></p>
</details>

## 4.1.2

* Fixed GitStampLicenseIcon constructor

## 4.1.1

* Modified `showGitStampLicensePage` parameters
* Added `GitStampLicenseIcon`

## 4.1.0

* Added `app-name`
* Added showGitStampLicensePage method with `app-name` & `app-version`

<details>
<summary>Image</summary>
<p><img src="https://github.com/arononak/git_stamp/blob/main/changelog/4.1.0.png?raw=true" alt="Image"></p>
</details>

## 4.0.0

* Added new `ICON` build-type
* Removed configurable `url_launcher` package
* Added `aron_gradient_line` package for `LITE` and `FULL` build-type
* Generator adding packages to project pubpsec.yaml

<details>
<summary>Image</summary>
<p><img src="https://github.com/arononak/git_stamp/blob/main/changelog/4.0.0.png?raw=true" alt="Image"></p>
</details>

## 3.2.0

* Added GitStampIcon with tip information

<details>
<summary>Image</summary>
<p><img src="https://github.com/arononak/git_stamp/blob/main/changelog/3.2.0.png?raw=true" alt="Image"></p>
</details>

## 3.1.0

* Added `app-version`
* File structure refactor
* pubspec.yaml - update description

<details>
<summary>Image</summary>
<!-- https://snappify.com/ -->
<p><img src="https://github.com/arononak/git_stamp/blob/main/changelog/3.1.0.png?raw=true" alt="Image"></p>
</details>

## 3.0.2

* Removed empty lib/git_stamp.dart

## 3.0.1

* Added empty file lib/git_stamp.dart

## 3.0.0

* New customizable generator

<details>
<summary>Image</summary>
<!-- https://snappify.com/ -->
<p><img src="https://github.com/arononak/git_stamp/blob/main/changelog/3.0.0.png?raw=true" alt="Image"></p>
</details>

## 2.11.0

* Import refactor
* Generator - Added ASCII logo-text
* GitStampPage - Font refactor

## 2.10.0

* GitStampPage - Added filter by author

## 2.9.0

* New OOP generator
* Added Repository Files list

## 2.8.0

* Added latest commit access from GitStamp node

## 2.7.0

* Added GitStamp central data node

## 2.6.0

* Added advanced CLI

## 2.5.0

* GitStampPage - Added commit hash & commit title to commit modal

## 2.4.0

* Added ability to generate code without url_launcher package

## 2.3.0

* GitStampPage - Added commits count

## 2.2.0

* Added 2 types of file generation: LITE & FULL

## 2.1.0

* New generation files structure & refactor
* Added GitStampDetailsPage

## 2.0.0

* GitStampPage - Added commit changes

## 1.16.0

* GitStampPage - RepoDetailsModal - Next new design

## 1.15.0

* GitStampPage - RepoDetailsModal - New design

## 1.14.0

* GitStampPage - New MoreModal

## 1.13.0

* GitStampPage - New details icon
* Refactor

## 1.12.0

* GitStampPage - Added repo creation date

## 1.11.1

* Updated pubspec.yaml

## 1.11.0

* GitStampPage - New date header style

## 1.10.0

* GitStampPage - Added grouping by day

## 1.9.0

* GitStampPage - new build system text

## 1.8.0

* GitStampPage - Added about modal

## 1.7.0

* GitStampPage - Added build system info label

## 1.6.1

* Dart code format

## 1.6.0

* GitStampPage - Added commit count by author

## 1.5.1

* GitStampPage - Added opening author email

## 1.5.0

* GitStampPage - Added build date time & new design

## 1.4.1

* GitStampPage - Fixed texts

## 1.4.0

* GitStampPage - Build branch

## 1.3.0

* GitStampPage - Number of commits - new design

## 1.2.0

* GitStampPage - Number of commits

## 1.1.0

* New card stylegit lo

## 1.0.1

* DOCS update

## 1.0.0

* First version
