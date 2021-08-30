import 'package:flutter/material.dart';
import 'package:nlapp/routes/routes.dart';
import 'package:nlapp/feedsview.dart';
import 'settingsview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Drawer Demo',
      theme: _createTheme(),
      themeMode: ThemeMode.system,
      home: FeedsView(),
      routes: {
        routes.feeds: (context) => FeedsView(),
        routes.settings: (context) => SettingsView(),
      },
    );
  }
}

ThemeData _createTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF162955),
    accentColor: Color(0xFF4F628E),
    canvasColor: Colors.white,
    fontFamily: 'Sans-serif',
  );
}

