import 'package:flutter/material.dart';
import 'package:flutter_frontres/widget/button_nav.dart'; // Import BottomNavigationBarWidget

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  int _selectedIndex = 2; // Menandakan halaman FavoritePage dipilih

  // Fungsi untuk menangani pemilihan menu bottom navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushNamed(context, '/home'); // Navigasi ke Home
    } else if (index == 1) {
      Navigator.pushNamed(context, '/kategori'); // Navigasi ke Kategori
    } else if (index == 3) {
      Navigator.pushNamed(context, '/about'); // Navigasi ke Pengaturan
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite Page',
          style: TextStyle(color: Colors.white), // Warna teks putih
        ),
        backgroundColor: Colors.blue, // Warna appbar biru
        automaticallyImplyLeading: false, // Menghilangkan tombol back
      ),
      body: Center(
        child: Text('Ini masih belum ada konten'), // Tampilan kosong
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FavoritePage(),
  ));
}
