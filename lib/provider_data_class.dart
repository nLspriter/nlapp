import 'package:flutter/material.dart';
import 'package:nlapp/pages/videos/video.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ProviderData extends ChangeNotifier {
  Video selectedVideo;
  YoutubePlayerController controller;
  bool isVisible = false;
  String searchTerm = '';
  String selectedSort = 'Newest';
  int page = 0;

  void changeVideoSelected(Video video) {
    selectedVideo = video;
    if (isVisible) {
      controller.cueVideoById(videoId: selectedVideo.id);
    } else {
      controller = YoutubePlayerController(
          params: YoutubePlayerParams(
        mute: false,
        showControls: true,
        showFullscreenButton: true,
      ))
        ..onInit = () {
          controller.cueVideoById(videoId: selectedVideo.id);
        };
    }
    notifyListeners();
  }

  void changeVisbility(bool visible) {
    isVisible = visible;
    notifyListeners();
  }

  void changePage(int number) {
    page = number;
    notifyListeners();
  }

  void changeSearchTerm(String term) {
    term = term.split('nL ')[term.split('nL ').length - 1];
    searchTerm = term;
    notifyListeners();
  }

  void changeSort(String selected) {
    selectedSort = selected;
    notifyListeners();
  }
}
