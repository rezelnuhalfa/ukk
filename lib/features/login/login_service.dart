import 'package:http/http.dart' as http;
import '../../core/api/api_service.dart';

class LoginService {
  static Future<http.Response> login(
    String role,
    Map<String, String> data,
  ) {
    final endpoint =
        role == 'Siswa' ? 'login_siswa' : 'login_stan';

    // ✅ body WAJIB pakai named parameter
    return ApiService.postNoAuth(
      endpoint,
      body: data,
    );
  }
}
