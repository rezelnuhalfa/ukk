class MenuModel {
  final int? id;
  final int? idMenu; // Pastikan namanya idMenu (huruf M besar)
  final String namaMakanan;
  final int harga;
  final String jenis;
  final String? foto;
  final String? deskripsi;
  final int? idStan;
  final int? makerId;
  final String? createdAt;
  final String? updatedAt;

  MenuModel({
    this.id,
    this.idMenu, // Sesuai di sini
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
    return MenuModel(
      id: json['id'],
      idMenu:
          json['id_menu'], // Mengambil dari key JSON id_menu ke variabel idMenu
      namaMakanan: json['nama_makanan'] ?? '',
      harga: json['harga'] is int
          ? json['harga']
          : int.tryParse(json['harga'].toString()) ?? 0,
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

  String get fullFotoUrl {
    if (foto == null || foto!.isEmpty) {
      return 'https://via.placeholder.com/150';
    }
    return 'https://ukk-p2.smktelkom-mlg.sch.id/$foto';
  }
}