import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

final player = AudioPlayer();

void audioStop() {
  player.stop();
}

class Sound extends StatelessWidget {
  final String name;
  final String sound;

  const Sound({
    Key key,
    @required this.name,
    @required this.sound,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          await player
              .setAsset('assets/sounds/${this.name} - ${this.sound}.mp3');
          await player.play();
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[600],
              border: Border(bottom: BorderSide(color: Colors.grey[800]))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              soundBody(),
            ],
          ),
        ));
  }

  Widget soundBody() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [soundHeader()],
      ),
    );
  }

  Widget soundHeader() {
    return Padding(
        padding: EdgeInsets.only(top: 30, right: 14, left: 14, bottom: 30),
        child: Container(
          margin: const EdgeInsets.only(right: 5.0),
          child: Text(
            this.sound,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }
}
