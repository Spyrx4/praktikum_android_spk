import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smartphone/controller/api_service.dart';

class VikorChartPage extends StatelessWidget {
  const VikorChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Visualisasi Skor VIKOR (Q)"),
        backgroundColor: Colors.deepOrange,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ApiService().getVikorRanking(),
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

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  "Grafik Perbandingan Nilai Q",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "(Semakin rendah grafik, semakin baik alternatifnya)",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 1.1,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          // Dalam fl_chart terbaru mungkin deprecated, tapi kita gunakan yg sesuai PDF
                          // default lama: tooltipBgColor: Colors.blueGrey,
                          // Jika butuh patch di versi sangat baru, biasanya getTooltipColor: (group) => Colors.blueGrey
                          getTooltipColor: (group) => Colors.blueGrey,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              "${data[groupIndex]['nama_hp']}\n",
                              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: "Q: ${double.parse(data[groupIndex]['skor'].toString()).toStringAsFixed(4)}",
                                  style: const TextStyle(color: Colors.orangeAccent),
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
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) => Text(value.toStringAsFixed(1)),
                          ),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: const FlGridData(show: true, drawVerticalLine: false),
                      borderData: FlBorderData(show: false),
                      barGroups: data.asMap().entries.map((e) {
                        final skorSkala = double.parse(e.value['skor'].toString());
                        // Jika skor 0 (peringkat 1), berikan tinggi visual 0.03 agar batang deepOrange muncul sedikit
                        final tinggiVisual = skorSkala == 0 ? 0.03 : skorSkala;

                        return BarChartGroupData(
                          x: e.key,
                          barRods: [
                            BarChartRodData(
                              toY: tinggiVisual,
                              color: e.value['ranking'] == 1 ? Colors.deepOrange : Colors.orangeAccent,
                              width: 25,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: 1.1,
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
                    _buildLegendItem(Colors.deepOrange, "Peringkat 1"),
                    const SizedBox(width: 20),
                    _buildLegendItem(Colors.orangeAccent, "Alternatif Lain"),
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
