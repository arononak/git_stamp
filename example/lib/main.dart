import 'package:example/git_stamp/git_stamp_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
      themeMode: ThemeMode.system,
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
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
            onTap: () => showLicensePage(context: context),
          ),
          ListTile(
            title: Text('Version: 1.0.0'),
            leading: const Icon(Icons.info),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('1.0.0'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          if (kDebugMode) ...[
            ListTile(
              title: const Text('Git Stamp'),
              subtitle: const Text('For debugging only'),
              leading: const Icon(Icons.commit),
              onTap: () => showGitStampPage(context: context),
            ),
          ],
        ],
      ),
    );
  }
}
