import 'dart:convert';
import 'package:flutter_application_1/core/api/api_service.dart';
import '../models/stan_model.dart';

class StanService {
  static Future<List<Stan>> getAllStan({String search = ''}) async {
    final response = await ApiService.postAuth(
      'get_all_stan',
      body: {
        'search': search,
      },
    );

    final jsonData = jsonDecode(response.body);

    if (jsonData['status'] == true) {
      return (jsonData['data'] as List)
          .map((e) => Stan.fromJson(e))
          .toList();
    } else {
      throw Exception('Gagal load stan');
    }
  }
}
