import 'package:nlapp/pages/soundboard/sound.dart';
import 'package:quiver/collection.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

Multimap<String, Sound> sounds = new Multimap<String, Sound>();

Future listAssets() async {
  // Load as String
  final manifestContent = await rootBundle.loadString('AssetManifest.json');

  // Decode to Map
  final Map<String, dynamic> manifestMap = json.decode(manifestContent);

  // Filter by path
  List<String> listMp3 =
      manifestMap.keys.where((String key) => key.contains('.mp3')).toList();
  listMp3.forEach((mp3) {
    var file = mp3.split('assets/sounds/')[1].replaceAll('%20', ' ').split('-');
    sounds.add(file[0].trim(),
        Sound(name: file[0].trim(), sound: file[1].trim().split('.')[0]));
  });
}
