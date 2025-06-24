import 'package:flutter/material.dart';
import 'package:sikap/utils/colors.dart';
import 'package:sikap/pages/login_screen.dart';
import 'package:sikap/pages/job_list_screen.dart';

class WelcomePage extends StatelessWidget {
    const WelcomePage({super.key});    
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Container(
                // Background image
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/sikap-bg.png'),
                        fit: BoxFit.cover,
                    ),
                ),
                child: SafeArea(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Column(                            children: [
                                // Top spacing
                                const SizedBox(height: 240),
                                
                                // Logo and app name widget (upper middle)
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        // Logo
                                        Image.asset(
                                            'assets/logo/sikap-logo.png',
                                            width: 60,
                                            height: 60,
                                        ),
                                        const SizedBox(width: 16),
                                        // App name
                                        const Text(
                                            'Sikap',
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 32,
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromARGB(255, 255, 255, 255),
                                            ),
                                        ),
                                    ],
                                ),
                                
                                // Spacer to push buttons to bottom
                                const Spacer(),
                                
                                // Buttons section (lower part)
                                Column(
                                    children: [                                        // Explore button
                                        SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: ElevatedButton(
                                                onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => const JobList()),
                                                    );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    elevation: 1.0,
                                                ),
                                                child: Text(
                                                    'Explore',
                                                    style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600,
                                                        color: AppColors.primary,
                                                    ),
                                                ),
                                            ),
                                        ),
                                        
                                        const SizedBox(height: 16),
                                          // Sign In button
                                        SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: ElevatedButton(
                                                onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => const LoginPage()),
                                                    );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: AppColors.secondary,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    elevation: 1.0,
                                                ),
                                                child: Text(
                                                    'Sign In',
                                                    style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600,
                                                        color: AppColors.primary,
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
                ),
            ),
        );
    }
}