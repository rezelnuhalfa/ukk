import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/menumodel.dart';
import 'package:flutter_application_1/core/api/api_config.dart';

class MenuService {
  /// MENU MAKANAN
  static Future<List<MenuModel>> getMenuFood({String search = ''}) async {
    final uri = Uri.parse(ApiConfig.baseUrl + 'getmenufood');

    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(ApiConfig.headersWithAuth());
    request.fields['search'] = search;

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (body.isEmpty) return [];

    final decoded = json.decode(body);
    if (decoded['data'] == null) return [];

    return (decoded['data'] as List)
        .map((e) => MenuModel.fromJson(e))
        .toList();
  }

  /// MENU MINUMAN
  static Future<List<MenuModel>> getMenuDrink({String search = ''}) async {
    final uri = Uri.parse(ApiConfig.baseUrl + 'getmenudrink');

    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(ApiConfig.headersWithAuth());
    request.fields['search'] = search;

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (body.isEmpty) return [];

    final decoded = json.decode(body);
    if (decoded['data'] == null) return [];

    return (decoded['data'] as List)
        .map((e) => MenuModel.fromJson(e))
        .toList();
  }
}
