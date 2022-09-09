import 'package:flutter/material.dart';
import 'package:nlapp/pages/videos/video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ProviderData extends ChangeNotifier {
  Video selectedVideo;
  YoutubePlayerController controller;
  bool isVisible = false;
  bool isFullscreen = false;

  void changeVideoSelected(Video video) {
    selectedVideo = video;
    if (isVisible) {
      controller.cue(selectedVideo.id);
    } else {
      controller = YoutubePlayerController(
          initialVideoId: selectedVideo.id,
          flags: YoutubePlayerFlags(
              hideThumbnail: true, autoPlay: false, enableCaption: false));
    }
    notifyListeners();
  }

  void changeVisbility(bool visible) {
    isVisible = visible;
    notifyListeners();
  }

  void changeFullscreen(bool fullscreen) {
    isFullscreen = fullscreen;
    notifyListeners();
  }
}
