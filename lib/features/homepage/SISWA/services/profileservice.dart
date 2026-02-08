import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/profile_siswa_model.dart';
import 'package:flutter_application_1/core/api/api_config.dart';

class ProfileService {
  static Future<ProfileSiswa> getProfile() async {
    final res = await http.get(
      Uri.parse(ApiConfig.baseUrl + 'get_profile'),
      headers: ApiConfig.headersWithAuth(),
    );

    print("STATUS CODE = ${res.statusCode}");
    print("BODY = ${res.body}");

    final json = jsonDecode(res.body);

    return ProfileSiswa.fromJson(json['data']);
  }
}
