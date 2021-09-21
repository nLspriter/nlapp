import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiver/collection.dart';
import 'package:nlapp/drawer.dart';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';

class SoundboardView extends StatefulWidget {
  static const String routeName = '/soundboard';
  final Multimap<String, String> soundList = new Multimap<String, String>();

  @override
  _SoundboardView createState() {
    return _SoundboardView();
  }
}

class _SoundboardView extends State<SoundboardView> {
  AudioPlayer player;

  Future _listAssets(BuildContext context) async {
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    List<String> listMp3 =
        manifestMap.keys.where((String key) => key.contains('.mp3')).toList();
    listMp3.forEach((mp3) {
      var file =
          mp3.split('assets/sounds/')[1].replaceAll('%20', ' ').split('-');
      this.setState(() {
        widget.soundList.add(file[0].trim(), file[1].trim());
      });
    });
  }

  @override
  void initState() {
    _listAssets(context);
    player = AudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: DefaultTabController(
      length: widget.soundList.length,
      child: Scaffold(
        drawer: createDrawer(context),
        appBar: AppBar(
          title: const Text('Soundboard'),
          bottom: new TabBar(
            isScrollable: true,
            tabs: List<Widget>.generate(widget.soundList.length, (int index) {
              return new Tab(text: widget.soundList.keys.elementAt(index));
            }),
          ),
        ),
        body: TabBarView(
          children: List<Widget>.generate(widget.soundList.length, (int index) {
            var name = widget.soundList.keys.elementAt(index);
            var list = widget.soundList[name].toList();
            return new Container(
                width: 50,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: Ink(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: <Color>[
                                    Color(0xFF061539),
                                    Color(0xFF4F628E)
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: InkWell(
                              child: Container(
                                  constraints: BoxConstraints(minHeight: 80),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(list[index].split('.mp3')[0],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ))
                                    ],
                                  )),
                              onTap: () async {
                                await player.setAsset(
                                    'assets/sounds/$name - ${list[index]}');
                                await player.play();
                              },
                              onLongPress: () async {
                                final ByteData bytes = await rootBundle.load(
                                    'assets/sounds/$name - ${list[index]}');
                                final Uint8List uintlist =
                                    bytes.buffer.asUint8List();
                                final tempDir = await getTemporaryDirectory();
                                final file = await new File(
                                        '${tempDir.path}/$name - ${list[index]}')
                                    .create();
                                file.writeAsBytesSync(uintlist);
                                Share.shareFiles(['${file.path}']);
                              },
                            )));
                  },
                  itemCount: list.length,
                ));
          }),
        ),
        floatingActionButton: Ink(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Color(0xFF061539), Color(0xFF4F628E)],
                )),
            child: InkResponse(
              child: Container(
                height: 70,
                width: 70,
                child: Center(
                    child: Text("Stop",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ))),
              ),
              onTap: () {
                player.stop();
              },
            )),
      ),
    ));
  }
}
