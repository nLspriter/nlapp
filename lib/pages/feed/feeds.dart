import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:nlapp/pages/feed/feed.dart';
import 'package:nlapp/flavor.dart';

String notificationText;
String twitchStatus;
String youtubeTitle;
String youtubeURL;

Future<String> fetchData() async {
  final flavor = await _getFlavorSettings();
  var response = await http.get(Uri.parse(flavor.apiBaseUrl));
  if (response.statusCode == 201) {
    twitchStatus = jsonDecode(response.body)['stream_status'];
    youtubeURL = 'https:///www.youtube.com/watch?v=' +
        jsonDecode(response.body)['video_id'];
    youtubeTitle = jsonDecode(response.body)['video_title'];
    return 'Data loaded';
  } else {
    return 'Data not loaded';
  }
}

Future<FlavorSettings> _getFlavorSettings() async {
  String flavor =
      await const MethodChannel('flavor').invokeMethod<String>('getFlavor');

  if (flavor == 'dev') {
    return FlavorSettings.dev();
  } else if (flavor == 'prod') {
    return FlavorSettings.prod();
  } else {
    throw Exception("Unknown flavor: $flavor");
  }
}

var feeds = [
  Feed(
      icon: 'assets/images/twitch.png',
      name: 'Twitch',
      text: twitchStatus,
      color: Color.fromRGBO(145, 70, 255, 1),
      url: Uri.parse('https://www.twitch.tv/newlegacyinc')),
  Feed(
      icon: 'assets/images/youtube.png',
      name: 'Youtube',
      text: youtubeTitle,
      color: Color.fromRGBO(255, 0, 0, 1),
      url: Uri.parse(youtubeURL ?? 'https:///www.youtube.com/newlegacyinc')),
  Feed(
      icon: 'assets/images/twitter.png',
      name: 'Twitter',
      text: 'Follow us and get the latest updates',
      color: Color.fromRGBO(29, 161, 242, 1),
      url: Uri.parse('https://www.twitter.com/newlegacyinc')),
  Feed(
      icon: 'assets/images/instagram.png',
      name: 'Instagram',
      text: 'Check out our photos',
      color: Color.fromRGBO(48, 97, 138, 1),
      url: Uri.parse('https://www.instagram.com/newlegacygram')),
  Feed(
      icon: 'assets/images/tiktok.png',
      name: 'TikTok',
      text: 'Watch some of our clips',
      color: Color.fromRGBO(254, 44, 85, 1),
      url: Uri.parse('https://www.tiktok.com/@newlegacyinc')),
  Feed(
      icon: 'assets/images/discord.png',
      name: 'Discord',
      text: 'Join the community',
      color: Color.fromRGBO(88, 101, 242, 1),
      url: Uri.parse('https://www.discord.gg/newlegacyinc')),
];
