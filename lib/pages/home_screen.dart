import 'package:flutter/material.dart';
import 'package:sikap/utils/colors.dart';
import 'package:sikap/widgets/navigation_helper.dart';
import 'package:sikap/pages/job_list_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Header Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hi Alex Albon
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontFamily: 'Inter'),
                      children: [
                        TextSpan(
                          text: 'Hi, ',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'Alex Albon',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Good Morning
                  const Text(
                    'Good Morning!',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Welcome Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(6), // More rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Left side text
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Explore jobs near\nyou here and saved it',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: AppColors.textGray,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Right side illustration
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Image.asset(
                          'assets/images/home-illustration.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F4F8),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Stack(
                                children: [
                                  // Background shapes to mimic the illustration style
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      width: 60,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    child: Container(
                                      width: 40,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                  // Person silhouette placeholder
                                  Positioned(
                                    bottom: 20,
                                    left: 20,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: const BoxDecoration(
                                        color: Colors.black87,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  // Document/CV placeholder
                                  Positioned(
                                    top: 20,
                                    left: 15,
                                    child: Container(
                                      width: 45,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: AppColors.primary,
                                          width: 1,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 8),
                                          Container(
                                            width: 25,
                                            height: 25,
                                            decoration: const BoxDecoration(
                                              color: AppColors.textGray,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            width: 30,
                                            height: 2,
                                            color: AppColors.primary,
                                          ),
                                          const SizedBox(height: 2),
                                          Container(
                                            width: 25,
                                            height: 2,
                                            color: AppColors.primary,
                                          ),
                                          const SizedBox(height: 2),
                                          Container(
                                            width: 20,
                                            height: 2,
                                            color: AppColors.primary,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Popular Jobs Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular Jobs',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const JobList()),
                      );
                    },
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: AppColors.textGray,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Job Card 1 - Gradient Background
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4E8CC4),
                      Color(0xFF0B4478),
                      Color(0xFF092C4C),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row with company info and bookmark
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Company Logo
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: const Color(0xFF0052CC), // Atlassian blue
                          ),
                          child: const Center(
                            child: Text(
                              'A',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Company Name and Job Title
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Atlassian',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Product Designer',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Bookmark Icon
                        Icon(
                          Icons.bookmark,
                          color: AppColors.secondary,
                          size: 24,
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Location
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.white70,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Manila, Philippines',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Job Types
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Freelance',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Full-time',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Job Card 2 - Light Background
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7FBFF),
                  border: Border.all(color: Colors.grey[200]!),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row with company info and bookmark
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Company Logo
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: const Color(0xFF0052CC), // Atlassian blue
                          ),
                          child: const Center(
                            child: Text(
                              'A',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Company Name and Job Title
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Atlassian',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  color: AppColors.placeholderBlue,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Product Designer',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Bookmark Icon
                        Icon(
                          Icons.bookmark,
                          color: AppColors.secondary,
                          size: 24,
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: AppColors.placeholderBlue,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Manila, Philippines',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: AppColors.placeholderBlue,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Job Types
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Freelance',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Full-time',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Bottom spacing for navigation bar
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationHelper.createBottomNavBar(context, 0), // Home tab active
    );
  }
}