import 'package:flutter/material.dart';
import 'package:nlapp/pages/feed/feeds.dart';
import 'package:nlapp/pages/settings/settings.dart';
import 'package:nlapp/pages/soundboard/sounds.dart';
import 'package:nlapp/pages/soundboard/sound.dart';
import 'package:nlapp/pages/videos/videos.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nlapp/firebase.dart';
import 'package:nlapp/provider_data_class.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:share_plus/share_plus.dart';

void main() async {
  await GetStorage.init();
  GetStorage().writeIfNull('announcementSwitch', true);
  GetStorage().writeIfNull('twitchSwitch', true);
  GetStorage().writeIfNull('youtubeSwitch', true);
  WidgetsFlutterBinding.ensureInitialized();

  await firebaseInitialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ProviderData(),
          ),
        ],
        child: MaterialApp(
          title: 'newLEGACYinc',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: HomeScreen(),
        ));
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int page = 0;
  List<Color> _iconColor = [
    Colors.blue,
    Colors.white,
    Colors.white,
    Colors.white
  ];

  Future<List> _futureVideos;

  @override
  void initState() {
    listAssets();
    super.initState();
    _futureVideos = fetchVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.grey[900],
        title: Container(
          height: 50,
          margin: const EdgeInsets.all(5.0),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/newlegacyinc_logo.png"),
                fit: BoxFit.contain),
          ),
        ),
        centerTitle: true,
      ),
      body: listOfItems(),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[900],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildBottomIconButton(Icons.home, _iconColor[0], 0, 'Feed'),
            buildBottomIconButton(
                Icons.volume_up, _iconColor[1], 1, 'Soundboard'),
            buildBottomIconButton(
                Icons.personal_video, _iconColor[2], 2, 'Videos'),
            buildBottomIconButton(Icons.settings, _iconColor[3], 3, 'Settings'),
          ],
        ),
      ),
    );
  }

  Widget buildBottomIconButton(
      IconData icon, Color color, int pageNo, String name) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      IconButton(
        icon: Icon(
          icon,
          color: color,
        ),
        onPressed: () {
          if (page != pageNo)
            setState(() {
              page = pageNo;
              for (var i = 0; i < _iconColor.length; i++) {
                if (i == pageNo) {
                  _iconColor[i] = Colors.blue;
                } else {
                  _iconColor[i] = Colors.white;
                }
              }
            });
        },
      ),
      Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Text(
            name,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ))
    ]);
  }

  Widget listOfItems() {
    switch (page) {
      case 0:
        return Container(
            color: Colors.grey[700],
            child: FutureBuilder(
                future: fetchData(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return feeds[index];
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(
                          height: 0,
                        ),
                        itemCount: feeds.length,
                      );
                    }
                  }
                  return Center(child: CircularProgressIndicator());
                }));

        break;
      case 1:
        return Container(
          child: DefaultTabController(
            length: sounds.length,
            child: Scaffold(
                appBar: AppBar(
                  elevation: 1,
                  backgroundColor: Colors.grey[800],
                  title: new TabBar(
                      isScrollable: true,
                      tabs: List.generate(sounds.length, (int index) {
                        return new Tab(text: sounds.keys.elementAt(index));
                      })),
                ),
                body: TabBarView(
                    children: List.generate(sounds.length, (int index) {
                  var name = sounds.keys.elementAt(index);
                  var list = sounds[name].toList();
                  return new Container(
                      color: Colors.grey[700],
                      child: ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return list[index];
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(
                          height: 0,
                        ),
                        itemCount: list.length,
                      ));
                })),
                floatingActionButton: FloatingActionButton(
                    child: Icon(
                      Icons.stop,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.grey[800],
                    onPressed: () {
                      setState(() {
                        audioStop();
                      });
                    })),
          ),
        );
        break;
      case 2:
        return Stack(children: [
          Container(
              color: Colors.grey[700],
              child: FutureBuilder(
                  future: _futureVideos,
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                            return videos[index];
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(
                            height: 0,
                          ),
                          itemCount: videos.length,
                        );
                      }
                    }
                    return Center(child: CircularProgressIndicator());
                  })),
          Visibility(
            child: YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: Provider.of<ProviderData>(context).controller,
              ),
              builder: (context, player) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      player,
                      Expanded(
                          child: Container(
                              color: Colors.grey[700],
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Divider(color: Colors.grey[700]),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Text(
                                          Provider.of<ProviderData>(context)
                                              .selectedVideo
                                              .title,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold))),
                                  Padding(
                                      padding:
                                          EdgeInsets.only(top: 5, left: 15),
                                      child: Text(
                                          timeago.format(
                                              Provider.of<ProviderData>(context)
                                                  .selectedVideo
                                                  .timestamp),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14))),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Provider.of<ProviderData>(context,
                                                  listen: false)
                                              .changeVisbility(false);
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.arrow_back,
                                                color: Colors.white),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Text(
                                              "Return",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Share.share(
                                              'https://www.youtube.com/watch?v=${Provider.of<ProviderData>(context, listen: false).selectedVideo.id}');
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.share,
                                                color: Colors.white),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Text(
                                              "Share",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _launchUrl(Provider.of<ProviderData>(
                                                  context,
                                                  listen: false)
                                              .selectedVideo
                                              .id);
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.play_circle,
                                                color: Colors.white),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Text(
                                              "YouTube",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider()
                                ],
                              ))),
                    ]);
              },
            ),
            visible: Provider.of<ProviderData>(context).isVisible,
          )
        ]);
        break;
      case 3:
        return Container(
          color: Colors.grey[700],
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return settings[index];
            },
            separatorBuilder: (BuildContext context, int index) => Divider(
              height: 0,
            ),
            itemCount: settings.length,
          ),
        );
        break;
      default:
        return Container(
          color: Colors.white,
          child: Text('Loading...'),
        );
        break;
    }
  }

  Future<void> _launchUrl(String id) async {
    if (!await launchUrl(Uri.parse('https://www.youtube.com/watch?v=$id'))) {
      throw 'Could not launch ${'https://www.youtube.com/watch?v=$id'}';
    }
  }
}
