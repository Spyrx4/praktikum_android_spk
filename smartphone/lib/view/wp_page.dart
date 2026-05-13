import 'package:flutter/material.dart';
import 'package:smartphone/model/smartphone_model.dart';
import 'package:smartphone/controller/api_service.dart';
import 'package:smartphone/logic_spk.dart';

class RankingWPPage extends StatelessWidget {
  const RankingWPPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ranking Metode WP"),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Smartphone>>(
        future: ApiService().getSmartphones(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada data untuk dihitung"));
          }

          // Hitung ranking menggunakan logika yang sudah dipisah
          final rankedData = LogicSPK.hitungWP(snapshot.data!);

          return ListView.builder(
            itemCount: rankedData.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              final hp = rankedData[index];
              return Card(
                elevation: 3,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text("${index + 1}",
                        style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text(hp.namaHp,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("RAM: ${hp.ram}GB | Kamera: ${hp.kamera}MP"),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Skor V",
                          style: TextStyle(fontSize: 10, color: Colors.grey)),
                      Text(
                        hp.skor?.toStringAsFixed(4) ?? "0",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}