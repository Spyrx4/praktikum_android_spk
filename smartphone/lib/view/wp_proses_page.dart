import 'package:flutter/material.dart';
import 'package:smartphone/controller/api_service.dart';

class WpProsesPage extends StatefulWidget {
  const WpProsesPage({super.key});

  @override
  State<WpProsesPage> createState() => _WpProsesPageState();
}

class _WpProsesPageState extends State<WpProsesPage> {
  bool _isProcessing = true;
  List<dynamic> _dataHasil = [];

  @override
  void initState() {
    super.initState();
    _eksekusiWP();
  }

  void _eksekusiWP() async {
    try {
      final hasil = await ApiService().prosesWP();
      setState(() {
        _dataHasil = hasil;
        _isProcessing = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Proses Perhitungan WP")),
      body: _isProcessing
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _dataHasil.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final item = _dataHasil[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text("${item['ranking']}",
                          style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text(item['nama']),
                    subtitle: Text("S: ${item['s'].toStringAsExponential(3)}"),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Nilai V", style: TextStyle(fontSize: 10)),
                        Text(item['v'].toStringAsFixed(4),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}