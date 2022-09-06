import 'dart:convert';

import 'package:nlapp/pages/videos/video.dart';
import 'package:http/http.dart' as http;

String id;
String title;
String thumbnailUrl;
DateTime date;
List videos;

Future<List> fetchVideos() async {
  if (videos == null) {
    videos = [];
    var response = await http
        .get(Uri.parse('http://notify.newlegacyinc.tv/youtube-library'));
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
  }
  return videos;
}
