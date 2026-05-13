import 'package:flutter/material.dart';
import 'package:smartphone/model/smartphone_model.dart';
import 'package:smartphone/controller/api_service.dart';

class SmartphoneFormPage extends StatefulWidget {
  final Smartphone? smartphone;

  const SmartphoneFormPage({super.key, this.smartphone});

  @override
  State<SmartphoneFormPage> createState() => _SmartphoneFormPageState();
}

class _SmartphoneFormPageState extends State<SmartphoneFormPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  late TextEditingController _namaController;
  late TextEditingController _hargaController;
  late TextEditingController _ramController;
  late TextEditingController _kameraController;
  late TextEditingController _bateraiController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data lama jika sedang mode edit
    _namaController = TextEditingController(text: widget.smartphone?.namaHp ?? "");
    _hargaController = TextEditingController(text: widget.smartphone?.harga.toString() ?? "");
    _ramController = TextEditingController(text: widget.smartphone?.ram.toString() ?? "");
    _kameraController = TextEditingController(text: widget.smartphone?.kamera.toString() ?? "");
    _bateraiController = TextEditingController(text: widget.smartphone?.baterai.toString() ?? "");
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _ramController.dispose();
    _kameraController.dispose();
    _bateraiController.dispose();
    super.dispose();
  }

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      Smartphone hpData = Smartphone(
        id: widget.smartphone?.id,
        namaHp: _namaController.text,
        harga: double.parse(_hargaController.text),
        ram: double.parse(_ramController.text),
        kamera: double.parse(_kameraController.text),
        baterai: double.parse(_bateraiController.text),
      );

      if (widget.smartphone == null) {
        await apiService.addSmartphone(hpData);
      } else {
        await apiService.updateSmartphone(widget.smartphone!.id!, hpData);
      }

      if (!mounted) return;
      Navigator.pop(context); // Kembali ke list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.smartphone == null ? "Tambah Smartphone" : "Edit Smartphone"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: "Nama Smartphone"),
                validator: (v) => v!.isEmpty ? "Harus diisi" : null,
              ),
              TextFormField(
                controller: _hargaController,
                decoration: InputDecoration(
                  labelText: "Harga (Contoh:3500000)",
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _ramController,
                decoration: InputDecoration(labelText: "RAM (GB)"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _kameraController,
                decoration: InputDecoration(labelText: "Kamera (MP)"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _bateraiController,
                decoration: InputDecoration(labelText: "Baterai (mAh)"),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                child: Text(widget.smartphone == null ? "Simpan Data" : "Update Data"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
