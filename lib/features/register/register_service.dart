import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class RegisterService {
  static const String baseUrl =
      'https://ukk-p2.smktelkom-mlg.sch.id/api/';

  static Future<http.StreamedResponse> registerSiswa({
    required Map<String, String> data,
    Uint8List? fotoBytes,
    String? fotoPath,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${baseUrl}register_siswa'),
    );

    // ❌ JANGAN set Content-Type manual
    request.headers.addAll({
      'makerID': '1',
    });

    request.fields.addAll(data);

    if (kIsWeb && fotoBytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'foto',
          fotoBytes,
          filename: 'foto.png',
        ),
      );
    }

    if (!kIsWeb && fotoPath != null) {
      request.files.add(
        await http.MultipartFile.fromPath('foto', fotoPath),
      );
    }

    return await request.send();
  }

  static Future<http.StreamedResponse> registerStan({
    required Map<String, String> data,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${baseUrl}register_stan'),
    );

    request.headers.addAll({
      'makerID': '1',
    });

    request.fields.addAll(data);
    return await request.send();
  }
}
