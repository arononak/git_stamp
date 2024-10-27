import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:integration_test/integration_test.dart';

import 'package:example/git_stamp/git_stamp.dart';
import 'package:example/main.dart';
import 'physical_size.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('screenshot-commit_diff', (WidgetTester tester) async {
    tester.view.physicalSize = physicalSize;
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        home: GitStamp.detailsPage(
          monospaceFontFamily: GoogleFonts.sourceCodePro().fontFamily,
          commit: GitStamp.commitList.first,
        ),
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(useMaterial3: true),
        debugShowCheckedModeBanner: false,
      ),
    );
    await tester.pump(Duration(seconds: 5));
    await tester.pump(Duration(seconds: 5));
    await binding.takeScreenshot('screenshot_commit_diff');
  });

  testWidgets('screenshot-list', (WidgetTester tester) async {
    tester.view.physicalSize = physicalSize;
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        home: GitStamp.mainPage(),
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
      ),
    );
    await tester.pump(Duration(seconds: 2));
    await tester.pump(Duration(seconds: 2));
    await binding.takeScreenshot('screenshot_list');
  });

  testWidgets('screenshot-icon', (WidgetTester tester) async {
    tester.view.physicalSize = physicalSize;
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        home: SettingsPage(),
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(useMaterial3: true),
        debugShowCheckedModeBanner: false,
      ),
    );
    await tester.tap(find.byType(IconButton));
    await tester.pump(Duration(seconds: 2));
    await tester.pump(Duration(seconds: 2));
    await binding.takeScreenshot('screenshot_icon');
  });

  testWidgets('screenshot-files', (WidgetTester tester) async {
    tester.view.physicalSize = physicalSize;
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        home: GitStamp.mainPage(showFiles: true),
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
      ),
    );
    await tester.pump(Duration(seconds: 2));
    await tester.pump(Duration(seconds: 2));
    await binding.takeScreenshot('screenshot_files');
  });

  testWidgets('screenshot-details', (WidgetTester tester) async {
    tester.view.physicalSize = physicalSize;
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        home: GitStamp.mainPage(showDetails: true),
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(useMaterial3: true),
        debugShowCheckedModeBanner: false,
      ),
    );
    await tester.pump(Duration(seconds: 2));
    await tester.pump(Duration(seconds: 2));
    await binding.takeScreenshot('screenshot_details');
  });

  testWidgets('screenshot-git_config', (WidgetTester tester) async {
    tester.view.physicalSize = physicalSize;
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        home: GitStamp.mainPage(showDetails: true),
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
      ),
    );
    await tester.pump(Duration(seconds: 2));
    await tester.pump(Duration(seconds: 2));
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pump(Duration(seconds: 2));
    await tester.pump(Duration(seconds: 2));
    await binding.takeScreenshot('screenshot_git_config');
  });
}
