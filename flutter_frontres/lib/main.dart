import 'package:flutter/material.dart';
import 'package:flutter_frontres/screen/category.dart';
import 'package:flutter_frontres/screen/register.dart';
import 'package:flutter_frontres/screen/splash_screen.dart';
import 'package:flutter_frontres/screen/home.dart';
import 'screen/login.dart';
import 'screen/add_category.dart';
import 'screen/forgot_pass.dart';
// import 'screen/home.dart';
// import 'screens/profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Navigation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splash_screen',
      routes: {
        '/splash_screen': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/forgot_password': (context) => const ForgotPasswordPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/kategori': (context) => const KategoriPage(),
        '/add_category': (context) => const AddCategoryPage(),
      },
    );
  }
}

