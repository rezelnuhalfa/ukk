import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import 'package:flutter_application_1/features/homepage/SISWA/services/profileservice.dart';
import 'package:flutter_application_1/core/api/api_config.dart';
import '../SISWA/models/profile_siswa_model.dart';

class Updateprofile extends StatefulWidget {
  const Updateprofile({Key? key}) : super(key: key);

  @override
  State<Updateprofile> createState() => _UpdateprofileState();
}

class _UpdateprofileState extends State<Updateprofile> {
  late Future<ProfileSiswa> profileFuture;

  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final usernameController = TextEditingController();
  final alamatController = TextEditingController();
  final telpController = TextEditingController();

  File? _image;
  Uint8List? _imageBytes;
  String? _imageName;

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

  /// PICK IMAGE
  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked == null) return;

    final bytes = await picked.readAsBytes();

    setState(() {
      _image = File(picked.path);
      _imageBytes = bytes;
      _imageName = p.basename(picked.path);
    });
  }

  /// UPDATE API
  Future<void> _updateProfile(int id) async {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      var uri = Uri.parse('${ApiConfig.baseUrl}update_siswa/$id');

      var request = http.MultipartRequest("POST", uri);

      request.headers.addAll(ApiConfig.headersWithAuth());

      request.fields["nama_siswa"] = namaController.text;
      request.fields["username"] = usernameController.text;
      request.fields["alamat"] = alamatController.text;
      request.fields["telp"] = telpController.text;

      if (_imageBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            "foto",
            _imageBytes!,
            filename: _imageName ?? "profile.jpg",
          ),
        );
      }

      final response = await request.send();

      if (!mounted) return;

      Navigator.pop(context);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profil berhasil diperbarui"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal update (${response.statusCode})"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),

      /// APPBAR
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Edit Profil",
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
      ),

      body: FutureBuilder<ProfileSiswa>(
        future: profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Data tidak tersedia"));
          }

          final profile = snapshot.data!;

          if (namaController.text.isEmpty) {
            namaController.text = profile.nama;
            usernameController.text = profile.username;
            alamatController.text = profile.alamat ?? "";
            telpController.text = profile.telp ?? "";
          }

          return SingleChildScrollView(
            child: Column(
              children: [

                /// HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 30,
                    bottom: 30,
                  ),
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
                      Stack(
                        children: [

                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: _imageBytes != null
                                  ? MemoryImage(_imageBytes!)
                                  : (profile.foto != null
                                      ? NetworkImage(
                                          ApiConfig.imageBaseUrl +
                                              profile.foto!,
                                        )
                                      : const AssetImage(
                                          "assets/default_avatar.png",
                                        )) as ImageProvider,
                            ),
                          ),

                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        "Ubah Foto Profil",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// FORM CARD
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [

                          _modernField(
                            controller: namaController,
                            label: "Nama Lengkap",
                            icon: Icons.person,
                            validator: (v) =>
                                v!.isEmpty ? "Nama wajib diisi" : null,
                          ),

                          const SizedBox(height: 15),

                          _modernField(
                            controller: usernameController,
                            label: "Username",
                            icon: Icons.account_circle,
                            validator: (v) =>
                                v!.isEmpty ? "Username wajib diisi" : null,
                          ),

                          const SizedBox(height: 15),

                          _modernField(
                            controller: alamatController,
                            label: "Alamat",
                            icon: Icons.home,
                          ),

                          const SizedBox(height: 15),

                          _modernField(
                            controller: telpController,
                            label: "Telepon",
                            icon: Icons.phone,
                          ),

                          const SizedBox(height: 30),

                          /// BUTTON SAVE
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () =>
                                  _updateProfile(profile.id),
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 255, 0, 0),
                                      Color.fromARGB(255, 255, 102, 0),
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(15),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Simpan Perubahan",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// MODERN FIELD
  Widget _modernField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.red),
        filled: true,
        fillColor: const Color(0xfff4f6fb),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
