import 'package:example/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('screenshot-icon', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(500, 800);
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
    final iconButtonOffset = tester.getCenter(iconButtonFinder);
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();
    await gesture.moveTo(iconButtonOffset);
    
    await tester.pump(Duration(seconds: 1));
    await tester.pump(Duration(seconds: 1));
    await binding.takeScreenshot('screenshot_icon');
  });
}
