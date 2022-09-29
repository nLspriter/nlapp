import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';
import 'package:nlapp/provider_data_class.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
        Provider.of<ProviderData>(context, listen: false)
            .changeSearchTerm(this.title.split(' - ')[0]);

        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
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
        child: CachedNetworkImage(
          imageUrl: 'https://img.youtube.com/vi/${this.id}/maxresdefault.jpg',
          fit: BoxFit.fitWidth,
          height: 84.38,
          width: 150,
          errorWidget: (context, url, error) {
            return CachedNetworkImage(
              imageUrl: 'https://img.youtube.com/vi/${this.id}/sddefault.jpg',
              fit: BoxFit.fitWidth,
              height: 84.38,
              width: 150,
              errorWidget: (context, url, error) {
                return CachedNetworkImage(
                  imageUrl:
                      'https://img.youtube.com/vi/${this.id}/hqdefault.jpg',
                  fit: BoxFit.fitWidth,
                  height: 84.38,
                  width: 150,
                  errorWidget: (context, url, error) {
                    return CachedNetworkImage(
                        imageUrl:
                            'https://img.youtube.com/vi/${this.id}/mqdefault.jpg',
                        fit: BoxFit.fitWidth,
                        height: 84.38,
                        width: 150,
                        errorWidget: (context, url, error) {
                          return CachedNetworkImage(
                            imageUrl:
                                'https://img.youtube.com/vi/${this.id}/default.jpg',
                            fit: BoxFit.fitWidth,
                            height: 84.38,
                            width: 150,
                          );
                        });
                  },
                );
              },
            );
          },
        ),
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

  String getId() {
    return this.id;
  }
}
