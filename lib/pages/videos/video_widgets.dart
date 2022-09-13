import 'package:flutter/material.dart';
import 'package:nlapp/pages/videos/video.dart';
import 'package:nlapp/pages/videos/videos.dart';
import 'package:nlapp/provider_data_class.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:share_plus/share_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget videoList(Future<List> list, List videoType) {
  return Container(
      color: Colors.grey[700],
      child: FutureBuilder(
          future: list,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return videoType[index];
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                    height: 0,
                  ),
                  itemCount: videoType.length,
                );
              }
            }
            return Center(child: CircularProgressIndicator());
          }));
}

Widget videoPlayer(BuildContext context) {
  return YoutubePlayerBuilder(
    player: YoutubePlayer(
      controller: Provider.of<ProviderData>(context).controller,
      bottomActions: [
        CurrentPosition(),
        ProgressBar(isExpanded: true),
        RemainingDuration(),
        PlaybackSpeedButton()
      ],
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
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                                Provider.of<ProviderData>(context)
                                    .selectedVideo
                                    .title,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold))),
                        Padding(
                            padding: EdgeInsets.only(top: 5, left: 15),
                            child: Text(
                                timeago.format(
                                    Provider.of<ProviderData>(context)
                                        .selectedVideo
                                        .timestamp),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14))),
                        Divider(),
                        ActionButtons(),
                        Divider(
                          color: Color.fromARGB(0, 0, 0, 0),
                          height: 8,
                        ),
                        Divider(
                          height: 1,
                        ),
                        Expanded(
                            child: ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                            return results[index];
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(
                            height: 0,
                          ),
                          itemCount: results.length,
                        ))
                      ],
                    ))),
          ]);
    },
    onEnterFullScreen: () => Provider.of<ProviderData>(context, listen: false)
        .changeFullscreen(true),
    onExitFullScreen: () => Provider.of<ProviderData>(context, listen: false)
        .changeFullscreen(false),
  );
}

class ActionButtons extends StatefulWidget {
  ActionButtons({Key key}) : super(key: key);

  @override
  _ActionButtonsState createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            Provider.of<ProviderData>(context, listen: false)
                .changeVisbility(false);
          },
          child: Container(
              width: MediaQuery.of(context).size.width / 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(FontAwesomeIcons.circleArrowLeft, color: Colors.white),
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
              )),
        ),
        GestureDetector(
            onTap: () {
              Share.share(
                  'https://www.youtube.com/watch?v=${Provider.of<ProviderData>(context, listen: false).selectedVideo.id}');
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(FontAwesomeIcons.share, color: Colors.white),
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
            )),
        GestureDetector(
            onTap: () {
              addToFavorites(Provider.of<ProviderData>(context, listen: false)
                  .selectedVideo);
              setState(() {});
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                      favorites.contains(
                              Provider.of<ProviderData>(context).selectedVideo)
                          ? FontAwesomeIcons.solidStar
                          : FontAwesomeIcons.star,
                      color: Colors.white),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    favorites.contains(
                            Provider.of<ProviderData>(context).selectedVideo)
                        ? 'Liked'
                        : 'Like',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )),
        GestureDetector(
            onTap: () {
              _launchUrl(Provider.of<ProviderData>(context, listen: false)
                  .selectedVideo
                  .id);
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(FontAwesomeIcons.youtube, color: Colors.white),
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
            ))
      ],
    );
  }
}

Future<void> _launchUrl(String id) async {
  if (!await launchUrl(Uri.parse('https://www.youtube.com/watch?v=$id'),
      mode: LaunchMode.externalApplication)) {
    throw 'Could not launch ${'https://www.youtube.com/watch?v=$id'}';
  }
}

void addToFavorites(Video video) {
  if (favorites.contains(video)) {
    favorites.remove(video);
  } else {
    favorites.add(video);
  }
}
