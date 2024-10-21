# 🛠️ Installation

### 1. `pubspec.yaml`

```yml
dependencies:
  git_stamp: ^5.2.0
dependency_overrides:
  meta: ^1.1.5
```

### 2. `.gitignore`

> [!IMPORTANT]
> Add **git_stamp** to .gitignore.
> 
> ```echo -e "\n/lib/git_stamp/" >> .gitignore```.
> 
> If you add a **/git_stamp** folder for the repository and use the `FULL` version, the size of the repository will grow EXPONENTIALLY.

### 3. `analysis_options.yaml`

```yaml
analyzer:
  exclude:
    - lib/git_stamp/**
```

### 4. 📦 Integration - GitHub Actions

<details>
<summary>.github/workflows/build_and_deploy.yml</summary>

```yml
name: build_and_deploy

on:
  push:
    branches: [main]
  pull_request_target:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.22.2'
          channel: 'stable'
      - run: flutter --version
      - uses: actions/setup-java@v1
        with:
          java-version: "12.x"
      - run: flutter pub get
      - run: dart run git_stamp
      - run: flutter build web --release --web-renderer canvaskit
      - uses: actions/upload-artifact@master
        with:
          name: build
          path: build/web
  deploy:
    name: "Deploy"
    runs-on: ubuntu-latest
    needs: build
    steps:
      - uses: actions/checkout@v3
      - uses: actions/download-artifact@master
        with:
          name: build
          path: build/web
      - uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: "${{ secrets.GITHUB_TOKEN }}"
          firebaseServiceAccount: "${{ secrets.FIREBASE_SERVICE_ACCOUNT }}"
          projectId: xxx
          channelId: live
```

</details>

### 5. `README.md`

> [!WARNING]
> Add badge to your `README.md` 😄️
>
> [![Git Stamp](https://img.shields.io/badge/i%20love%20Git%20Stamp-ffff99?style=flat)](https://github.com/arononak/git_stamp)
>
>```
>[![Git Stamp](https://img.shields.io/badge/i%20love%20Git%20Stamp-ffff99?style=flat)](https://github.com/arononak/git_stamp)
>```
