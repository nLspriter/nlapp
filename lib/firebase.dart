import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;

Future firebaseInitialize() async {
  await Firebase.initializeApp();

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
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    if (!await launchUrl(message.data['url'])) {
      throw 'Could not launch ${message.data['url']}';
    }
  });

  FirebaseMessaging.instance.getInitialMessage().then((message) async {
    if (!await launchUrl(message.data['url'])) {
      throw 'Could not launch ${message.data['url']}';
    }
  });

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
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
}
