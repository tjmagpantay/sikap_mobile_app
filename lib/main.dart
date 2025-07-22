import 'package:flutter/material.dart';
import 'package:sikap/pages/splash_screen.dart';
import 'package:sikap/pages/home_screen.dart';
import 'package:sikap/pages/job_list_screen.dart';
import 'package:sikap/pages/saved_jobs.dart';
import 'package:sikap/pages/profile_screen.dart';
import 'package:sikap/pages/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikap/services/user_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load session from SharedPreferences
  final sessionLoaded = await UserSession.instance.loadSession();

  runApp(MyApp(isLoggedIn: sessionLoaded));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sikap',
      theme: ThemeData(fontFamily: 'Inter'),
      home: isLoggedIn ? const HomePage() : const LoginPage(),
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
