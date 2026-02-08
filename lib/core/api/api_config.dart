class ApiConfig {
  /// BASE API
  static const String baseUrl =
      'https://ukk-p2.smktelkom-mlg.sch.id/api/';

  /// BASE IMAGE
  static const String imageBaseUrl =
      'https://ukk-p2.smktelkom-mlg.sch.id/';

  /// TOKEN LOGIN
  static String token = '';

  static Map<String, String> headersNoAuth() => {
        'Accept': 'application/json',
        'makerID': '1',
      };

  static Map<String, String> headersWithAuth() => {
        'Accept': 'application/json',
        'makerID': '1',
        'Authorization': 'Bearer $token',
      };
}
