class Diskon {
  final int id;
  final String nama;
  final int persen;
  final String tanggalAwal;
  final String tanggalAkhir;

  Diskon({
    required this.id,
    required this.nama,
    required this.persen,
    required this.tanggalAwal,
    required this.tanggalAkhir,
  });

  factory Diskon.fromJson(Map<String, dynamic> json) {
    return Diskon(
      id: json['id'],
      nama: json['nama_diskon'],
      persen: json['persentase_diskon'],
      tanggalAwal: json['tanggal_awal'],
      tanggalAkhir: json['tanggal_akhir'],
    );
  }
}
