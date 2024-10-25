import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';

import 'git_stamp/git_stamp.dart';

String? get monospaceFontFamily {
  /// Don't forget about the font's open source license terms in Your App:
  /// https://pub.dev/packages/google_fonts#licensing-fonts
  return kIsWeb ? GoogleFonts.sourceCodePro().fontFamily : 'SourceCodePro';
}

void main() {
  /// Copyright's :O
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  runApp(ExampleApp());
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
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
            onPressed: () => navigateToSettings(context),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Example app',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToSettings(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  static void navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsPage()),
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
          GitStamp.icon(),
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
          GitStamp.listTile(
            context: context,
            monospaceFontFamily: monospaceFontFamily,
          ),
        ],
      ),
    );
  }
}
