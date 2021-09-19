import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:nlapp/drawer.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SettingsView extends StatefulWidget {
  static const String routeName = '/settings';

  SettingsView();

  final data = GetStorage();

  @override
  _SettingsView createState() {
    return _SettingsView();
  }
}

class _SettingsView extends State<SettingsView> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
              titlePadding: EdgeInsets.all(20),
              title: 'Push Notifications',
              tiles: [
                SettingsTile.switchTile(
                    title: 'Announcements',
                    switchValue: widget.data.read('announcementSwitch'),
                    onToggle: (value) {
                      setState(() {
                        widget.data.write('announcementSwitch', value);
                        if (widget.data.read('announcementSwitch') == true)
                          messaging.subscribeToTopic('announcement');
                        else if (widget.data.read('announcementSwitch') ==
                            false)
                          messaging.unsubscribeFromTopic('announcement');
                      });
                    }),
                SettingsTile.switchTile(
                    title: 'Twitch',
                    switchValue: widget.data.read('twitchSwitch'),
                    onToggle: (value) {
                      setState(() {
                        widget.data.write('twitchSwitch', value);
                        if (widget.data.read('twitchSwitch') == true)
                          messaging.subscribeToTopic('twitch');
                        else if (widget.data.read('twitchSwitch') == false)
                          messaging.unsubscribeFromTopic('twitch');
                      });
                    }),
                SettingsTile.switchTile(
                    title: 'YouTube',
                    switchValue: widget.data.read('youtubeSwitch'),
                    onToggle: (value) {
                      setState(() {
                        widget.data.write('youtubeSwitch', value);
                        if (widget.data.read('youtubeSwitch') == true)
                          messaging.subscribeToTopic('youtube');
                        else if (widget.data.read('youtubeSwitch') == false)
                          messaging.unsubscribeFromTopic('youtube');
                      });
                    })
              ],
            ),
          ],
        ),
        drawer: createDrawer(context));
  }
}
