import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FeedItems extends StatefulWidget {
  final List<String> items = [
    'Twitch',
    'YouTube',
    'Twitter',
    'Instagram',
    'Discord',
  ];
  final Map<String, String> itemImage = {
    'Twitch': 'images/twitch.png',
    'YouTube': 'images/youtube.png',
    'Twitter': 'images/twitter.png',
    'Instagram': 'images/instagram.png',
    'Discord': 'images/discord.png',
  };
  final Map<String, String> itemText = {
    'Twitch': 'Offline',
    'YouTube': 'Latest Video',
    'Twitter': 'Follow us and get the latest updates',
    'Instagram': 'Check out our photos',
    'Discord': 'Join the community',
  };
  final Map<String, String> itemURL = {
    'Twitch': 'https://www.twitch.tv/newlegacyinc',
    'YouTube': 'https://www.youtube.com/newlegacyinc',
    'Twitter': 'https://www.twitter.com/newlegacyinc',
    'Instagram': 'https://www.instagram.com/newlegacygram',
    'Discord': 'https://www.discord.gg/newlegacyinc',
  };

  final data = GetStorage();

  @override
  _FeedItems createState() {
    data.writeIfNull('itemText', itemText);
    data.writeIfNull('itemURL', itemURL);
    return _FeedItems();
  }
}

class _FeedItems extends State<FeedItems> with WidgetsBindingObserver {
  late FirebaseMessaging messaging;
  String? notificationText;

  Future<String> fetchData() async {
    var response = await http
        .get(Uri.parse('https://nl-app-server.herokuapp.com/status'));
    if (response.statusCode == 201) {
      this.setState(() {
        widget.itemText['Twitch'] = jsonDecode(response.body)['stream_status'];
        widget.itemURL['YouTube'] = 'https:///www.youtube.com/watch?v=' +
            jsonDecode(response.body)['video_id'];
        widget.itemText['YouTube'] = jsonDecode(response.body)['video_title'];
        widget.data.write('itemText', widget.itemText);
        widget.data.write('itemURL', widget.itemURL);
      });
      return 'Data loaded';
    } else {
      return 'Data not loaded';
    }
  }

  @override
  void initState() {
    fetchData();
    messaging = FirebaseMessaging.instance;

    if (widget.data.read('twitchSwitch') == true)
      messaging.subscribeToTopic('twitch');
    else if (widget.data.read('twitchSwitch') == false)
      messaging.unsubscribeFromTopic('twitch');

    if (widget.data.read('youtubeSwitch') == true)
      messaging.subscribeToTopic('youtube');
    else if (widget.data.read('youtubeSwitch') == false)
      messaging.unsubscribeFromTopic('youtube');

    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: GestureDetector(
                child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: <Color>[Color(0xFF061539), Color(0xFF4F628E)],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Image.asset(
                            widget.itemImage[widget.items[index]].toString(),
                            width: 42,
                            height: 42,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: [
                                      TextSpan(
                                        text: '${widget.items[index]}\n',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: widget.data
                                            .read(
                                                'itemText')[widget.items[index]]
                                            .toString(),
                                        style: TextStyle(
                                          color: Colors.white,

                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                onTap: () async {
                  if (await canLaunch(widget.data
                      .read('itemURL')[widget.items[index]]
                      .toString()))
                    await launch(widget.data
                        .read('itemURL')[widget.items[index]]
                        .toString());
                  else
                    throw "Could not launch ";
                },
              ));
        },
        itemCount: widget.items.length,
      ),
      onRefresh: fetchData,
    );
  }
}
