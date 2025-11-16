import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class TransaksiScreen extends StatefulWidget {
  const TransaksiScreen({super.key});

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedType = 'Pemasukan';
  bool _isLoading = false; // 🔹 untuk mencegah klik ganda

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final int amount = int.parse(_amountController.text.trim());
    final String description = _descController.text.trim();

    try {
      await FirestoreService().addTransaction(
        type: _selectedType,
        amount: amount,
        description: description,
      );

      if (mounted) {
        Navigator.pop(context); // 🔹 langsung tutup setelah sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Transaksi berhasil disimpan!'),
            backgroundColor: Colors.green[600],
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan transaksi: $e'),
          backgroundColor: Colors.red[600],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00695C),
        title: const Text(
          'Riwayat Transaksi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Stack(
        children: [
          StreamBuilder(
            stream: FirestoreService().getUserTransactions(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = snapshot.data!.docs;
              if (docs.isEmpty) {
                return const Center(
                  child: Text(
                    'Belum ada transaksi',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data();
                  final id = data['id'];
                  final type = data['type'];
                  final amount = data['amount'];
                  final desc = data['description'];
                  final color =
                      type == 'Pemasukan' ? Colors.green : Colors.redAccent;
                  final icon =
                      type == 'Pemasukan' ? Icons.arrow_downward : Icons.arrow_upward;

                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Icon(icon, color: color),
                      title: Text(desc,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        type,
                        style: TextStyle(color: color, fontSize: 13),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await FirestoreService().deleteTransaction(id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),

          // 🔹 Dialog tambah transaksi
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FloatingActionButton(
                backgroundColor: const Color(0xFF009688),
                child: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Text(
                          'Tambah Transaksi',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DropdownButtonFormField<String>(
                                value: _selectedType,
                                items: const [
                                  DropdownMenuItem(
                                      value: 'Pemasukan',
                                      child: Text('Pemasukan')),
                                  DropdownMenuItem(
                                      value: 'Pengeluaran',
                                      child: Text('Pengeluaran')),
                                ],
                                onChanged: (value) {
                                  setState(() => _selectedType = value!);
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Jenis Transaksi',
                                ),
                              ),
                              TextFormField(
                                controller: _amountController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Jumlah (Rp)',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Masukkan jumlah';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _descController,
                                decoration: const InputDecoration(
                                  labelText: 'Deskripsi',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Masukkan deskripsi';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Batal'),
                          ),
                          ElevatedButton(
                            onPressed:
                                _isLoading ? null : _saveTransaction, // 🔹 disable saat loading
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF009688),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Simpan'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
