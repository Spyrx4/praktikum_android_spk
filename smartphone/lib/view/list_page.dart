import 'package:flutter/material.dart';
import 'package:smartphone/model/smartphone_model.dart';
import 'package:smartphone/controller/api_service.dart';
import 'package:smartphone/view/form_page.dart';

class SmartphoneListPage extends StatefulWidget {
  const SmartphoneListPage({super.key});

  @override
  State<SmartphoneListPage> createState() => _SmartphoneListPageState();
}

class _SmartphoneListPageState extends State<SmartphoneListPage> {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Daftar Smartphone")),
      body: FutureBuilder<List<Smartphone>>(
        future: apiService.getSmartphones(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Belum ada data"));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final hp = snapshot.data![index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(
                    hp.namaHp,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "RAM: ${hp.ram}GB | Kamera: ${hp.kamera}MP |Harga: Rp${hp.harga}",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SmartphoneFormPage(smartphone: hp), // Kirim data hp yang dipilih
                            ),
                          ).then(
                            (value) => setState(() {}),
                          ); // Refresh saat kembali
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await apiService.deleteSmartphone(hp.id!);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SmartphoneFormPage()),
        ).then((value) => setState(() {})), // Refresh saat kembali
      ),
    );
  }
}
