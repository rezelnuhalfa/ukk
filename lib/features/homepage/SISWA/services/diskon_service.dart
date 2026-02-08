import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/diskon_model.dart';
import '../../../../core/api/api_config.dart';

class DiskonService {
  static Future<List<Diskon>> getDiskonSiswa() async {
  debugPrint('TOKEN DIPAKAI DISKON: ${ApiConfig.token}');

  final response = await http.post(
    Uri.parse('${ApiConfig.baseUrl}getmenudiskonsiswa'),
    headers: ApiConfig.headersWithAuth(),
    body: {'search': ''},
  );

  debugPrint('STATUS DISKON: ${response.statusCode}');
  debugPrint('BODY DISKON: ${response.body}');

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);

    if (jsonData['status'] == true) {
      final List list = jsonData['data'];
      return list.map((e) => Diskon.fromJson(e)).toList();
    }
    throw Exception(jsonData['message']);
  }

  throw Exception('Server error');
}

}
