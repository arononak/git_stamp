import 'package:example/git_stamp/git_stamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'physical_size.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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
}
