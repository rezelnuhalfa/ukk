import 'package:flutter/material.dart';
import 'package:flutter_application_1/menu_detail_page.dart';
import '../SISWA/models/menumodel.dart';
import '../SISWA/services/menu_service.dart';


class MenuDrinkPage extends StatelessWidget {
  const MenuDrinkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Minuman'),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<List<MenuModel>>(
        future: MenuService.getMenuDrink(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Menu minuman kosong'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final menu = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MenuDetailPage(menu: menu),
                      ),
                    );
                  },
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      menu.fullFotoUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image),
                    ),
                  ),
                  title: Text(
                    menu.namaMakanan,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(menu.deskripsi ?? ''),
                  trailing: Text(
                    "Rp ${menu.harga}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
