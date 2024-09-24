import 'package:example/git_stamp/git_stamp.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:integration_test/integration_test.dart';

import 'physical_size.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('screenshot-list', (WidgetTester tester) async {
    tester.view.physicalSize = physicalSize;
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        home: GitStampPage(),
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
      ),
    );
    await tester.pump(Duration(seconds: 1));
    await tester.pump(Duration(seconds: 1));
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
    final iconButtonFinder = find.byType(IconButton);
    await tester.tap(iconButtonFinder);
    await tester.pump(Duration(seconds: 1));
    await tester.pump(Duration(seconds: 1));
    await binding.takeScreenshot('screenshot_icon');
  });

  testWidgets('screenshot-files', (WidgetTester tester) async {
    tester.view.physicalSize = physicalSize;
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        home: GitStampPage(showFiles: true),
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
      ),
    );
    await tester.pump(Duration(seconds: 1));
    await tester.pump(Duration(seconds: 1));
    await binding.takeScreenshot('screenshot_files');
  });

  testWidgets('screenshot-details', (WidgetTester tester) async {
    tester.view.physicalSize = physicalSize;
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        home: GitStampPage(showDetails: true),
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(useMaterial3: true),
        debugShowCheckedModeBanner: false,
      ),
    );
    await tester.pump(Duration(seconds: 1));
    await tester.pump(Duration(seconds: 1));
    await binding.takeScreenshot('screenshot_details');
  });

  testWidgets('screenshot-git_config', (WidgetTester tester) async {
    tester.view.physicalSize = physicalSize;
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        home: GitStampPage(showDetails: true),
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
      ),
    );
    await tester.pump(Duration(seconds: 1));
    await tester.pump(Duration(seconds: 1));
    final iconButtonFinder = find.byIcon(Icons.settings);
    await tester.tap(iconButtonFinder);
    await tester.pump(Duration(seconds: 1));
    await tester.pump(Duration(seconds: 1));
    await binding.takeScreenshot('screenshot_git_config');
  });

  testWidgets('screenshot-commit_diff', (WidgetTester tester) async {
    tester.view.physicalSize = physicalSize;
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        home: GitStampPage(
          monospaceFontFamily: GoogleFonts.sourceCodePro().fontFamily,
        ),
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(useMaterial3: true),
        debugShowCheckedModeBanner: false,
      ),
    );
    final firstItemFinder = find.byType(GitStampCommitListElement).first;
    await tester.tap(firstItemFinder);
    await tester.pump(Duration(seconds: 1));
    final iconButtonFinder = find.byIcon(Icons.arrow_forward);
    await tester.tap(iconButtonFinder);
    await tester.pump(Duration(seconds: 1));
    await tester.pump(Duration(seconds: 1));
    await binding.takeScreenshot('screenshot_commit_diff');
  });
}
