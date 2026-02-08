class MenuModel {
  final int? id;
  final int? idMenu; // Sesuai API, huruf M besar
  final String namaMakanan;
  final int harga; // selalu int
  final String jenis;
  final String? foto;
  final String? deskripsi;
  final int? idStan;
  final int? makerId;
  final String? createdAt;
  final String? updatedAt;

  MenuModel({
    this.id,
    this.idMenu,
    required this.namaMakanan,
    required this.harga,
    required this.jenis,
    this.foto,
    this.deskripsi,
    this.idStan,
    this.makerId,
    this.createdAt,
    this.updatedAt,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    // Pastikan harga selalu int
    int parsedHarga = 0;
    if (json['harga'] != null) {
      if (json['harga'] is int) {
        parsedHarga = json['harga'];
      } else if (json['harga'] is double) {
        parsedHarga = (json['harga'] as double).toInt();
      } else {
        parsedHarga = int.tryParse(json['harga'].toString()) ?? 0;
      }
    }

    return MenuModel(
      id: json['id'],
      idMenu: json['id_menu'],
      namaMakanan: json['nama_makanan'] ?? '',
      harga: parsedHarga,
      jenis: json['jenis'] ?? '',
      foto: json['foto'],
      deskripsi: json['deskripsi'],
      idStan: json['id_stan'],
      makerId: json['maker_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_menu': idMenu,
      'nama_makanan': namaMakanan,
      'harga': harga,
      'jenis': jenis,
      'foto': foto,
      'deskripsi': deskripsi,
      'id_stan': idStan,
      'maker_id': makerId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Dapatkan URL foto lengkap
  String get fullFotoUrl {
    if (foto == null || foto!.isEmpty) {
      return 'https://via.placeholder.com/150';
    }
    return 'https://ukk-p2.smktelkom-mlg.sch.id/$foto';
  }
}
