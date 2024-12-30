import 'package:flutter/material.dart';
import 'package:flutter_frontres/service/auth.dart';  // Impor auth.dart

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _idCategoryController = TextEditingController();
  bool _isLoading = false;

  void _addCategory() async {
    // Mengambil data dari form
    int idCategory = int.parse(_idCategoryController.text);
    String name = _nameController.text;
    String description = _descriptionController.text;

    setState(() {
      _isLoading = true;
    });

    try {
      // Panggil fungsi createCategory dari auth.dart
      bool success = await createCategory(idCategory, name, description);
      if (success) {
        _showSuccessDialog('Kategori berhasil ditambahkan!');
      } else {
        _showErrorDialog('Gagal menambahkan kategori.');
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Berhasil'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                Navigator.pop(context); // Kembali ke halaman sebelumnya
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Gagal'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Kategori', // Teks hanya ada di AppBar
          style: TextStyle(color: Colors.white), // Teks warna putih
        ),
        backgroundColor: Colors.blue, // AppBar warna biru
        iconTheme: const IconThemeData(color: Colors.white), // Ubah warna ikon menjadi putih
        leading: IconButton(  // Menambahkan tombol back arrow
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/kategori');  // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 24.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              TextField(
                controller: _idCategoryController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ID Kategori',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kategori',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Kategori',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _addCategory, // Disable button if loading
                  child: _isLoading
                      ? const CircularProgressIndicator() // Tampilkan loading saat proses
                      : const Text('Tambah Kategori'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
