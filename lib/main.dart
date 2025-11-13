import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/statistik_screen.dart';

void main() {
  runApp(const FinTrackApp());
}

class FinTrackApp extends StatelessWidget {
  const FinTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FinTrack',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00897B)),
        fontFamily: 'Poppins',
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // daftar transaksi utama (akan dipakai di kedua halaman)
  List<Map<String, dynamic>> transactions = [
    {'title': 'Gaji Bulanan', 'amount': 8500000, 'type': 'Pemasukan', 'date': DateTime(2025, 11, 1)},
    {'title': 'Makan Siang', 'amount': 45000, 'type': 'Pengeluaran', 'date': DateTime(2025, 11, 5)},
    {'title': 'Transportasi', 'amount': 25000, 'type': 'Pengeluaran', 'date': DateTime(2025, 11, 7)},
    {'title': 'Investasi', 'amount': 1000000, 'type': 'Pengeluaran', 'date': DateTime(2025, 11, 9)},
  ];

  // Fungsi untuk menambah transaksi baru dari Dashboard
  void addTransaction(String title, int amount, String type) {
    setState(() {
      transactions.add({
        'title': title,
        'amount': amount,
        'type': type,
        'date': DateTime.now(),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(transactions: transactions, onAddTransaction: addTransaction),
      StatistikScreen(transactions: transactions),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFF00897B),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Transaksi'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Statistik'),
        ],
      ),
    );
  }
}
