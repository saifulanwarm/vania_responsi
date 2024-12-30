import 'package:flutter/material.dart';
import 'package:flutter_frontres/screen/login.dart';
import 'package:flutter_frontres/screen/change_key.dart';
import 'package:flutter_frontres/widget/button_nav.dart';
import 'package:flutter_frontres/service/auth.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  int _selectedIndex = 2;
  bool isLoading = true;
  String? errorMessage;
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await fetchProtectedData();
      setState(() {
        data = [
          {
            'id': response['data']['id'],
            'username': response['data']['username'],
            'email': response['data']['email'],
            'created_at': response['data']['created_at'],
          }
        ];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> handleHapusToken() async {
    try {
      await logout();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Access token berhasil dihapus!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghapus token: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Akun'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // Menghapus ikon back di AppBar
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Foto Profil di bagian atas
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                  ),
                  const Icon(
                    Icons.camera_alt,
                    color: Colors.black54,
                    size: 24.0,
                  ),
                ],
              ),
            ),
          ),

          // Identitas User
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: const Text(
              'Identitas User',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
                  ? Center(child: Text('Error: $errorMessage'))
                  : data.isEmpty
                      ? const Center(child: Text('No data available.'))
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: UserCard(userData: data[0]),
                        ),

          const SizedBox(height: 20),

          // Privasi & Keamanan Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: const Text(
              "Privasi & Keamanan",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // ListTile untuk Privasi & Keamanan
          Expanded(
            child: ListView(
              children: [
                _buildListTile("Kebijakan Privasi"),
                _buildListTile("Ketentuan Pemakaian"),
                _buildListTile("Panduan Komunitas"),
                _buildListTile(
                  "Ganti Kata Sandi",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePasswordPage()),
                    );
                  },
                ),
                const SizedBox(height: 28),
                _buildListTile(
                  "Log Out",
                  trailingIcon: Icons.logout,
                  onTap: () async {
                    await handleHapusToken();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildListTile(String title,
      {VoidCallback? onTap, IconData? trailingIcon}) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            trailing: Icon(trailingIcon ?? Icons.arrow_right_outlined,
                color: Colors.black, size: 16),
            onTap: onTap,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Divider(
            thickness: 1,
            color: Colors.grey[400],
            height: 0,
          ),
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/kategori');
    }
  }
}

class UserCard extends StatelessWidget {
  final Map<String, dynamic> userData;

  const UserCard({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${userData['id']}'),
            Text('Name: ${userData['username']}'),
            Text('Email: ${userData['email']}'),
            Text('Created At: ${userData['created_at']}'),
          ],
        ),
      ),
    );
  }
}
