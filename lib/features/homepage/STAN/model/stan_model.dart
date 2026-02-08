class StanModel {
  final int id;
  final String namaStan;
  final String pemilik;

  StanModel({
    required this.id,
    required this.namaStan,
    required this.pemilik,
  });

  factory StanModel.fromJson(Map<String, dynamic> json) {
    return StanModel(
      id: json['id'] ?? 0,
      namaStan: json['nama_stan'] ?? '',
      pemilik: json['pemilik'] ?? '',
    );
  }
}
