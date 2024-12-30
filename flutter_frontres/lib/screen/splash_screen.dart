import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animationOffset;
  late bool _showWelcomeGif;

  @override
  void initState() {
    super.initState();
    _showWelcomeGif = false;

    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _animationOffset = Tween<Offset>(begin: const Offset(-1.0, -1.0), end: const Offset(1.0, 1.0)).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showWelcomeGif = true;
      });
    });

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildCircle({
    double? top,
    double? left,
    double? right,
    double? bottom,
    required double radius,
    required Color color,
  }) {
    return AnimatedBuilder(
      animation: _animationOffset,
      builder: (context, child) {
        return Positioned(
          top: top != null ? top + _animationOffset.value.dy * 100 : null,
          left: left != null ? left + _animationOffset.value.dx * 100 : null,
          right: right != null ? right - _animationOffset.value.dx * 100 : null,
          bottom: bottom != null ? bottom - _animationOffset.value.dy * 100 : null,
          child: CircleAvatar(
            radius: radius,
            backgroundColor: color,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.white),
          // Lingkaran yang lebih terpisah
          buildCircle(top: -60, left: -60, radius: 90, color: Colors.blue),
          buildCircle(top: 20, right: -20, radius: 70, color: Colors.red),
          buildCircle(top: 200, left: 100, radius: 80, color: Colors.blue.withOpacity(0.8)),
          buildCircle(bottom: 150, left: 200, radius: 100, color: Colors.red.withOpacity(0.5)),
          buildCircle(bottom: -100, right: -60, radius: 110, color: Colors.blue),
          buildCircle(top: 300, left: 150, radius: 70, color: Colors.red.withOpacity(0.6)),
          buildCircle(top: 150, right: 250, radius: 90, color: Colors.blue.withOpacity(0.5)),
          buildCircle(bottom: 50, left: 280, radius: 100, color: Colors.red.withOpacity(0.3)),
          buildCircle(bottom: -50, left: -30, radius: 140, color: Colors.blue),
          buildCircle(bottom: 150, right: -60, radius: 90, color: Colors.red),
          // Tampilkan GIF "Welcome" jika sudah waktunya
          if (_showWelcomeGif)
            Center(
              child: AnimatedOpacity(
                opacity: 1.0,
                duration: Duration(seconds: 3),
                child: Image.asset(
                  'assets/images/welcome.gif', // Pastikan path ini sesuai dengan lokasi GIF di assets
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
