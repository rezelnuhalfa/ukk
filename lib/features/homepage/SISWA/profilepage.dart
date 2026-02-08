import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/homepage/SISWA/services/profileservice.dart';
import 'package:flutter_application_1/features/login/login_page.dart';
import '../SISWA/models/profile_siswa_model.dart';
import 'package:flutter_application_1/core/api/api_config.dart';
import 'updateprofile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<ProfileSiswa> profileFuture;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    setState(() {
      profileFuture = ProfileService.getProfile();
    });
  }

  /// LOGOUT FUNCTION
  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text("Logout"),
          content: const Text("Apakah Anda yakin ingin logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),

      /// APPBAR MODERN
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Profil Siswa",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 0, 0),
                Color.fromARGB(255, 255, 102, 0),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadProfile),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),

      body: FutureBuilder<ProfileSiswa>(
        future: profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: ElevatedButton(
                onPressed: _loadProfile,
                child: const Text("Retry"),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Data tidak ditemukan"));
          }

          final profile = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                /// HEADER PROFILE
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 30, bottom: 30),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 255, 0, 0),
                        Color.fromARGB(255, 255, 102, 0),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      /// AVATAR
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: profile.foto != null
                              ? NetworkImage(
                                  ApiConfig.imageBaseUrl + profile.foto!,
                                )
                              : const AssetImage("assets/default_avatar.png")
                                    as ImageProvider,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        profile.nama,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        profile.username,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// CARD INFO
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _modernCard(Icons.person, "Nama", profile.nama),

                      _modernCard(
                        Icons.account_circle,
                        "Username",
                        profile.username,
                      ),

                      _modernCard(Icons.home, "Alamat", profile.alamat ?? "-"),

                      _modernCard(Icons.phone, "Telepon", profile.telp ?? "-"),

                      _modernCard(Icons.security, "Role", profile.role ?? "-"),

                      const SizedBox(height: 30),

                      /// BUTTON EDIT
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text(
                            "Edit Profil",
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                          ),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Updateprofile(),
                              ),
                            );

                            _loadProfile();
                          },
                        ),
                      ),

                      const SizedBox(height: 15),

                      /// BUTTON LOGOUT
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.logout),
                          label: const Text(
                            "Logout",
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            backgroundColor: const Color.fromARGB(255, 255, 136, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: _logout,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// MODERN CARD
  Widget _modernCard(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xffeef1f8),
          child: Icon(icon, color: const Color.fromARGB(255, 255, 102, 0)),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
