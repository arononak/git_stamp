import 'package:example/git_stamp/git_stamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'physical_size.dart';
import 'widget_tester_extension.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('screenshot-details_encrypted', (WidgetTester tester) async {
    tester.view.physicalSize = physicalSize;
    tester.view.devicePixelRatio = 1.0;
    await tester.pumpPage(page: GitStamp.mainPage(showDetails: true));
    await tester.pump(Duration(seconds: 2));
    await tester.pump(Duration(seconds: 2));
    await binding.takeScreenshot('screenshot_details_encrypted');
  });

  testWidgets('screenshot-decrypt', (WidgetTester tester) async {
    tester.view.physicalSize = physicalSize;
    tester.view.devicePixelRatio = 1.0;
    await tester.pumpPage(page: GitStamp.mainPage(), isDark: true);
    await tester.tap(find.byIcon(Icons.lock_open));
    await tester.pump(Duration(seconds: 2));
    await tester.pump(Duration(seconds: 2));
    await binding.takeScreenshot('screenshot_decrypt');
  });
}
