import 'package:flutter/material.dart';
import 'package:flutter_frontres/service/auth.dart';  // Impor auth.dart

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  void _changePassword() async {
    if (_passwordController.text == _confirmPasswordController.text) {
      setState(() {
        _isLoading = true;
      });
      try {
        await updatePassword(_passwordController.text); // Panggil fungsi updatePassword dari auth.dart
        _showSuccessDialog('Kata sandi berhasil diperbarui!');
      } catch (e) {
        _showErrorDialog(e.toString());
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      _showErrorDialog('Kata sandi dan konfirmasi tidak cocok');
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
          'Ganti Kata Sandi', // Teks hanya ada di AppBar
          style: TextStyle(color: Colors.white), // Teks warna putih
        ),
        backgroundColor: Colors.blue, // AppBar warna biru
        iconTheme: const IconThemeData(color: Colors.white), // Ubah warna ikon menjadi putih
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
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Kata Sandi Baru',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Konfirmasi Kata Sandi',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _changePassword, // Disable button if loading
                  child: _isLoading
                      ? const CircularProgressIndicator() // Tampilkan loading saat proses
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
