import 'package:flutter/material.dart';
import 'package:nlapp/routes/routes.dart';

Widget createDrawer(BuildContext context) {
  return Drawer(
      child: ListView(
    padding: EdgeInsets.zero,
    children: [
      const DrawerHeader(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFF061539), Color(0xFF4F628E)],
        )),
        child: Image(image: AssetImage('assets/images/newlegacyinc_logo.png')),
      ),
      ListTile(
          leading: Icon(Icons.feed),
          title: Text('Feeds'),
          onTap: () {
            Navigator.pushReplacementNamed(context, routes.feeds);
          }),
      ListTile(
          leading: Icon(Icons.play_arrow),
          title: Text('Soundboard'),
          onTap: () {
            Navigator.pushReplacementNamed(context, routes.soundboard);
          }),
      ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: () {
            Navigator.pushReplacementNamed(context, routes.settings);
          }),
    ],
  ));
}
