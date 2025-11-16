import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/firestore_service.dart';

class StatistikScreen extends StatefulWidget {
  const StatistikScreen({super.key});

  @override
  State<StatistikScreen> createState() => _StatistikScreenState();
}

class _StatistikScreenState extends State<StatistikScreen> {
  bool isLoading = true;
  double pemasukan = 0;
  double pengeluaran = 0;
  String selectedFilter = 'Semua';

  final List<String> filters = [
    'Hari ini',
    'Minggu ini',
    'Bulan ini',
    'Tahun ini',
    'Semua',
  ];

  @override
  void initState() {
    super.initState();
    _loadSummaryData();
  }

  Future<void> _loadSummaryData() async {
    final data = await FirestoreService().getSummaryData();
    setState(() {
      pemasukan = data['pemasukan'] ?? 0;
      pengeluaran = data['pengeluaran'] ?? 0;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = pemasukan + pengeluaran;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Keuangan'),
        backgroundColor: const Color(0xFF009688),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              setState(() => selectedFilter = value);
              // Filter belum aktif, masih placeholder
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
      backgroundColor: const Color(0xFFEAF7F4),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : total == 0
              ? const Center(
                  child: Text(
                    'Belum ada data transaksi',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    children: [
                      Text(
                        'Filter: $selectedFilter',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // PIE CHART
                      SizedBox(
                        height: 260,
                        child: PieChart(
                          PieChartData(
                            centerSpaceRadius: 60,
                            sectionsSpace: 4,
                            sections: [
                              PieChartSectionData(
                                color: Colors.teal,
                                value: pemasukan,
                                title:
                                    '${(pemasukan / total * 100).toStringAsFixed(1)}%',
                                radius: 70,
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              PieChartSectionData(
                                color: Colors.redAccent,
                                value: pengeluaran,
                                title:
                                    '${(pengeluaran / total * 100).toStringAsFixed(1)}%',
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

                      // DATA TEKS
                      Text(
                        'Total Pemasukan: Rp ${pemasukan.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                        style: const TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Total Pengeluaran: Rp ${pengeluaran.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.circle, size: 14, color: Colors.teal),
                          SizedBox(width: 4),
                          Text('Pemasukan   '),
                          Icon(Icons.circle, size: 14, color: Colors.redAccent),
                          SizedBox(width: 4),
                          Text('Pengeluaran'),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}
