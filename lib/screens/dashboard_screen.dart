import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../widgets/transaction_tile.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

    final transactions = [
      Transaction(
        title: 'Gaji Bulanan',
        description: 'Pendapatan utama bulan ini',
        amount: 8500000,
        date: DateTime(2025, 11, 1),
        isIncome: true,
      ),
      Transaction(
        title: 'Makan Siang',
        description: 'Warung Nasi Ayam',
        amount: 25000,
        date: DateTime(2025, 11, 3),
        isIncome: false,
      ),
      Transaction(
        title: 'Proyek Freelance',
        description: 'Pendapatan tambahan',
        amount: 1500000,
        date: DateTime(2025, 11, 8),
        isIncome: true,
      ),
    ];

    final double totalIncome = transactions
        .where((tx) => tx.isIncome)
        .fold(0, (sum, tx) => sum + tx.amount);

    final double totalExpense = transactions
        .where((tx) => !tx.isIncome)
        .fold(0, (sum, tx) => sum + tx.amount);

    final double balance = totalIncome - totalExpense;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  'Saldo Saat Ini',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                Text(
                  formatCurrency.format(balance),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return TransactionTile(tx: transactions[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
