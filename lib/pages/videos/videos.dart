import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:nlapp/flavor.dart';
import 'package:nlapp/pages/videos/video.dart';
import 'package:http/http.dart' as http;
import 'package:iso_duration_parser/iso_duration_parser.dart';

String id;
String title;
String thumbnailUrl;
DateTime date;
String duration;
List videos = [];
List results = [];
List likedVideos = [];

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
      var dur = IsoDuration.parse(x["details"]["duration"]);
      if (dur.hours > 0) {
        duration = dur.format('{h}:{mm}:{ss}');
      } else {
        duration = dur.format('{mm}:{ss}');
      }
      videos.add(Video(
          id: id,
          title: title,
          thumbnailUrl: thumbnailUrl,
          duration: duration,
          timestamp: DateTime(date.year, date.month, date.day)));
    }
  }
  results = videos;
  return results;
}
