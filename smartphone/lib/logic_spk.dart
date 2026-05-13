import 'dart:math';
import 'package:smartphone/model/smartphone_model.dart';

class LogicSPK {
  static List<Smartphone> hitungWP(List<Smartphone> data) {
    if (data.isEmpty) return [];

    final w = {'harga': -0.4, 'ram': 0.25, 'kamera': 0.2, 'baterai': 0.15};
    List<double> listS = [];
    double totalS = 0;

    for (var hp in data) {
      double s =
          (pow(hp.harga, w['harga']!) *
                  pow(hp.ram, w['ram']!) *
                  pow(hp.kamera, w['kamera']!) *
                  pow(hp.baterai, w['baterai']!))
              .toDouble();
      listS.add(s);
      totalS += s;
    }

    for (int i = 0; i < data.length; i++) {
      data[i].skor = listS[i] / totalS;
    }
    data.sort((a, b) => (b.skor ?? 0).compareTo(a.skor ?? 0));
    return data;
  }

  // Logic Vikor
  static List<Smartphone> hitungVikor(List<Smartphone> data) {
    if (data.length < 2) return data;

    final w = [0.4, 0.25, 0.2, 0.15];
    double fStarHarga = data.map((e) => e.harga).reduce(min);
    double fMinHarga = data.map((e) => e.harga).reduce(max);
    double fStarRam = data.map((e) => e.ram).reduce(max);
    double fMinRam = data.map((e) => e.ram).reduce(min);
    double fStarKamera = data.map((e) => e.kamera).reduce(max);
    double fMinKamera = data.map((e) => e.kamera).reduce(min);
    double fStarBaterai = data.map((e) => e.baterai).reduce(max);
    double fMinBaterai = data.map((e) => e.baterai).reduce(min);
    List<double> listS = [];
    List<double> listR = [];

    for (var hp in data) {
      double sHarga =
          w[0] *
          (fStarHarga - hp.harga) /
          (fStarHarga - fMinHarga == 0 ? 1 : fStarHarga - fMinHarga);
      double sRam =
          w[1] *
          (fStarRam - hp.ram) /
          (fStarRam - fMinRam == 0 ? 1 : fStarRam - fMinRam);
      double sKamera =
          w[2] *
          (fStarKamera - hp.kamera) /
          (fStarKamera - fMinKamera == 0 ? 1 : fStarKamera - fMinKamera);
      double sBaterai =
          w[3] *
          (fStarBaterai - hp.baterai) /
          (fStarBaterai - fMinBaterai == 0 ? 1 : fStarBaterai - fMinBaterai);
      double sTotal = (sHarga + sRam + sKamera + sBaterai).abs();
      double rMax = [
        sHarga.abs(),
        sRam.abs(),
        sKamera.abs(),
        sBaterai.abs(),
      ].reduce(max);
      listS.add(sTotal);
      listR.add(rMax);
    }
    double sStar = listS.reduce(min);
    double sMin = listS.reduce(max);
    double rStar = listR.reduce(min);
    double rMin = listR.reduce(max);
    for (int i = 0; i < data.length; i++) {
      double q =
          0.5 * (listS[i] - sStar) / (sMin - sStar == 0 ? 1 : sMin - sStar) +
          0.5 * (listR[i] - rStar) / (rMin - rStar == 0 ? 1 : rMin - rStar);
      data[i].skor = q;
    }
    data.sort((a, b) => (a.skor ?? 0).compareTo(b.skor ?? 0));
    return data;
  }
}
