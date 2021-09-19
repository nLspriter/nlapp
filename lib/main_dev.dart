import 'package:flutter/material.dart';
import 'package:nlapp/routes/routes.dart';
import 'package:nlapp/pages/feed/feedsview.dart';
import 'package:nlapp/pages/settings/settingsview.dart';
import 'package:nlapp/pages/soundboard/soundboardview.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nlapp/config.dart';

void main() async {
  Config.appFlavor = Flavor.DEVELOPMENT;
  await GetStorage.init();
  GetStorage().writeIfNull('announcementSwitch', true);
  GetStorage().writeIfNull('twitchSwitch', true);
  GetStorage().writeIfNull('youtubeSwitch', true);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  if (GetStorage().read('announcementSwitch') == true)
    messaging.subscribeToTopic('announcement');
  else if (GetStorage().read('announcementSwitch') == false)
    messaging.unsubscribeFromTopic('announcement');

  if (GetStorage().read('twitchSwitch') == true)
    messaging.subscribeToTopic('twitch');
  else if (GetStorage().read('twitchSwitch') == false)
    messaging.unsubscribeFromTopic('twitch');

  if (GetStorage().read('youtubeSwitch') == true)
    messaging.subscribeToTopic('youtube');
  else if (GetStorage().read('youtubeSwitch') == false)
    messaging.unsubscribeFromTopic('youtube');

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    if (await canLaunch(message.data['url']))
      await launch(message.data['url']);
    else
      throw "Could not launch ";
  });

  FirebaseMessaging.instance.getInitialMessage().then((message) async {
    if (await canLaunch(message.data['url']))
      await launch(message.data['url']);
    else
      throw "Could not launch ";
  });

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'newLEGACYinc App',
      theme: _createTheme(),
      themeMode: ThemeMode.system,
      darkTheme: _createThemeDark(),
      home: FeedsView(),
      routes: {
        routes.feeds: (context) => FeedsView(),
        routes.settings: (context) => SettingsView(),
        routes.soundboard: (context) => SoundboardView(),
      },
    );
  }
}

ThemeData _createTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF162955),
    canvasColor: Colors.white,
    fontFamily: 'Sans-serif',
  );
}

ThemeData _createThemeDark() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF4F628E),
    canvasColor: Colors.grey[900],
    fontFamily: 'Sans-serif',
  );
}
