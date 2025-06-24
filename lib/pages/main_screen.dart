import 'package:flutter/material.dart';
import 'package:sikap/pages/home_screen.dart';
import 'package:sikap/pages/job_list_screen.dart';
import 'package:sikap/pages/saved_jobs.dart';
import 'package:sikap/pages/profile_screen.dart';
import 'package:sikap/widgets/bottom_navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const JobList(),
    const SavedJobs(),
    const Profile(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}