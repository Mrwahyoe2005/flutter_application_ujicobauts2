import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;

  // Tambah transaksi baru
  Future<void> addTransaction({
    required String type,
    required int amount,
    required String description,
  }) async {
    if (_user == null) return;

    final transactionRef = _db
        .collection('users')
        .doc(_user!.uid)
        .collection('transactions')
        .doc();

    await transactionRef.set({
      'id': transactionRef.id,
      'type': type,
      'amount': amount,
      'description': description,
      'date': FieldValue.serverTimestamp(),
    });
  }

  // Ambil semua transaksi user
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserTransactions() {
    return _db
        .collection('users')
        .doc(_user!.uid)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots();
  }

  // Hapus transaksi
  Future<void> deleteTransaction(String id) async {
    if (_user == null) return;

    await _db
        .collection('users')
        .doc(_user!.uid)
        .collection('transactions')
        .doc(id)
        .delete();
  }

  // 🔹 Tambahan baru: Hitung total saldo user secara real-time
  Stream<double> getUserBalance() {
    if (_user == null) return const Stream.empty();

    return _db
        .collection('users')
        .doc(_user!.uid)
        .collection('transactions')
        .snapshots()
        .map((snapshot) {
      double total = 0;
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final amount = (data['amount'] ?? 0).toDouble();
        final type = data['type'] ?? 'Pemasukan';
        if (type == 'Pemasukan') {
          total += amount;
        } else {
          total -= amount;
        }
      }
      return total;
    });
  }
}
