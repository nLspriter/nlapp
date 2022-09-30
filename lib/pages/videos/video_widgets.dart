import 'package:flutter/material.dart';
import 'package:nlapp/pages/videos/video.dart';
import 'package:nlapp/pages/videos/videos.dart';
import 'package:nlapp/provider_data_class.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
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
  return YoutubePlayerScaffold(
      controller: Provider.of<ProviderData>(context).controller,
      aspectRatio: 16 / 9,
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
                            separatorBuilder:
                                (BuildContext context, int index) => Divider(
                              height: 0,
                            ),
                            itemCount: results.length,
                          ))
                        ],
                      ))),
            ]);
      });
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
            results = videos;
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
        // GestureDetector(
        //     onTap: () {
        //       addToFavorites(Provider.of<ProviderData>(context, listen: false)
        //           .selectedVideo);
        //       setState(() {});
        //     },
        //     child: Container(
        //       width: MediaQuery.of(context).size.width / 4,
        //       child: Column(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           FaIcon(
        //               likedVideos.contains(
        //                       Provider.of<ProviderData>(context).selectedVideo)
        //                   ? FontAwesomeIcons.solidStar
        //                   : FontAwesomeIcons.star,
        //               color: Colors.white),
        //           SizedBox(
        //             height: 6,
        //           ),
        //           Text(
        //             likedVideos.contains(
        //                     Provider.of<ProviderData>(context).selectedVideo)
        //                 ? 'Liked'
        //                 : 'Like',
        //             style: TextStyle(
        //               color: Colors.white,
        //             ),
        //           ),
        //         ],
        //       ),
        //     )),
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

class FilterDialog extends StatefulWidget {
  FilterDialog({Key key}) : super(key: key);

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog>
    with WidgetsBindingObserver {
  String selectedValue = 'Newest';
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Search Filter'),
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 100,
                  child: Text('Sort by'),
                ),
                SizedBox(
                    width: 100,
                    child: DropdownButton(
                        isExpanded: true,
                        value: Provider.of<ProviderData>(context, listen: false)
                            .selectedSort,
                        onChanged: (newValue) {
                          setState(() {
                            Provider.of<ProviderData>(context, listen: false)
                                .changeSort(newValue);
                          });
                        },
                        items: sortItems))
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     SizedBox(
            //       width: 100,
            //       child: Text('Type'),
            //     ),
            //     SizedBox(
            //         width: 100,
            //         child: DropdownButton(
            //             isExpanded: true,
            //             value: 'All',
            //             onChanged: (value) {},
            //             items: dropdownItems))
            //   ],
            // ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text('Apply'),
                  onPressed: () {
                    setState(() {
                      Provider.of<ProviderData>(context, listen: false)
                          .changeSort(
                              Provider.of<ProviderData>(context, listen: false)
                                  .selectedSort);
                      onTimeSelected(
                          Provider.of<ProviderData>(context, listen: false)
                              .selectedSort);
                      Navigator.pop(context);
                    });
                  },
                )
              ],
            )
          ],
        )
      ],
    );
  }
}

List<DropdownMenuItem<String>> get sortItems {
  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text('Newest'), value: 'Newest'),
    DropdownMenuItem(child: Text('Oldest'), value: 'Oldest'),
  ];
  return menuItems;
}

List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text('All'), value: 'All'),
    DropdownMenuItem(child: Text('Liked'), value: 'Liked'),
  ];
  return menuItems;
}

Future<void> _launchUrl(String id) async {
  if (!await launchUrl(Uri.parse('https://www.youtube.com/watch?v=$id'),
      mode: LaunchMode.externalApplication)) {
    throw 'Could not launch ${'https://www.youtube.com/watch?v=$id'}';
  }
}

void addToFavorites(Video video) {
  if (likedVideos.contains(video)) {
    likedVideos.remove(video);
  } else {
    likedVideos.add(video);
  }
}

void onTimeSelected(String sort) {
  switch (sort) {
    case 'Newest':
      results.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      break;
    case 'Oldest':
      results.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      break;
  }
}
