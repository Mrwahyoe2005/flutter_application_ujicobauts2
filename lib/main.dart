import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // File ini otomatis dibuat oleh FlutterFire CLI

// Halaman utama dummy sementara
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FinTrack - Dashboard"),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Text(
          'Firebase Connected Successfully ✅',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const FinTrackApp());
}

class FinTrackApp extends StatelessWidget {
  const FinTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        fontFamily: 'Poppins', // ⬅️ Tambahkan baris ini
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
