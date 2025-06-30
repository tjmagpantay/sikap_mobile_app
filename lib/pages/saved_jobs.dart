import 'package:flutter/material.dart';
import 'package:sikap/utils/colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sikap/widgets/bottom_navbar.dart';

class SavedJobs extends StatelessWidget {
  const SavedJobs({super.key});
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom AppBar
          Container(
            color: Colors.white,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: SvgPicture.asset(
                        'assets/icons/back-svgrepo-com.svg',
                        width: 28,
                        height: 28,
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Saved Jobs',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),
            ),
          ),
          // Body content
          Expanded(
            child: Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark,
                      size: 80,
                      color: AppColors.primary,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No Saved Jobs Yet',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // Add the bottom navbar directly here
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2, // Changed from 1 to 2 (Saved tab is index 2)
        onTap: (index) {
          // Handle navigation to different pages
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/jobs');
              break;
            case 2:
              // Already on Saved page
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}