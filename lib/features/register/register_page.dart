import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'register_controller.dart';

class RegisterPage extends StatefulWidget {
  final String role;
  const RegisterPage({super.key, required this.role});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final picker = ImagePicker();

  Uint8List? fotoBytes; // WEB
  String? fotoPath; // MOBILE

  final nama = TextEditingController();
  final alamat = TextEditingController();
  final telp = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();

  bool isLoading = false;
  bool hidePassword = true;

  @override
  void dispose() {
    nama.dispose();
    alamat.dispose();
    telp.dispose();
    username.dispose();
    password.dispose();
    super.dispose();
  }

  // ================= IMAGE PICKER =================
  Future<void> pickImage() async {
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img == null) return;

    if (kIsWeb) {
      fotoBytes = await img.readAsBytes();
    } else {
      fotoPath = img.path;
    }

    setState(() {});
  }

  Widget _imagePicker() {
    ImageProvider? image;

    if (kIsWeb && fotoBytes != null) {
      image = MemoryImage(fotoBytes!);
    }

    return GestureDetector(
      onTap: pickImage,
      child: CircleAvatar(
        radius: 55,
        backgroundColor: Colors.orange.shade100,
        backgroundImage: image,
        child: image == null
            ? const Icon(Icons.camera_alt,
                size: 32, color: Colors.orange)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double headerHeight = 260;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Stack(
          children: [
            /// ================= BACKGROUND KUNING =================
            Container(
              height: headerHeight,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(50),
                ),
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/backgroundKuning.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            /// ================= CONTENT =================
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
              child: Column(
                children: [
                  const Icon(
                    Icons.person_add_alt_1,
                    size: 70,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Daftar ${widget.role}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// ================= CARD =================
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _imagePicker(),
                        const SizedBox(height: 20),

                        _field('Nama', nama),
                        if (widget.role == 'Siswa')
                          _field('Alamat', alamat),
                        _field('Telp', telp),
                        _field('Username', username),

                        /// PASSWORD + EYE
                        _field(
                          'Password',
                          password,
                          obscure: hidePassword,
                          suffix: IconButton(
                            icon: Icon(
                              hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : const Text(
                                    'Daftar',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= FIELD =================
  Widget _field(
    String label,
    TextEditingController c, {
    bool obscure = false,
    Widget? suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: c,
        obscureText: obscure,
        style: const TextStyle(fontFamily: 'Poppins'),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontFamily: 'Poppins'),
          suffixIcon: suffix,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // ================= SUBMIT =================
  Future<void> _submit() async {
    if (password.text.length < 6) {
      _error('Password minimal 6 karakter');
      return;
    }

    setState(() => isLoading = true);

    final data = {
      'username': username.text,
      'password': password.text,
      'telp': telp.text,
      'nama_siswa': nama.text,
      'alamat': alamat.text,
    };

    final success = await RegisterController.register(
      context: context,
      role: widget.role,
      data: data,
      fotoBytes: fotoBytes,
      fotoPath: fotoPath,
    );

    if (!mounted) return;

    setState(() => isLoading = false);

    if (success == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Daftar berhasil, silakan login',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 800));
      Navigator.pop(context); 
    }
  }

  void _error(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
