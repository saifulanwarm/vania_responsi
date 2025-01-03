import 'package:flutter/material.dart';
import 'package:flutter_frontres/service/service_recipe.dart';  // Impor service_recipe.dart

class CreateRecipePage extends StatefulWidget {
  const CreateRecipePage({super.key});

  @override
  _CreateRecipePageState createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  final TextEditingController _idRecipeController = TextEditingController(); // ID Resep
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _deskripsiBahanController = TextEditingController();
  final TextEditingController _deskripsiInstruksiController = TextEditingController();
  final TextEditingController _makerController = TextEditingController();
  final TextEditingController _urlImageController = TextEditingController();
  final TextEditingController _idCategoryController = TextEditingController();
  bool _isLoading = false;

  void _createRecipe() async {
    // Mengambil data dari form
    int idRecipe = int.tryParse(_idRecipeController.text) ?? 0;  // ID Resep diubah menjadi integer
    String title = _titleController.text;
    String deskripsiBahan = _deskripsiBahanController.text;
    String deskripsiInstruksi = _deskripsiInstruksiController.text;
    String maker = _makerController.text;
    String urlImage = _urlImageController.text;

    // Pastikan URL gambar tidak kosong
    if (urlImage.isEmpty) {
      _showErrorDialog('URL gambar tidak boleh kosong.');
      return;
    }

    // Pastikan idCategory adalah integer
    int idCategory = int.tryParse(_idCategoryController.text) ?? 0;  // Parsing ke int

    setState(() {
      _isLoading = true;
    });

    try {
      // Panggil fungsi untuk menambahkan resep dengan ID Resep
      bool success = await createRecipe(idRecipe, title, deskripsiBahan, deskripsiInstruksi, maker, urlImage, idCategory);
      if (success) {
        _showSuccessDialog('Resep berhasil ditambahkan!');
      } else {
        _showErrorDialog('Gagal menambahkan resep.');
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
          'Tambah Resep', // Teks hanya ada di AppBar
          style: TextStyle(color: Colors.white), // Teks warna putih
        ),
        backgroundColor: Colors.blue, // AppBar warna biru
        iconTheme: const IconThemeData(color: Colors.white), // Ubah warna ikon menjadi putih
        leading: IconButton(  // Menambahkan tombol back arrow
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);  // Kembali ke halaman sebelumnya
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

              // Card untuk form input
              Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _idRecipeController,
                        decoration: const InputDecoration(
                          labelText: 'ID Resep',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Judul Resep',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _deskripsiBahanController,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi Bahan',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _deskripsiInstruksiController,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi Instruksi',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _makerController,
                        decoration: const InputDecoration(
                          labelText: 'Pembuat Resep',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _urlImageController,
                        decoration: const InputDecoration(
                          labelText: 'URL Gambar',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _idCategoryController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'ID Kategori',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createRecipe, // Disable button if loading
                  child: _isLoading
                      ? const CircularProgressIndicator() // Tampilkan loading saat proses
                      : const Text('Tambah Resep'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
