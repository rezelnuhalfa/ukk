class ProfileSiswa {
  final int id;
  final String nama;
  final String username;
  final String? alamat;
  final String? telp;
  final String? role;
  final String? foto;

  ProfileSiswa({
    required this.id,
    required this.nama,
    required this.username,
    this.alamat,
    this.telp,
    this.role,
    this.foto,
  });

  factory ProfileSiswa.fromJson(Map<String, dynamic> json) {
    print("JSON PROFILE = $json");

    return ProfileSiswa(
      id: json['id'] ?? 0,
      nama: json['nama_siswa'] ?? "Tidak ada nama",
      username: json['username'] ?? "",
      alamat: json['alamat'],
      telp: json['telp'],
      role: json['role'],
      foto: json['foto'],
    );
  }
}
