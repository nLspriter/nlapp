import 'package:flutter/material.dart';
import 'drawer.dart';

class SettingsView extends StatelessWidget {
  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
            ),
            drawer: createDrawer(context)
        ));
  }
}
