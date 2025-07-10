import 'package:flutter/material.dart';
import 'package:sikap/utils/colors.dart';
import 'package:sikap/widgets/navigation_helper.dart';
import 'package:sikap/pages/job_list_screen.dart';
import 'package:sikap/pages/job_detail_screen.dart';
import 'package:sikap/services/api_service.dart';
import 'package:sikap/services/user_session.dart';
import 'package:sikap/utils/loading_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _jobPosts = [];
  List<dynamic> _recentJobs = [];
  List<dynamic> _categories = [];
  bool _isLoading = true;
  bool _isLoadingRecent = true;
  bool _isLoadingCategories = true;
  String _userName = 'User';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Get user name from session
    final userSession = UserSession.instance;
    if (userSession.isLoggedIn) {
      setState(() {
        _userName = userSession.userName;
      });
    }

    // Load job posts
    try {
      final result = await ApiService.getJobPosts();
      if (result['success'] && result['data'] != null) {
        setState(() {
          _jobPosts = result['data'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }

    // Load recent jobs (last 7 days)
    try {
      final result = await ApiService.getJobPosts();
      if (result['success'] && result['data'] != null) {
        final now = DateTime.now();
        final sevenDaysAgo = now.subtract(const Duration(days: 7));

        final recentJobs = (result['data'] as List).where((job) {
          try {
            final createdAt = DateTime.parse(job['created_at']);
            return createdAt.isAfter(sevenDaysAgo);
          } catch (e) {
            return false;
          }
        }).toList();

        setState(() {
          _recentJobs = recentJobs;
          _isLoadingRecent = false;
        });
      } else {
        setState(() {
          _isLoadingRecent = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingRecent = false;
      });
    }

    // Load categories
    try {
      final result = await ApiService.getCategories();
      if (result['success'] && result['categories'] != null) {
        setState(() {
          _categories = result['categories'];
          _isLoadingCategories = false;
        });
      } else {
        setState(() {
          _isLoadingCategories = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    } else if (hour < 17) {
      return 'Good Afternoon!';
    } else {
      return 'Good Evening!';
    }
  }

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
                  // Hi Username
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontFamily: 'Inter'),
                      children: [
                        const TextSpan(
                          text: 'Hi, ',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: _userName,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Dynamic Greeting
                  Text(
                    _getGreeting(),
                    style: const TextStyle(
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
                  borderRadius: BorderRadius.circular(6),
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
                        height: 100,
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

              // Job Categories Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Job Categories',
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
                        MaterialPageRoute(
                          builder: (context) => const JobList(),
                        ),
                      );
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: AppColors.textGray,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _isLoadingCategories
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: LoadingScreen.categoryGridSkeleton(),
                    )
                  : _categories.isEmpty
                  ? const Center(
                      child: Text(
                        'No categories available',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: AppColors.textGray,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        // First row
                        Row(
                          children: [
                            if (_categories.isNotEmpty)
                              Expanded(
                                child: _buildCategoryCard(_categories[0]),
                              ),
                            const SizedBox(width: 12),
                            if (_categories.length > 1)
                              Expanded(
                                child: _buildCategoryCard(_categories[1]),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Second row
                        Row(
                          children: [
                            if (_categories.length > 2)
                              Expanded(
                                child: _buildCategoryCard(_categories[2]),
                              ),
                            const SizedBox(width: 12),
                            if (_categories.length > 3)
                              Expanded(
                                child: _buildCategoryCard(_categories[3]),
                              ),
                          ],
                        ),
                      ],
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
                        MaterialPageRoute(
                          builder: (context) => const JobList(),
                        ),
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

              // Popular Job Posts
              _isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LoadingScreen.jobListSkeleton(),
                    )
                  : _jobPosts.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Text(
                          'No job posts available',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            color: AppColors.textGray,
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: _jobPosts
                          .take(2)
                          .map((job) => _buildJobCard(job))
                          .toList(),
                    ),

              const SizedBox(height: 16),

              // Recent Jobs Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Jobs',
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
                        MaterialPageRoute(
                          builder: (context) => const JobList(),
                        ),
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
              // Recent Jobs List
                _isLoadingRecent
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LoadingScreen.recentJobSkeleton(),
                    )
                  :  _recentJobs.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: const Center(
                        child: Text(
                          'No recent jobs in the last 7 days',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: AppColors.textGray,
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: _recentJobs
                          .take(3)
                          .map((job) => _buildRecentJobCard(job))
                          .toList(),
                    ),

              const SizedBox(height: 16),

              // Quick Stats Section
              const Text(
                'Quick Stats',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 16),

              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Jobs',
                      '${_jobPosts.length}',
                      Icons.work_outline,
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Categories',
                      '${_categories.length}',
                      Icons.category_outlined,
                      AppColors.secondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'This Week',
                      '${_recentJobs.length}',
                      Icons.schedule_outlined,
                      AppColors.secondaryBlue,
                    ),
                  ),
                ],
              ),

              // Bottom spacing for navigation bar
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationHelper.createBottomNavBar(context, 0),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const JobList()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12), // Reduced from 16
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 32, // Reduced from 40
              height: 32, // Reduced from 40
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6), // Reduced from 8
              ),
              child: Icon(
                _getCategoryIcon(category['category_name']),
                color: AppColors.primary,
                size: 16, // Reduced from 20
              ),
            ),
            const SizedBox(width: 8), // Reduced from 12
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category['category_name'],
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13, // Reduced from 14
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // Prevents overflow
                  ),
                  const SizedBox(height: 2), // Reduced spacing
                  Text(
                    '${category['job_count']} jobs',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11, // Reduced from 12
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentJobCard(Map<String, dynamic> job) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobDetailScreen(jobId: job['job_id']),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Company Logo
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: AppColors.primary,
              ),
              child: Center(
                child: Text(
                  (job['company']?['company_name'] ?? 'C')[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Job Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job['job_title'] ?? 'Job Title',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    job['company']?['company_name'] ?? 'Company',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
            // New Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'NEW',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: AppColors.textGray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'it':
        return Icons.computer;
      case 'healthcare':
        return Icons.health_and_safety;
      case 'education':
        return Icons.school;
      case 'engineering':
        return Icons.engineering;
      case 'finance':
        return Icons.account_balance;
      case 'marketing':
        return Icons.campaign;
      case 'construction':
        return Icons.construction;
      default:
        return Icons.work;
    }
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    final isFirstCard = _jobPosts.indexOf(job) == 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobDetailScreen(jobId: job['job_id']),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: isFirstCard
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4E8CC4),
                    Color(0xFF0B4478),
                    Color(0xFF092C4C),
                  ],
                )
              : null,
          color: isFirstCard ? null : const Color(0xFFF7FBFF),
          border: isFirstCard ? null : Border.all(color: Colors.grey[200]!),
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
                    color: const Color(0xFF0052CC),
                  ),
                  child: Center(
                    child: Text(
                      (job['company']?['company_name'] ?? 'C')[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
                        job['company']?['company_name'] ?? 'Company',
                        style: TextStyle(
                          color: isFirstCard
                              ? Colors.white70
                              : AppColors.textGray,
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job['job_title'] ?? 'Job Title',
                        style: TextStyle(
                          color: isFirstCard ? Colors.white : Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),

                // Bookmark Icon
                Icon(
                  Icons.bookmark_border,
                  color: isFirstCard ? AppColors.secondary : AppColors.textGray,
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
                  color: isFirstCard ? Colors.white70 : AppColors.textGray,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  job['location'] ?? 'Location',
                  style: TextStyle(
                    color: isFirstCard ? Colors.white70 : AppColors.textGray,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Job Type and Workplace
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isFirstCard
                        ? Colors.white.withOpacity(0.2)
                        : AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    job['job_type'] ?? 'Full-time',
                    style: TextStyle(
                      color: isFirstCard ? Colors.white : AppColors.primary,
                      fontSize: 12,
                      fontFamily: 'Inter',
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
                    color: isFirstCard
                        ? Colors.white.withOpacity(0.2)
                        : AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    job['workplace_option'] ?? 'On-site',
                    style: TextStyle(
                      color: isFirstCard ? Colors.white : AppColors.primary,
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
