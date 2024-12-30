import 'package:flutter/material.dart';
import 'package:flutter_frontres/widget/button_nav.dart';
import 'package:flutter_frontres/screen/settings.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Menyimpan indeks item yang dipilih di BottomNavigationBar
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Home Page', style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false, // Menghilangkan arrow back
        actions: [
          // Ikon Favorite dengan warna merah
          IconButton(
            icon: Icon(Icons.favorite_sharp),
            color: const Color.fromARGB(255, 246, 33, 18), // Mengubah warna ikon menjadi merah
            iconSize: 30, // Mengubah ukuran ikon favorite
            onPressed: () {
              // Tindakan untuk favorite
              print('Favorite item');
            },
          ),
          // Ikon Add dengan warna putih dan ukuran lebih besar, berada di paling kanan
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.white, // Mengubah warna ikon menjadi putih
            iconSize: 35, // Mengubah ukuran ikon add
            onPressed: () {
              // Tindakan untuk menambahkan item baru
              print('Add item');
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: <Widget>[
          // Konten Home
          Center(child: Text('Konten Home')),
          // Konten Kategori
          Center(child: Text('Konten Kategori')),
          // Konten Akun (AboutPage)
          const AboutPage(),
        ],
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
    home: HomePage(),
  ));
}
