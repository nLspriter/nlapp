/// Contains the hard-coded settings per flavor.
class FlavorSettings {
  final String apiBaseUrl;

  FlavorSettings.dev() : apiBaseUrl = 'http://notify.newlegacyinc.tv/status';

  FlavorSettings.prod() : apiBaseUrl = 'http://notify.newlegacyinc.tv/status';
}
