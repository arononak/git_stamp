import 'package:example/git_stamp/git_stamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('screenshot-details', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(500, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        home: GitStampPage(showDetails: true),
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
      ),
    );
    await tester.pump(Duration(seconds: 1));
    await tester.pump(Duration(seconds: 1));
    await binding.takeScreenshot('screenshot_details');
  });
}