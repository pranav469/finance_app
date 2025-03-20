import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SpendingPieChart extends StatelessWidget {
  final Map<String, double> categoryAmount;

  const SpendingPieChart({super.key, required this.categoryAmount});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: PieChart(
        PieChartData(
          sections: categoryAmount.entries.map((entry) {
            return PieChartSectionData(
              color: Colors.primaries[categoryAmount.keys.toList().indexOf(entry.key) % Colors.primaries.length],
              value: entry.value,
              title: '${entry.key}\n₹${entry.value.toStringAsFixed(2)}',
              radius: 80,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList(),
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }
}
