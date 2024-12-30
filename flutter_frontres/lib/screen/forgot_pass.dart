import 'package:flutter/material.dart';
import '../widget/custom_button.dart'; // Import CustomButton

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: formKey, // Tambahkan Form dengan kunci _formKey
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.jpg',
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Lupa Password',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Masukkan email Anda dan tunggu kode verifikasi akan dikirimkan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 40),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Masukkan Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    bool isEmail = RegExp(r'\S+@\S+\.\S+').hasMatch(value);
                    if (!isEmail) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  label: 'Kirim',
                  onPressed: () {
                    // Panggil validasi Form dengan _formKey
                    if (formKey.currentState!.validate()) {
                      Navigator.pushNamed(context, '/splash_screen');
                    }
                  },
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
