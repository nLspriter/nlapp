/// Contains the hard-coded settings per flavor.
class FlavorSettings {
  final String apiBaseUrl;

  FlavorSettings.dev()
      : apiBaseUrl = 'https://nl-app-server-dev.herokuapp.com/status';

  FlavorSettings.prod() : apiBaseUrl = 'http://notify.newlegacyinc.tv/status';
}
