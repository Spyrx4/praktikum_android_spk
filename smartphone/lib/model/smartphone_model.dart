class Smartphone {
  final int? id;
  final String namaHp;
  final double harga;
  final double ram;
  final double kamera;
  final double baterai;
  double? skor;

  Smartphone({
    this.id,
    required this.namaHp,
    required this.harga,
    required this.ram,
    required this.kamera,
    required this.baterai,
    this.skor,
  });

  factory Smartphone.fromJson(Map<String, dynamic> json) {
    return Smartphone(
      id: json['id'],
      namaHp: json['nama_hp'],
      harga: json['harga'].toDouble(),
      ram: json['ram'].toDouble(),
      kamera: json['kamera'].toDouble(),
      baterai: json['baterai'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    "nama_hp": namaHp,
    "harga": harga,
    "ram": ram,
    "kamera": kamera,
    "baterai": baterai
  };
}
