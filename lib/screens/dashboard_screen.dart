import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;
  final Function(String, int, String) onAddTransaction;

  const DashboardScreen({
    super.key,
    required this.transactions,
    required this.onAddTransaction,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  String selectedType = 'Pemasukan';

  void _showAddTransactionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Center(
            child: Text('Tambah Transaksi',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Nama Transaksi'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Jumlah (Rp)'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
              initialValue: selectedType,

                items: const [
                  DropdownMenuItem(value: 'Pemasukan', child: Text('Pemasukan')),
                  DropdownMenuItem(value: 'Pengeluaran', child: Text('Pengeluaran')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Kategori'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00897B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                ),
                onPressed: () {
                  final title = titleController.text;
                  final amount = int.tryParse(amountController.text) ?? 0;
                  if (title.isNotEmpty && amount > 0) {
                    widget.onAddTransaction(title, amount, selectedType);
                    Navigator.pop(context);
                    titleController.clear();
                    amountController.clear();
                  }
                },
                child: const Text('Simpan', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactions = widget.transactions;

    int totalIncome = transactions
        .where((t) => t['type'] == 'Pemasukan')
        .fold<int>(0, (sum, item) => sum + (item['amount'] as int));

    int totalExpense = transactions
        .where((t) => t['type'] == 'Pengeluaran')
        .fold<int>(0, (sum, item) => sum + (item['amount'] as int));

    int balance = totalIncome - totalExpense;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00897B),
        title: const Text('FinTrack Dashboard',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card saldo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF00897B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Saldo',
                      style: TextStyle(color: Colors.white70, fontSize: 16)),
                  Text(
                    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
                        .format(balance),
                    style: const TextStyle(
                        color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text('Transaksi Terbaru',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
            const SizedBox(height: 12),

            Column(
              children: transactions.map((t) {
                final isIncome = t['type'] == 'Pemasukan';
                final date = DateFormat('dd MMM yyyy').format(t['date']);
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(t['title'],
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    trailing: Text(
                      '${isIncome ? '+' : '-'} Rp ${t['amount']}',
                      style: TextStyle(
                          color: isIncome ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00897B),
        onPressed: () => _showAddTransactionDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
