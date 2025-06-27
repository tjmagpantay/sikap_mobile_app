import 'package:flutter/material.dart';
import 'package:sikap/utils/colors.dart';
import 'package:sikap/pages/login_screen.dart';
import 'package:sikap/pages/job_list_screen.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // White background
      body: SafeArea(
        child: Stack(
          children: [
            // Background image
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/welcome_bg.png',
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height * 0.6, // Cover bottom 60%
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    color: Colors.grey[200],
                  );
                },
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 140), // Increased from 60 to push content lower
                  
                  // Logo section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Sikap logo
                      Image.asset(
                        'assets/logo/sikap-logo.png',
                        width: 50,
                        height: 50,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey[300],
                            child: const Icon(Icons.work, color: Colors.grey),
                          );
                        },
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Peso logo
                      Image.asset(
                        'assets/logo/peso-logo.png',
                        width: 52,
                        height: 52,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey[300],
                            child: const Icon(Icons.account_balance, color: Colors.grey),
                          );
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // App name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sikap',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Jobseeker',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20), // Increased from 60 for better spacing
                  
                  // Main heading
                  const Text(
                    'Let\'s find your\ndream Job',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        height: 1.2,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Text(
                      'Start exploring opportunities tailored just for you and take the first step toward your future.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF3F3F3F),
                        height: 1.5,
                      ),
                    ),
                  ),
                  
                  // Spacer to push buttons down
                  const Spacer(),
                  
                  // Buttons section
                  Column(
                    children: [
                      // Explore button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const JobList()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Explore',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Sign In button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Bottom spacing
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}