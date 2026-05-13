import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartphone/model/smartphone_model.dart';

class ApiService {
  final String baseUrl = "http://localhost:8000/api/smartphones";

  Future<List<Smartphone>> getSmartphones() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200){
      List data = json.decode(response.body);
      return data.map((item) => Smartphone.fromJson(item)).toList();
    } else{
      throw Exception("failed to laod data");
    }
  }

  Future<void> addSmartphone(Smartphone smartphone) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(smartphone.toJson()),
    );
  }

  Future<void> updateSmartphone(int id, Smartphone smartphone) async {
    await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(smartphone.toJson()),
    );
  }

  Future<void> deleteSmartphone(int id) async {
    await http.delete(Uri.parse("$baseUrl/$id"));
  }

  Future<List<dynamic>> prosesVikor()async{
    final response = await http.get(Uri.parse("http://localhost:8000/api/spk/vikor-proses"));
    if (response.statusCode == 200){
      return json.decode(response.body);
    }else{
      throw Exception("Gagal memproses vikor");
    }
  }

  Future<List<dynamic>> prosesWP()async{
    final response = await http.get(Uri.parse("http://localhost:8000/api/spk/wp-proses"),
    headers: {"Accept": "application/json"},
    );
    if (response.statusCode == 200){
      return json.decode(response.body);
    }else{
      throw Exception("Gagal memproses wp");
    }
  }

  Future<Map<String, dynamic>> getPerbandingan() async {
    final response = await http.get(Uri.parse("http://localhost:8000/api/spk/perbandingan"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Gagal mengambil data perbandingan. Pastikan sudah klik proses WP & VIKOR.");
    }
  }

  Future<List<dynamic>> getVikorRanking() async {
    final response = await http.get(Uri.parse("http://localhost:8000/api/spk/vikor-ranking"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Gagal mengambil data grafik");
    }
  }

  Future<List<dynamic>> getWpRanking() async {
    final response = await http.get(Uri.parse("http://localhost:8000/api/spk/wp-ranking"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Gagal mengambil data grafik WP");
    }
  }
}