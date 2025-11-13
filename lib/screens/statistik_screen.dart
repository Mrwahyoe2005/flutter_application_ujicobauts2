import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class StatistikScreen extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;

  const StatistikScreen({super.key, required this.transactions});

  @override
  State<StatistikScreen> createState() => _StatistikScreenState();
}

class _StatistikScreenState extends State<StatistikScreen> {
  String selectedRange = 'Semua';

  List<Map<String, dynamic>> getFilteredTransactions() {
    final now = DateTime.now();
    switch (selectedRange) {
      case 'Hari ini':
        return widget.transactions
            .where((t) => DateFormat('yyyy-MM-dd').format(t['date']) ==
                DateFormat('yyyy-MM-dd').format(now))
            .toList();
      case 'Minggu ini':
        return widget.transactions
            .where((t) =>
                t['date'].isAfter(now.subtract(const Duration(days: 7))) &&
                t['date'].isBefore(now.add(const Duration(days: 1))))
            .toList();
      case 'Bulan ini':
        return widget.transactions
            .where((t) =>
                t['date'].year == now.year && t['date'].month == now.month)
            .toList();
      case 'Tahun ini':
        return widget.transactions.where((t) => t['date'].year == now.year).toList();
      default:
        return widget.transactions;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = getFilteredTransactions();
    final income = filtered
        .where((t) => t['type'] == 'Pemasukan')
        .fold<int>(0, (sum, item) => sum + (item['amount'] as int));
    final expense = filtered
        .where((t) => t['type'] == 'Pengeluaran')
        .fold<int>(0, (sum, item) => sum + (item['amount'] as int));

    final data = filtered.map((t) {
      final isIncome = t['type'] == 'Pemasukan';
      return {
        'title': t['title'],
        'amount': t['amount'],
        'color': isIncome ? Colors.teal : Colors.redAccent,
      };
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00897B),
        title: const Text('Statistik Keuangan',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Dropdown filter waktu
            Align(
              alignment: Alignment.centerRight,
              child: DropdownButton<String>(
                value: selectedRange,
                items: const [
                  DropdownMenuItem(value: 'Hari ini', child: Text('Hari ini')),
                  DropdownMenuItem(value: 'Minggu ini', child: Text('Minggu ini')),
                  DropdownMenuItem(value: 'Bulan ini', child: Text('Bulan ini')),
                  DropdownMenuItem(value: 'Tahun ini', child: Text('Tahun ini')),
                  DropdownMenuItem(value: 'Semua', child: Text('Semua')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedRange = value!;
                  });
                },
                underline: Container(),
              ),
            ),

            const SizedBox(height: 16),

            // Pie chart
            Expanded(
              child: data.isEmpty
                  ? const Center(child: Text('Tidak ada transaksi untuk periode ini'))
                  : PieChart(
                      PieChartData(
                        sections: data.map((item) {
                          final total = income + expense;
                          final percent =
                              total > 0 ? (item['amount'] / total) * 100 : 0;
                          return PieChartSectionData(
                            color: item['color'],
                            value: item['amount'].toDouble(),
                            title: '${percent.toStringAsFixed(1)}%',
                            radius: 70,
                            titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          );
                        }).toList(),
                      ),
                    ),
            ),

            const SizedBox(height: 16),

            // Total income & expense
            Text('Total Pemasukan: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(income)}',
                style: const TextStyle(color: Colors.green, fontSize: 16)),
            Text('Total Pengeluaran: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(expense)}',
                style: const TextStyle(color: Colors.red, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
