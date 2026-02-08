import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/homepage/SISWA/models/menumodel.dart';
import 'package:flutter_application_1/features/homepage/SISWA/services/cart_service.dart';

class MenuDetailPage extends StatelessWidget {
  final MenuModel menu;

  const MenuDetailPage({super.key, required this.menu});

  void addToCart(BuildContext context) {
    CartService.add(menu);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Masuk Keranjang")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: AppBar(
        title: const Text("Detail Menu"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffFF0000), Color(0xffFF6600)],
            ),
          ),
        ),
      ),
      body: Column(
        children: [

          /// IMAGE
          Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(menu.fullFotoUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// NAMA
                  Text(
                    menu.namaMakanan,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  /// JENIS
                  Text(
                    "Jenis: ${menu.jenis}",
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 5),

                  /// HARGA
                  Text(
                    "Harga: Rp ${menu.harga}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(height: 10),

                  /// DESKRIPSI
                  Text(
                    menu.deskripsi ?? "-",
                    style: const TextStyle(fontSize: 16),
                  ),

                  const Spacer(),

                  /// BUTTON MASUK KERANJANG
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () => addToCart(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text(
                        "Masuk Keranjang",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
