import 'package:flutter/material.dart';
import 'package:smartphone/view/list_page.dart';
import 'package:smartphone/view/wp_page.dart';
import 'package:smartphone/view/vikor_page.dart';
import 'package:smartphone/view/vikor_proses_page.dart';
import 'package:smartphone/view/wp_proses_page.dart';
import 'package:smartphone/view/uji_page.dart';
import 'package:smartphone/view/vikor_chart_page.dart';
import 'package:smartphone/view/wp_chart_page.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SPK Smartphone"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TOMBOL CRUD
              SizedBox(
                width: 250,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.edit_note),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SmartphoneListPage()),
                  ),
                  label: const Text("Kelola Data (CRUD)"),
                ),
              ),
              const SizedBox(height: 20),

              const Text("PROSES PERHITUNGAN",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const Divider(),
              
              // TOMBOL PROSES VIKOR
              SizedBox(
                width: 250,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.sync),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const VikorProsesPage()),
                  ),
                  label: const Text("Hitung & Simpan VIKOR"),
                ),
              ),
              const SizedBox(height: 10),

              // TOMBOL PROSES WP
              SizedBox(
                width: 250,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.flash_on),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WpProsesPage()),
                  ),
                  label: const Text("Hitung & Simpan WP"),
                ),
              ),
              
              const SizedBox(height: 20),
              const Text("LIHAT HASIL RANKING",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const Divider(),

              // TOMBOL LIHAT HASIL VIKOR
              SizedBox(
                width: 250,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.list_alt),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[100],
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RankingVikorPage()),
                  ),
                  label: const Text("Ranking Metode VIKOR"),
                ),
              ),
              const SizedBox(height: 10),

              // TOMBOL LIHAT HASIL WP
              SizedBox(
                width: 250,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.list_alt),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[100],
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RankingWPPage()),
                  ),
                  label: const Text("Ranking Metode WP"),
                ),
              ),

              const SizedBox(height: 20),
              const Text("ANALISIS & GRAFIK",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const Divider(),

              // TOMBOL UJI SPEARMAN
              SizedBox(
                width: 250,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.analytics),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo, 
                    foregroundColor: Colors.white
                  ),
                  onPressed: () => Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (_) => const UjiPage())
                  ),
                  label: const Text("Uji Validasi (Spearman)"),
                ),
              ),
              const SizedBox(height: 10),

              // TOMBOL GRAFIK VIKOR
              SizedBox(
                width: 250,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.bar_chart),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, 
                    foregroundColor: Colors.white
                  ),
                  onPressed: () => Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (_) => const VikorChartPage())
                  ),
                  label: const Text("Grafik Hasil VIKOR"),
                ),
              ),
              const SizedBox(height: 10),

              // TOMBOL GRAFIK WP
              SizedBox(
                width: 250,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.bar_chart),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, 
                    foregroundColor: Colors.white
                  ),
                  onPressed: () => Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (_) => const WpChartPage())
                  ),
                  label: const Text("Grafik Hasil WP"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
