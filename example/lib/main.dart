import 'package:example/git_stamp/git_stamp_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ExampleApp());
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExamplePage(),
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
    );
  }
}

class ExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example Page'),
        actions: [
          IconButton(
            onPressed: () => showGitStampPage(context: context),
            icon: const Icon(Icons.navigate_next),
          ),
        ],
      ),
      body: Center(child: Text('Aron Soft sp. z o.o.')),
    );
  }
}
