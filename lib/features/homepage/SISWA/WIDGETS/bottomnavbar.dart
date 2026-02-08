import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/homepage/SISWA/Checkoutpage.dart';
import 'package:flutter_application_1/features/homepage/SISWA/HomepageSiswa.dart';
import 'package:flutter_application_1/features/homepage/SISWA/pesananpage.dart';
import 'package:flutter_application_1/features/homepage/SISWA/profilepage.dart';

class MainSiswaPage extends StatefulWidget {
  const MainSiswaPage({super.key});

  @override
  State<MainSiswaPage> createState() => _MainSiswaPageState();
}

class _MainSiswaPageState extends State<MainSiswaPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeSiswaPage(),
    Checkoutpage(),
    PesananPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      /// ================= BOTTOM NAVBAR =================
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgroundKuning.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          onTap: (index) {
            setState(() => _currentIndex = index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Checkout',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Status',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
