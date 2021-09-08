import 'package:flutter/material.dart';
import 'drawer.dart';
import 'feeditems.dart';

class FeedsView extends StatelessWidget {
  static const String routeName = '/feeds';


  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Feeds'),
            ),
            body: FeedItems(),
            drawer: createDrawer(context)
        ));
  }
}
