import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nlapp/routes/routes.dart';

Widget createDrawer(BuildContext context) {
  return Drawer(
      child: ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFF061539), Color(0xFF4F628E)],
        )),
        child: DrawerHeader(
          child: Image(image: AssetImage('assets/images/newlegacyinc_logo.png')),
        ),
      ),
      ListTile(
          leading: Icon(Icons.feed),
          title: Text('Feeds'),
          onTap: () {
            Navigator.popAndPushNamed(context, routes.feeds);
          }),
      ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: () {
            Navigator.popAndPushNamed(context, routes.settings);
          }),
    ],
  ));
}
