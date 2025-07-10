import 'package:flutter/material.dart';
import 'package:sikap/utils/colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sikap/widgets/navigation_helper.dart';
import 'package:sikap/pages/job_detail_screen.dart';
import 'package:sikap/services/api_service.dart';
import 'package:sikap/services/user_session.dart';
import 'package:sikap/pages/home_screen.dart';
import 'package:sikap/utils/loading_screen.dart';

class SavedJobs extends StatefulWidget {
  const SavedJobs({super.key});

  @override
  State<SavedJobs> createState() => _SavedJobsState();
}

class _SavedJobsState extends State<SavedJobs> {
  List<dynamic> _savedJobs = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadSavedJobs();
  }

  Future<void> _loadSavedJobs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final userSession = UserSession.instance;
      final jobseekerId = userSession.jobseekerId;

      if (jobseekerId == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Please log in to view saved jobs';
        });
        return;
      }

      final result = await ApiService.getSavedJobs(jobseekerId);

      if (result['success'] && result['data'] != null) {
        setState(() {
          _savedJobs = result['data'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = result['message'] ?? 'Failed to load saved jobs';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Network error: $e';
      });
    }
  }

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 6.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          // If no previous page, go to home
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      icon: SvgPicture.asset(
                        'assets/icons/back-svgrepo-com.svg',
                        width: 28,
                        height: 28,
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 28,
                          );
                        },
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
            child: _isLoading
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: LoadingScreen.jobListSkeleton(),
                  )
                : _errorMessage.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter',
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadSavedJobs,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : _savedJobs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bookmark_border,
                          size: 80,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No Saved Jobs Yet',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Jobs you save will appear here',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Inter',
                            color: AppColors.textGray,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _savedJobs.length,
                    itemBuilder: (context, index) {
                      final savedJob = _savedJobs[index];
                      final job = savedJob['job'];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildSavedJobCard(
                          context: context,
                          savedJob: savedJob,
                          job: job,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationHelper.createBottomNavBar(context, 2),
    );
  }

  Widget _buildSavedJobCard({
    required BuildContext context,
    required Map<String, dynamic> savedJob, // Changed from 'application'
    required Map<String, dynamic> job,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                JobDetailScreen(jobId: job['job_id']), // ADD jobId parameter
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FBFF), // Light blue background
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
                    color: const Color(0xFF0052CC),
                  ),
                  child: Center(
                    child: Text(
                      (job['company_name'] ?? 'C')[0].toUpperCase(),
                      style: const TextStyle(
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
                        job['company_name'] ?? 'Company',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: AppColors.placeholderBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job['job_title'] ?? 'Job Title',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Saved Status (replace the application status section)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Filled bookmark icon for saved jobs
                    GestureDetector(
                      onTap: () async {
                        // Unsave the job
                        final userSession = UserSession.instance;
                        final jobseekerId = userSession.jobseekerId;

                        if (jobseekerId != null) {
                          final result = await ApiService.unsaveJob(
                            jobseekerId,
                            job['job_id'],
                          );
                          if (result['success']) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Job removed from saved!'),
                              ),
                            );
                            _loadSavedJobs(); // Refresh the list
                          }
                        }
                      },
                      child: Icon(
                        Icons.bookmark, // Filled bookmark for saved jobs
                        color: AppColors.secondary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Saved date instead of application status
                    Text(
                      'SAVED',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ), // Add this missing comma

            const SizedBox(height: 12), // Add this missing comma
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
                  job['location'] ?? 'Location',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: AppColors.placeholderBlue,
                  ),
                ),
              ],
            ), // Add this missing comma

            const SizedBox(height: 8), // Add this missing comma
            // Saved date (replace applied date)
            Row(
              children: [
                Icon(
                  Icons.bookmark_border,
                  color: AppColors.placeholderBlue,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  'Saved ${_formatDate(savedJob['saved_at'])}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: AppColors.placeholderBlue,
                  ),
                ),
              ],
            ), // Add this missing comma

            const SizedBox(height: 12), // Add this missing comma
            // Job Type and Workplace
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.borderGray,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    job['job_type'] ?? 'Full-time',
                    style: const TextStyle(
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
                    color: AppColors.borderGray,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    job['workplace_option'] ?? 'On-site',
                    style: const TextStyle(
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
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown';

    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'today';
      } else if (difference.inDays == 1) {
        return 'yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${(difference.inDays / 7).floor()} weeks ago';
      }
    } catch (e) {
      return dateString;
    }
  }
}
