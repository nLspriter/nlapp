import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Feed extends StatelessWidget {
  final String icon;
  final String name;
  final String text;
  final Color color;
  final Uri url;

  const Feed({
    Key key,
    @required this.icon,
    @required this.name,
    @required this.text,
    @required this.color,
    @required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _launchUrl,
        child: Container(
          decoration: BoxDecoration(
              color: this.color,
              border: Border(bottom: BorderSide(color: Colors.grey[800]))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              feedIcon(),
              feedBody(),
            ],
          ),
        ));
  }

  Widget feedIcon() {
    return Container(
      height: 30,
      width: 30,
      margin:
          const EdgeInsets.only(top: 20, bottom: 15.0, right: 15.0, left: 15.0),
      decoration: new BoxDecoration(
        image:
            DecorationImage(image: AssetImage(this.icon), fit: BoxFit.contain),
      ),
    );
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
        padding: EdgeInsets.only(top: 20, right: 14),
        child: Container(
          margin: const EdgeInsets.only(right: 5.0),
          child: Text(
            this.name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }

  Widget feedText() {
    return Padding(
        padding: EdgeInsets.only(bottom: 20, right: 10),
        child: Text(
          text,
          overflow: TextOverflow.clip,
          style: TextStyle(color: Colors.white),
        ));
  }

  Widget feedIconButton(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.0,
          color: Colors.black45,
        ),
        Container(
          margin: const EdgeInsets.all(6.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black45,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(this.url)) {
      throw 'Could not launch ${this.url}';
    }
  }
}
