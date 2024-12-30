import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_frontres/service/auth.dart'; // Asumsi package ini digunakan untuk login
// import 'package:flutter_frontres/screen/home.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await login(_identifierController.text, _passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login berhasil!")),
      );
      // Navigasi setelah login sukses
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login gagal: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/images/log.png',
              width: 240,
              height: 240,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                'assets/images/logi.png',
                width: 270,
                height: 270,
              ),
            ),
          ),
          // Bagian form login dalam SingleChildScrollView
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Image.asset(
                    'assets/images/logo.jpg',
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Masukkan email',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _identifierController,
                    decoration: InputDecoration(
                      labelText: ' Email',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username atau Email tidak boleh kosong';
                      }
                      bool isEmail = RegExp(r'\S+@\S+\.\S+').hasMatch(value);
                      if (!isEmail && value.length < 4) {
                        return 'Username harus minimal 4 karakter atau format email harus valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Masukkan password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password tidak boleh kosong';
                      }
                      if (value.length < 6) {
                        return 'Password harus minimal 6 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14),
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Belum punya akun? ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: 'Daftar  ',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, '/register');
                            },
                        ),
                        const TextSpan(
                          text: '      ',
                        ),
                        TextSpan(
                          text: 'Lupa password?',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, '/forgot_password');
                            },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _isLoading ? null : handleLogin,
                    child: Text(_isLoading ? "Loading..." : "Masuk"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, 
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40), // Menambahkan padding lebih besar
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Membuat border lebih besar
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18, // Ukuran teks lebih besar
                      ),
                    ),
                  ),
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
