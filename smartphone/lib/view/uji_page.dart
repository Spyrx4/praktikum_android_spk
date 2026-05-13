import 'package:flutter/material.dart';
import 'package:smartphone/controller/api_service.dart';

class UjiPage extends StatelessWidget {
  const UjiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Uji Validasi Spearman")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ApiService().getPerbandingan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final data = snapshot.data!['data'] as List;
          final spearman = snapshot.data!['koefisien'];
          final kategori = snapshot.data!['kategori'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  color: Colors.blueGrey[900],
                  child: ListTile(
                    title: Text("Koefisien Spearman: $spearman", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text("Kategori: $kategori", style: const TextStyle(color: Colors.greenAccent)),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("Smartphone")),
                      DataColumn(label: Text("WP")),
                      DataColumn(label: Text("VIKOR")),
                      DataColumn(label: Text("Selisih")),
                    ],
                    rows: data.map((item) => DataRow(cells: [
                      DataCell(Text(item['nama'])),
                      DataCell(Text("${item['wp']}")),
                      DataCell(Text("${item['vikor']}")),
                      DataCell(Text("${item['selisih']}", style: TextStyle(color: item['selisih'] > 0 ? Colors.red : Colors.black))),
                    ])).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
