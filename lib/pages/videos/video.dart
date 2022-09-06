import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';
import 'package:nlapp/provider_data_class.dart';

class Video extends StatelessWidget {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String duration;
  final DateTime timestamp;

  const Video({
    Key key,
    @required this.id,
    @required this.title,
    @required this.thumbnailUrl,
    @required this.duration,
    @required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<ProviderData>(context, listen: false)
            .changeVideoSelected(this);
        Provider.of<ProviderData>(context, listen: false).changeVisbility(true);
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[800]))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            feedIcon(),
            feedBody(),
          ],
        ),
      ),
    );
  }

  Widget feedIcon() {
    return Stack(children: [
      Padding(
        padding: EdgeInsets.all(10),
        child: Image.network(this.thumbnailUrl, width: 150, fit: BoxFit.contain,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace stackTrace) {
          return Image.network(
              'https://img.youtube.com/vi/${this.id}/sddefault.jpg',
              height: 84.38,
              width: 150,
              fit: BoxFit.cover);
        }),
      ),
      // Positioned(
      //   bottom: 12,
      //   right: 12,
      //   child: Container(
      //     padding: EdgeInsets.all(4),
      //     color: Color.fromARGB(172, 0, 0, 0),
      //     child: Text(
      //       this.duration,
      //       style: TextStyle(color: Colors.white, fontSize: 10),
      //     ),
      //   ),
      // )
    ]);
  }

  Widget feedBody() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          feedHeader(),
          feedText(),
        ],
      ),
    );
  }

  Widget feedHeader() {
    return Padding(
        padding: EdgeInsets.only(top: 15),
        child: Container(
          margin: const EdgeInsets.only(right: 10.0),
          child: Text(
            this.title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ));
  }

  Widget feedText() {
    return Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Text(
          timeago.format(this.timestamp),
          overflow: TextOverflow.clip,
          style: TextStyle(color: Colors.white),
        ));
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(
        Uri.parse('https://www.youtube.com/watch?v=${this.id}'))) {
      throw 'Could not launch ${'https://www.youtube.com/watch?v=${this.id}'}';
    }
  }
}