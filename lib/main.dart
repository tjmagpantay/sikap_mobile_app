import 'package:flutter/material.dart';
import 'package:sikap/pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sikap',
      theme: ThemeData(fontFamily: 'Inter'),
      home: const SplashScreen(),
    );
  }
}