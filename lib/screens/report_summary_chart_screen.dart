import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportSummaryChartScreen extends StatelessWidget {
  const ReportSummaryChartScreen({super.key});

  Future<Map<String, int>> _fetchReportCountsByDate() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('reports')
        .orderBy('timestamp', descending: false)
        .get();

    final Map<String, int> counts = {};
    for (var doc in snapshot.docs) {
      final timestamp = doc['timestamp'] as Timestamp?;
      if (timestamp != null) {
        final date = timestamp.toDate();
        final formattedDate = '${date.day}/${date.month}';
        counts[formattedDate] = (counts[formattedDate] ?? 0) + 1;
      }
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Summary')),
      body: FutureBuilder<Map<String, int>>(
        future: _fetchReportCountsByDate(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final entries = snapshot.data!.entries.toList();
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < entries.length) {
                          return Text(entries[index].key, style: const TextStyle(fontSize: 10));
                        }
                        return const Text('');
                      },
                      reservedSize: 32,
                    ),
                  ),
                ),
                barGroups: entries.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: data.value.toDouble(),
                        color: Colors.blue,
                        width: 16,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
