/// Contains the hard-coded settings per flavor.
class FlavorSettings {
  final String apiBaseUrl;
  // TODO Add any additional flavor-specific settings here.

  FlavorSettings.dev()
      : apiBaseUrl = 'https://nl-app-server-dev.herokuapp.com/status';

  FlavorSettings.prod()
      : apiBaseUrl = 'https://nl-app-server.herokuapp.com/status';
}
