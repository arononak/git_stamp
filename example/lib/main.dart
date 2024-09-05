import 'package:example/git_stamp/src/ui/git_stamp_icon.dart';
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
      home: MainPage(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
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
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
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
        actions: [
          GitStampIcon(),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder<int>(
            future: LicenseRegistry.licenses.length,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return ListTile(
                title: Text('Open Source Licenses'),
                subtitle: Text(snapshot.data?.toString() ?? 'Loading'),
                leading: const Icon(Icons.gavel),
                onTap: () => GitStamp.showLicensePage(context: context),
              );
            },
          ),
          ListTile(
            title: Text('Version'),
            subtitle: Text(GitStamp.appVersion),
            leading: const Icon(Icons.numbers),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Git Stamp Page'),
            subtitle: Text(GitStamp.sha),
            leading: const Icon(Icons.commit),
            onTap: () => showGitStampPage(context: context),
          ),
        ],
      ),
    );
  }
}
