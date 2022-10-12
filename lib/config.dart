enum Flavor {
  DEVELOPMENT,
  RELEASE,
}

class Config {
  static Flavor appFlavor;

  static String get serverURL {
    switch (appFlavor) {
      case Flavor.RELEASE:
        return 'https://notify.newlegacyinc.tv';
      case Flavor.DEVELOPMENT:
      default:
        return 'https://notify.newlegacyinc.tv';
    }
  }
}
