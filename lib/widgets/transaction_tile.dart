import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionTile extends StatelessWidget {
  final Transaction tx;
  const TransactionTile({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return ListTile(
      leading: Icon(
        tx.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
        color: tx.isIncome ? Colors.green : Colors.red,
        size: 28,
      ),
      title: Text(
        tx.title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        tx.description,
        style: const TextStyle(color: Colors.black54),
      ),
      trailing: Text(
        (tx.isIncome ? '+ ' : '- ') + formatCurrency.format(tx.amount),
        style: TextStyle(
          color: tx.isIncome ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }
}
