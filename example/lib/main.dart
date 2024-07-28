import 'package:example/git_stamp/src/ui/git_stamp_icon.dart';
import 'package:example/git_stamp/src/ui/git_stamp_license_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'git_stamp/git_stamp.dart';

void main() {
  runApp(ExampleApp());
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.dark,
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example App'),
        actions: [
          GitStampIcon(),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Example app'),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings Page'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Open Source Licenses'),
            leading: const Icon(Icons.gavel),
            onTap: () => showGitStampLicensePage(context: context),
          ),
          ListTile(
            title: Text('Version: ${GitStamp.appVersion}'),
            leading: const Icon(Icons.numbers),
            onTap: () {},
          ),
          if (kDebugMode) ...[
            ListTile(
              title: const Text('Git Stamp Page'),
              subtitle: Text(GitStamp.latestCommit.hash),
              leading: const Icon(Icons.commit),
              onTap: () => showGitStampPage(context: context),
            ),
          ],
        ],
      ),
    );
  }
}
