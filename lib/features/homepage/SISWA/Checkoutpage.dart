import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/homepage/SISWA/services/cart_service.dart';
import 'package:flutter_application_1/core/api/api_config.dart';
import 'package:http/http.dart' as http;
import '../SISWA/models/menumodel.dart';

class Checkoutpage extends StatefulWidget {
  const Checkoutpage({super.key});

  @override
  State<Checkoutpage> createState() => _CheckoutpageState();
}

class _CheckoutpageState extends State<Checkoutpage> {
  bool isLoading = false;

  /// KIRIM PESANAN KE SERVER
  Future<void> kirimPesanan() async {
    try {
      if (CartService.items.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Keranjang kosong")),
        );
        return;
      }

      setState(() => isLoading = true);

      final first = CartService.items.first;

      if (first.menu.idStan == null) throw Exception("idStan null");
      if (first.menu.idMenu == null) throw Exception("idMenu null");

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConfig.baseUrl + "pesan"),
      );

      request.headers.addAll(ApiConfig.headersWithAuth());
      request.fields['id_stan'] = first.menu.idStan.toString();
      request.fields['pesan'] = jsonEncode(
        CartService.items
            .map((e) => {"id_menu": e.menu.idMenu, "qty": e.qty})
            .toList(),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        CartService.clear();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Pesanan berhasil dikirim")),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Gagal kirim pesanan (${response.statusCode})")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Terjadi error kirim pesanan")),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  /// HAPUS ITEM DARI CART
  void hapusItem(int index) {
    setState(() {
      CartService.items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartService.items;

    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: AppBar(
        elevation: 0,
        title: const Text("Checkout", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffff0000), Color(0xffff6600)],
            ),
          ),
        ),
      ),
      body: cart.isEmpty
          ? const Center(child: Text("Keranjang kosong"))
          : Column(
              children: [
                /// LIST CART
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (_, i) {
                      final item = cart[i];
                      return _cartItemCard(item, i);
                    },
                  ),
                ),

                /// TOTAL & BUTTON KIRIM
               
              ],
            ),
    );
  }

  /// ITEM CART MODERN
  Widget _cartItemCard(dynamic item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, spreadRadius: 2),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(item.menu.fullFotoUrl),
        ),
        title: Text(
          item.menu.namaMakanan,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Rp ${item.menu.harga} x ${item.qty}"),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => hapusItem(index),
        ),
      ),
    );
  }

}

