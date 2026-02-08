import 'package:http/http.dart' as http;
import 'api_config.dart';

class ApiService {

  /// POST TANPA TOKEN
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

  /// ✅ GET DENGAN TOKEN
  static Future<http.Response> getAuth(String endpoint) async {
    return await http.get(
      Uri.parse(ApiConfig.baseUrl + endpoint),
      headers: ApiConfig.headersWithAuth(),
    );
  }
}
