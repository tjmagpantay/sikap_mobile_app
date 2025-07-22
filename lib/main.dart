import 'package:flutter/material.dart';
import 'package:sikap/pages/splash_screen.dart';
import 'package:sikap/pages/home_screen.dart';
import 'package:sikap/pages/job_list_screen.dart';
import 'package:sikap/pages/saved_jobs.dart';
import 'package:sikap/pages/profile_screen.dart';
import 'package:sikap/pages/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sikap',
      theme: ThemeData(fontFamily: 'Inter'),
      home: const SplashScreen(), // Always start with SplashScreen
      routes: {
        '/home': (context) => const HomePage(),
        '/jobs': (context) => const JobList(),
        '/saved': (context) => const SavedJobs(),
        '/profile': (context) => const Profile(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
