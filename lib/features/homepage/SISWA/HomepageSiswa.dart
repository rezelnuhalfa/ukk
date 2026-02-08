import 'dart:async';
import 'package:flutter/material.dart';
import 'menu_drink_page.dart';
import 'menu_food_page.dart';
import 'StanPage.dart';
import 'models/diskon_model.dart';
import 'models/menumodel.dart';
import 'models/profile_siswa_model.dart';
import 'services/diskon_service.dart';
import 'services/menu_service.dart';
import 'services/profileservice.dart';
import 'WIDGETS/banner_diskon.dart';
import 'menu_detail_page.dart';

class HomeSiswaPage extends StatefulWidget {
  const HomeSiswaPage({super.key});

  @override
  State<HomeSiswaPage> createState() => _HomeSiswaPageState();
}

class _HomeSiswaPageState extends State<HomeSiswaPage> {
  late Future<List<Diskon>> futureDiskon;
  late Future<List<MenuModel>> futureFood;
  late Future<List<MenuModel>> futureDrink;
  late Future<ProfileSiswa> futureProfile;

  late PageController _diskonController;
  Timer? _diskonTimer;
  int _currentDiskon = 0;

  @override
  void initState() {
    super.initState();
    _loadData();

    _diskonController = PageController(viewportFraction: 0.92);
    _diskonTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_diskonController.hasClients) {
        _currentDiskon++;
        if (_currentDiskon >= (futureDiskon != null ? 5 : 1)) _currentDiskon = 0;
        _diskonController.animateToPage(
          _currentDiskon,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _loadData() {
    futureDiskon = DiskonService.getDiskonSiswa();
    futureFood = MenuService.getMenuFood();
    futureDrink = MenuService.getMenuDrink();
    futureProfile = ProfileService.getProfile();
    setState(() {});
  }

  @override
  void dispose() {
    _diskonTimer?.cancel();
    _diskonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async => _loadData(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 90),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              /// HEADER
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(30),
                      ),
                      image: DecorationImage(
                        image: AssetImage('assets/images/backgroundKuning.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  /// GREETING
                  Positioned(
                    top: 32,
                    left: 20,
                    right: 20,
                    child: FutureBuilder<ProfileSiswa>(
                      future: futureProfile,
                      builder: (context, snapshot) {
                        final nama =
                            snapshot.hasData ? snapshot.data!.nama : '';
                        return Row(
                          children: [
                            Image.asset('assets/images/hai.png', width: 50),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                nama.isNotEmpty
                                    ? "Halo, $nama\nMau makan apa hari ini?"
                                    : "Halo\nMau makan apa hari ini?",
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  /// DISKON
                  Positioned(
                    bottom: -90,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: 160,
                      child: FutureBuilder<List<Diskon>>(
                        future: futureDiskon,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          final list = snapshot.data!;
                          return PageView.builder(
                            controller: _diskonController,
                            itemCount: list.length,
                            itemBuilder: (_, i) => BannerDiskon(diskon: list[i]),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 110),

              /// CONTENT
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _quickAccess(context),
                    const SizedBox(height: 30),
                    sectionTitle('Rekomendasi Makanan'),
                    horizontalMenu(futureFood),
                    const SizedBox(height: 28),
                    sectionTitle('Rekomendasi Minuman'),
                    horizontalMenu(futureDrink),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// HORIZONTAL MENU
  Widget horizontalMenu(Future<List<MenuModel>> future) {
    return SizedBox(
      height: 190,
      child: FutureBuilder<List<MenuModel>>(
        future: future,
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!.take(5).toList();

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (_, i) {
              final menu = items[i];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MenuDetailPage(menu: menu),
                    ),
                  );
                },
                child: Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.network(
                            menu.fullFotoUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          menu.namaMakanan,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// QUICK ACCESS
  Widget _quickAccess(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage('assets/images/backgroundOren.webp'),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          quickAccessItem(Icons.rice_bowl, 'Makanan', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MenuFoodPage()),
            );
          }),
          quickAccessItem(Icons.local_drink, 'Minuman', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MenuDrinkPage()),
            );
          }),
          quickAccessItem(Icons.store, 'Stan', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StanPage()),
            );
          }),
          quickAccessItem(Icons.history, 'Riwayat', () {}),
        ],
      ),
    );
  }
}

/// HELPERS
Widget sectionTitle(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

Widget quickAccessItem(
  IconData icon,
  String label,
  VoidCallback onTap,
) =>
    InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.orange),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
