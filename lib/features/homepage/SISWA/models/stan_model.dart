class Stan {
  final int id;
  final String namaStan;
  final String namaPemilik;
  final String telp;

  Stan({
    required this.id,
    required this.namaStan,
    required this.namaPemilik,
    required this.telp,
  });

  factory Stan.fromJson(Map<String, dynamic> json) {
    return Stan(
      id: json['id'],
      namaStan: json['nama_stan'],
      namaPemilik: json['nama_pemilik'],
      telp: json['telp'],
    );
  }
}
