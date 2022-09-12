import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:nlapp/flavor.dart';
import 'package:nlapp/pages/videos/video.dart';
import 'package:http/http.dart' as http;

String id;
String title;
String thumbnailUrl;
DateTime date;
List videos = [];

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

Future<List> fetchVideos() async {
  final flavor = await _getFlavorSettings();
  videos.clear();
  var response =
      await http.get(Uri.parse('${flavor.apiBaseUrl}/youtube-library'));
  if (response.statusCode == 201) {
    var data = jsonDecode(response.body);
    for (var x in data) {
      id = x["id"];
      title = x["details"]["title"];
      thumbnailUrl = x["details"]["thumbnail"];
      date = DateTime.parse(x["details"]["publishedAt"]);
      videos.add(Video(
          id: id,
          title: title,
          thumbnailUrl: thumbnailUrl,
          duration: "0:00",
          timestamp: DateTime(date.year, date.month, date.day)));
    }
  }
  return videos;
}
