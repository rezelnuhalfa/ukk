import 'dart:convert';
import '../model/stan_model.dart';
import 'package:flutter_application_1/core/api/api_service.dart';

class StanService {

  static Future<List<StanModel>> getStan() async {

    final res = await ApiService.getAuth("get_stan");

    print("STATUS STAN = ${res.statusCode}");
    print("BODY STAN = ${res.body}");

    if (res.statusCode == 200) {

      if (res.body.isEmpty) return [];

      final decoded = jsonDecode(res.body);

      /// ===============================
      /// CASE 1 — API RETURN LIST
      /// ===============================
      if (decoded is List) {
        return decoded
            .map((e) => StanModel.fromJson(
                  Map<String, dynamic>.from(e),
                ))
            .toList();
      }

      /// ===============================
      /// CASE 2 — MAP -> DATA LIST
      /// ===============================
      if (decoded is Map && decoded['data'] is List) {
        return (decoded['data'] as List)
            .map((e) => StanModel.fromJson(
                  Map<String, dynamic>.from(e),
                ))
            .toList();
      }

      /// ===============================
      /// CASE 3 — MAP -> DATA OBJECT
      /// ===============================
      if (decoded is Map && decoded['data'] is Map) {
        return [
          StanModel.fromJson(
            Map<String, dynamic>.from(decoded['data']),
          )
        ];
      }

      /// ===============================
      /// CASE 4 — MAP LANGSUNG OBJECT
      /// ===============================
      if (decoded is Map && decoded.containsKey('id')) {
        return [
          StanModel.fromJson(
            Map<String, dynamic>.from(decoded),
          )
        ];
      }

      return [];

    } else {
      throw Exception("Gagal ambil data stan");
    }
  }
}
