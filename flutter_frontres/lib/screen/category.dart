import 'package:flutter/material.dart';
import 'package:flutter_frontres/widget/button_nav.dart';
import 'package:flutter_frontres/service/auth.dart';
import 'package:flutter_frontres/screen/edit_category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key});

  @override
  _KategoriPageState createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  int _selectedIndex = 1; // Sesuaikan index untuk menandai halaman aktif

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori'),
        backgroundColor: Colors.blue, // Warna AppBar biru
        foregroundColor: Colors.white, // Warna teks putih
        automaticallyImplyLeading: false, // Menghilangkan arrow back
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            iconSize: 30,
            onPressed: () {
              // Misalnya: Arahkan ke halaman tambah kategori
              Navigator.pushNamed(context, '/add_category'); // Ganti dengan rute yang sesuai
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchCategories(), // Fungsi untuk mengambil data kategori
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Tidak ada kategori yang tersedia'),
            );
          }

          final categories = snapshot.data!;
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(category['name'] ?? 'Tidak ada nama', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(category['description'] ?? 'Tidak ada deskripsi'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_square),
                        color: const Color.fromARGB(255, 6, 231, 63),
                        onPressed: () {
                          // Menavigasi ke halaman EditCategoryPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditCategoryPage(
                                idCategory: category['id_category'],
                                initialName: category['name'],
                                initialDescription: category['description'],
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          // Menampilkan dialog konfirmasi sebelum menghapus kategori
                          _showDeleteConfirmationDialog(category['id_category']);
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
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // Fungsi untuk fetch kategori dari API
  Future<List<dynamic>> fetchCategories() async {
    final url = Uri.parse('$baseUrl/list-category'); // Endpoint untuk mengambil kategori

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data']; // Mengembalikan data kategori dari API
      } else {
        final error = json.decode(response.body);
        throw Exception('Error: ${error['message'] ?? 'Server error'}');
      }
    } catch (e) {
      throw Exception('Error saat mengambil kategori: $e');
    }
  }

  // Fungsi untuk menampilkan dialog konfirmasi
  void _showDeleteConfirmationDialog(int idCategory) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Penghapusan'),
          content: const Text('Apakah Anda yakin ingin menghapus kategori ini?'),
          actions: <Widget>[
            // Tombol Cancel
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: const Text('Batal'),
            ),
            // Tombol Confirm (Hapus)
            TextButton(
              onPressed: () async {
                // Menutup dialog konfirmasi
                Navigator.of(context).pop();

                // Panggil fungsi untuk menghapus kategori
                await _deleteCategory(idCategory);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menghapus kategori
  Future<void> _deleteCategory(int idCategory) async {
    final url = Uri.parse('$baseUrl/hapus-category/$idCategory'); // Endpoint untuk menghapus kategori

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Jika berhasil menghapus, refresh data
        setState(() {
          fetchCategories(); // Memperbarui tampilan setelah penghapusan
        });

        // Menampilkan pesan berhasil dihapus
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kategori berhasil dihapus!')),
        );
      } else {
        final error = json.decode(response.body);
        throw Exception('Error: ${error['message'] ?? 'Server error'}');
      }
    } catch (e) {
      throw Exception('Error saat menghapus kategori: $e');
    }
  }

  // Fungsi untuk menangani navigasi antar halaman
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigasi antar halaman sesuai index
    if (index == 0) {
    Navigator.pushNamed(context, '/home'); // Navigasi ke HomePage
  } else if (index == 1) {
    Navigator.pushNamed(context, '/favorite'); // Navigasi ke AboutPage
  } else if (index == 2) {
    Navigator.pushNamed(context, '/about'); 
  }
  }
}
