import 'package:flutter/material.dart';

enum Flavor {
  DEVELOPMENT,
  RELEASE,
}

class Config {

  static Flavor appFlavor;

  static String get serverURL {
    switch (appFlavor) {
      case Flavor.RELEASE:
        return 'https://nl-app-server.herokuapp.com/status';
      case Flavor.DEVELOPMENT:
      default:
        return 'https://nl-app-server-dev.herokuapp.com/status';
    }
  }
}