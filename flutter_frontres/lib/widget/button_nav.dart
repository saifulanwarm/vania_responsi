import 'package:flutter/material.dart';
import 'package:flutter_frontres/screen/settings.dart'; // Pastikan path sesuai
import 'package:flutter_frontres/screen/category.dart'; // Pastikan path sesuai

class BottomNavigationBarWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNavigationBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.stars_outlined),
          label: 'Kategori',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_pin),
          label: 'Akun',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blue,
      onTap: (index) {
        if (selectedIndex == index) {
          // Jika sudah di halaman yang sama, tidak perlu aksi tambahan
          return;
        }
        if (index == 1) {
          // Navigasi ke halaman KategoriPage dengan transisi animasi
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => KategoriPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0); // Mulai animasi dari kanan
                const end = Offset.zero; // Akhiri di posisi normal
                const curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(position: offsetAnimation, child: child);
              },
            ),
          );
        } else if (index == 2) {
          // Navigasi ke halaman pengaturan akun
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const AboutPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0); // Mulai animasi dari kanan
                const end = Offset.zero; // Akhiri di posisi normal
                const curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(position: offsetAnimation, child: child);
              },
            ),
          );
        } else {
          // Panggil callback untuk indeks lainnya
          onItemTapped(index);
        }
      },
    );
  }
}
