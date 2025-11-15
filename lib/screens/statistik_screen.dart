import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatistikPage extends StatefulWidget {
  const StatistikPage({super.key});

  @override
  State<StatistikPage> createState() => _StatistikPageState();
}

class _StatistikPageState extends State<StatistikPage> {
  String selectedFilter = 'Semua';

  final List<String> filters = [
    'Hari ini',
    'Minggu ini',
    'Bulan ini',
    'Tahun ini',
    'Semua',
  ];

  @override
  Widget build(BuildContext context) {
    final double totalPemasukan = 8500000;
    final double totalPengeluaran = 1070000;
    final double total = totalPemasukan + totalPengeluaran;

    final double persenMasuk = (totalPemasukan / total) * 100;
    final double persenKeluar = (totalPengeluaran / total) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Keuangan'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              setState(() => selectedFilter = value);
            },
            itemBuilder: (context) => filters
                .map((f) => PopupMenuItem<String>(
                      value: f,
                      child: Text(f),
                    ))
                .toList(),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Text(
            'Filter: $selectedFilter',
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 260,
            width: 260,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 60,
                sectionsSpace: 2,
                sections: [
                  PieChartSectionData(
                    color: Colors.teal,
                    value: totalPemasukan,
                    title: '${persenMasuk.toStringAsFixed(1)}%',
                    radius: 70,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.red,
                    value: totalPengeluaran,
                    title: '${persenKeluar.toStringAsFixed(1)}%',
                    radius: 70,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Total Pemasukan: Rp ${totalPemasukan.toStringAsFixed(0)}',
            style: const TextStyle(
                color: Colors.green, fontWeight: FontWeight.bold),
          ),
          Text(
            'Total Pengeluaran: Rp ${totalPengeluaran.toStringAsFixed(0)}',
            style:
                const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.circle, size: 14, color: Colors.teal),
              SizedBox(width: 4),
              Text('Pemasukan   '),
              Icon(Icons.circle, size: 14, color: Colors.red),
              SizedBox(width: 4),
              Text('Pengeluaran'),
            ],
          ),
        ],
      ),
    );
  }
}
