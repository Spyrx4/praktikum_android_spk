import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smartphone/controller/api_service.dart';

class WpChartPage extends StatelessWidget {
  const WpChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Visualisasi Skor WP (V)"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ApiService().getWpRanking(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Data kosong. Silakan proses hitung dulu."));
          }

          final data = snapshot.data!;
          
          // Cari nilai maksimum V secara dinamis untuk menentukan skala sumbu Y
          double maxSkor = data
              .map((e) => double.parse(e['skor'].toString()))
              .reduce((curr, next) => curr > next ? curr : next);
          
          // Atur batas atas sumbu Y agar ada ruang sekitar 20% di atas batang tertinggi
          double dynamicMaxY = maxSkor > 0 ? maxSkor * 1.2 : 0.1;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  "Grafik Perbandingan Nilai V (WP)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "(Semakin tinggi grafik, semakin baik alternatifnya)",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: dynamicMaxY,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (group) => Colors.blueGrey[900]!,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              "${data[groupIndex]['nama_hp']}\n",
                              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: "V: ${double.parse(data[groupIndex]['skor'].toString()).toStringAsFixed(4)}",
                                  style: const TextStyle(color: Colors.lightBlueAccent),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              int index = value.toInt();
                              if (index >= 0 && index < data.length) {
                                String name = data[index]['nama_hp'].toString().split(' ')[0];
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(name, style: const TextStyle(fontSize: 10)),
                                );
                              }
                              return const Text("");
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 45,
                            getTitlesWidget: (value, meta) => Text(value.toStringAsFixed(3)),
                          ),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: const FlGridData(show: true, drawVerticalLine: false),
                      borderData: FlBorderData(show: false),
                      barGroups: data.asMap().entries.map((e) {
                        final skor = double.parse(e.value['skor'].toString());
                        return BarChartGroupData(
                          x: e.key,
                          barRods: [
                            BarChartRodData(
                              toY: skor,
                              color: e.value['ranking'] == 1 ? Colors.indigo : Colors.blueAccent,
                              width: 25,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: dynamicMaxY,
                                color: Colors.grey[200],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendItem(Colors.indigo, "Peringkat 1"),
                    const SizedBox(width: 20),
                    _buildLegendItem(Colors.blueAccent, "Alternatif Lain"),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}
