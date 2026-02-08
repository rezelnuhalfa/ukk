import 'package:http/http.dart' as http;
import 'api_config.dart';

class ApiService {
  /// POST TANPA TOKEN
  /// contoh: login, register
  static Future<http.Response> postNoAuth(
    String endpoint, {
    Map<String, String>? body,
  }) async {
    return await http.post(
      Uri.parse(ApiConfig.baseUrl + endpoint),
      headers: ApiConfig.headersNoAuth(),
      body: body,
    );
  }

  /// POST DENGAN TOKEN
  /// contoh: menu, diskon, profile
  static Future<http.Response> postAuth(
    String endpoint, {
    Map<String, String>? body,
  }) async {
    return await http.post(
      Uri.parse(ApiConfig.baseUrl + endpoint),
      headers: ApiConfig.headersWithAuth(),
      body: body,
    );
  }
}
