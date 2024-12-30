import 'package:flutter/material.dart';
import 'package:flutter_frontres/service/auth.dart';

class EditCategoryPage extends StatefulWidget {
  final int idCategory;
  final String initialName;
  final String initialDescription;

  const EditCategoryPage({
    Key? key,
    required this.idCategory,
    required this.initialName,
    required this.initialDescription,
  }) : super(key: key);

  @override
  _EditCategoryPageState createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName;
    _descriptionController.text = widget.initialDescription;
  }

  // Fungsi untuk memperbarui kategori
  void _updateCategory() async {
    final name = _nameController.text;
    final description = _descriptionController.text;

    if (name.isEmpty || description.isEmpty) {
      _showErrorDialog('Nama dan deskripsi kategori tidak boleh kosong');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await updateCategory(widget.idCategory, name, description);
      _showSuccessDialog('Kategori berhasil diperbarui!');
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Dialog untuk menampilkan pesan sukses
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

  // Dialog untuk menampilkan pesan error
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
        title: const Text('Edit Kategori', style: TextStyle(color: Colors.white)), // Teks putih
        backgroundColor: Colors.blue, // Warna latar belakang AppBar biru
        iconTheme: const IconThemeData(color: Colors.white), // Ikon back arrow putih
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
                maxLines: 3, // Membatasi deskripsi agar lebih panjang
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateCategory, // Disable jika sedang loading
                  child: _isLoading
                      ? const CircularProgressIndicator() // Tampilkan indikator loading
                      : const Text('Simpan Perubahan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
