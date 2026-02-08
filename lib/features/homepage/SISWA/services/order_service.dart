import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/core/api/api_config.dart';
import 'cart_service.dart';

class OrderService {
  static Future<bool> checkout() async {
    if (CartService.items.isEmpty) return false;

    final stanId = CartService.items.first.menu.idStan ?? 0;

    final body = {
      "id_stan": stanId,
      "pesan": CartService.items.map((e) {
        return {"id_menu": e.menu.idMenu, "qty": e.qty};
      }).toList(),
    };

    print("BODY ORDER = ${jsonEncode(body)}");

    final response = await http.post(
      Uri.parse(ApiConfig.baseUrl + "pesan"),
      headers: {
        ...ApiConfig.headersWithAuth(),
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    print("ORDER STATUS = ${response.statusCode}");
    print("ORDER BODY = ${response.body}");

    return response.statusCode == 200;
  }
}
