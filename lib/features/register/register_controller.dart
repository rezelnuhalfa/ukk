import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'register_service.dart';

class RegisterController {
  static Future<bool> register({
    required BuildContext context,
    required String role,
    required Map<String, String> data,
    Uint8List? fotoBytes,
    String? fotoPath,
  }) async {
    try {
      final response = role == 'Siswa'
          ? await RegisterService.registerSiswa(
              data: data,
              fotoBytes: fotoBytes,
              fotoPath: fotoPath,
            )
          : await RegisterService.registerStan(data: data);

      final body = await response.stream.bytesToString();
      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('BODY: $body');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      _error(context, 'Pendaftaran gagal');
      return false;
    } catch (e) {
      debugPrint('REGISTER ERROR: $e');
      _error(context, 'Kesalahan koneksi');
      return false;
    }
  }

  static void _error(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
