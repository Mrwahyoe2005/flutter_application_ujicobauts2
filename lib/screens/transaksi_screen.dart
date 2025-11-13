import 'package:flutter/material.dart';

class TransaksiScreen extends StatelessWidget {
  const TransaksiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Halaman Transaksi',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
