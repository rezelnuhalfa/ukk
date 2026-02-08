import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/homepage/SISWA/WIDGETS/bottomnavbar.dart';
import '../homepage/SISWA/HomepageSiswa.dart';
import '../homepage/STAN/homepagestan.dart';
import 'login_service.dart';
import '../../core/api/api_config.dart';

class LoginController {
  static Future<void> login({
    required BuildContext context,
    required String role,
    required String username,
    required String password,
  }) async {
    try {
      final response = await LoginService.login(role, {
        'username': username.trim(),
        'password': password.trim(),
      });

      debugPrint('STATUS LOGIN: ${response.statusCode}');
      debugPrint('BODY LOGIN: ${response.body}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        ApiConfig.token = body['access_token']; // 🔥 FIX
        debugPrint('TOKEN VALID: ${ApiConfig.token}');

        if (role == 'Siswa') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainSiswaPage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Homepagestan()),
          );
        }
        return;
      }

      _error(context, 'Username atau password salah');
    } catch (e) {
      debugPrint('LOGIN ERROR: $e');
      _error(context, 'Koneksi bermasalah');
    }
  }

  static void _error(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }
}
