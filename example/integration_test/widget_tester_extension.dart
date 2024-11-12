import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterExtension on WidgetTester {
  Future<void> pumpPage({required Widget page, bool isDark = false}) async {
    await pumpWidget(
      MaterialApp(
        home: page,
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        darkTheme: isDark ? ThemeData.dark(useMaterial3: true) : null,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
