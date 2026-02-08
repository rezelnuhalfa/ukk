import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/core/api/api_config.dart';

class PesananPage extends StatefulWidget {
  const PesananPage({super.key});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {

  List orders = [];
  bool isLoading = true;

  Future<void> getOrders() async {
    try {

      final response = await http.get(
        Uri.parse(ApiConfig.baseUrl + "showorder/dimasak"),
        headers: ApiConfig.headersWithAuth(),
      );

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        setState(() {
          orders = data['data'] ?? [];
          isLoading = false;
        });

      } else {
        setState(() => isLoading = false);
      }

    } catch (e) {
      print(e);
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    getOrders();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Pesanan Saya")),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(child: Text("Belum ada pesanan"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (_, i) {
                    final order = orders[i];

                    return Card(
                      child: ListTile(
                        title: Text(order['nama_menu'] ?? "-"),
                        subtitle: Text("Qty : ${order['qty'] ?? 0}"),
                        trailing: Text("Rp ${order['harga'] ?? 0}"),
                      ),
                    );
                  },
                ),
    );
  }
}
