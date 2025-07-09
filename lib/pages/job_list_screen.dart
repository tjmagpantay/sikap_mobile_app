import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sikap/utils/colors.dart';
import 'package:sikap/widgets/navigation_helper.dart';
import 'package:sikap/pages/job_detail_screen.dart';
import 'package:sikap/services/api_service.dart';
import 'package:sikap/services/user_session.dart'; 
import 'package:sikap/utils/loading_screen.dart'; 

class JobList extends StatefulWidget {
  const JobList({super.key});

  @override
  State<JobList> createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  List<dynamic> _jobPosts = [];
  List<dynamic> _filteredJobPosts = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  List<Map<String, dynamic>> _categories = []; // Store category objects
  bool _categoriesLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories(); // Load categories first
    _loadJobPosts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterJobs();
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterJobs();
  }

  void _filterJobs() {
    print("🔍 Filtering jobs...");
    print("Selected category: $_selectedCategory");
    print("Total jobs: ${_jobPosts.length}");
    print("Available categories: $_categories");

    setState(() {
      List<dynamic> filteredByCategory = _jobPosts;

      // Filter by category first
      if (_selectedCategory != 'All') {
        // Find the selected category ID
        final selectedCategoryData = _categories.firstWhere(
          (cat) => cat['category_name'] == _selectedCategory,
          orElse: () => {'category_id': null},
        );

        final selectedCategoryId = selectedCategoryData['category_id']
            ?.toString();
        print("Selected category ID: $selectedCategoryId");

        if (selectedCategoryId != null) {
          filteredByCategory = _jobPosts.where((job) {
            final jobCategoryId = job['job_category_id']?.toString();
            print("Job: ${job['job_title']} - Category ID: $jobCategoryId");
            return jobCategoryId == selectedCategoryId;
          }).toList();
        }

        print("Jobs after category filter: ${filteredByCategory.length}");
      }

      // Then filter by search query
      if (_searchController.text.isEmpty) {
        _filteredJobPosts = filteredByCategory;
      } else {
        _filteredJobPosts = filteredByCategory.where((job) {
          final jobTitle = (job['job_title'] ?? '').toString().toLowerCase();
          final companyName = (job['company']?['company_name'] ?? '')
              .toString()
              .toLowerCase();
          final searchQuery = _searchController.text.toLowerCase();

          return jobTitle.contains(searchQuery) ||
              companyName.contains(searchQuery);
        }).toList();
      }

      print("Final filtered jobs: ${_filteredJobPosts.length}");
    });
  }

  Future<void> _loadCategories() async {
    try {
      print('🔄 Loading categories from API...');
      final result = await ApiService.getCategories();

      print('📥 Categories API response: $result');

      if (result['success'] && result['categories'] != null) {
        setState(() {
          _categories = List<Map<String, dynamic>>.from(result['categories']);
          _categoriesLoading = false;
        });
        print('✅ Categories loaded: ${_categories.length}');
        print('📋 Categories data: $_categories');
      } else {
        print('❌ Failed to load categories: ${result['message']}');
        setState(() {
          _categoriesLoading = false;
        });
      }
    } catch (e) {
      print('❌ Exception loading categories: $e');
      setState(() {
        _categoriesLoading = false;
      });
    }
  }

  Future<void> _loadJobPosts() async {
    try {
      final result = await ApiService.getJobPosts();
      if (result['success'] && result['data'] != null) {
        setState(() {
          _jobPosts = result['data'];
          _filteredJobPosts = _jobPosts;
          _isLoading = false;
        });
        print('✅ Jobs loaded: ${_jobPosts.length}');

        // Debug: Print ALL jobs to see their structure
        for (int i = 0; i < _jobPosts.length; i++) {
          final job = _jobPosts[i];
          print(
            '📋 Job $i: ${job['job_title']} - job_category_id: ${job['job_category_id']}',
          );
          print('📋 Full job $i structure: $job');
        }
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Sticky Search Bar
            SliverPersistentHeader(
              pinned: true,
              delegate: StickySearchDelegate(
                searchController: _searchController,
              ),
            ),

            // Category Filter Tabs
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _categoriesLoading
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: LoadingScreen.categoryTabsSkeleton(),
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
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildCategoryTab('All', null),
                                ..._categories.map((category) {
                                  return _buildCategoryTab(
                                    category['category_name'],
                                    category['job_count'],
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),

            // Job Cards List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: _isLoading
                  ? SliverFillRemaining(
                      hasScrollBody: false,
                      child:
                          LoadingScreen.jobListSkeleton(), // Use your skeleton loader here
                    )
                  : _filteredJobPosts.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _getEmptyMessage(),
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                color: AppColors.textGray,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (_searchController.text.isNotEmpty ||
                                _selectedCategory != 'All') ...[
                              const SizedBox(height: 8),
                              Text(
                                'Try different search terms or categories',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ],
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index >= _filteredJobPosts.length) return null;

                        final job = _filteredJobPosts[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildJobCard(context: context, job: job),
                        );
                      }, childCount: _filteredJobPosts.length),
                    ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      bottomNavigationBar: NavigationHelper.createBottomNavBar(context, 1),
    );
  }

  Widget _buildCategoryTab(String categoryName, int? jobCount) {
    final isSelected = categoryName == _selectedCategory;

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () => _onCategoryChanged(categoryName),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            border: Border.all(
              color: AppColors.primary,
              width: 1.0, // Reduced from 1.5
            ),
            borderRadius: BorderRadius.circular(20), // Increased from 4
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                categoryName,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.primary,
                ),
              ),
              if (jobCount != null && jobCount > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.2)
                        : AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12), // Increased from 2
                  ),
                  child: Text(
                    jobCount.toString(),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.primary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getEmptyMessage() {
    if (_searchController.text.isNotEmpty && _selectedCategory != 'All') {
      return 'No jobs found for "${_searchController.text}" in ${_selectedCategory}';
    } else if (_searchController.text.isNotEmpty) {
      return 'No jobs found for "${_searchController.text}"';
    } else if (_selectedCategory != 'All') {
      return 'No jobs found in ${_selectedCategory} category';
    } else {
      return 'No job posts available';
    }
  }

  Widget _buildJobCard({
    required BuildContext context,
    required Map<String, dynamic> job,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigate to job detail screen with job ID
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
                      (job['company']?['company_name'] ?? 'C')[0].toUpperCase(),
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
                        job['company']?['company_name'] ?? 'Company',
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

                // Bookmark Icon
                GestureDetector(
                  onTap: () async {
                    final userSession = UserSession.instance;
                    final jobseekerId = userSession.jobseekerId;

                    if (jobseekerId != null) {
                      final result = await ApiService.saveJob(
                        jobseekerId,
                        job['job_id'],
                      );
                      if (result['success']) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Job saved successfully!')),
                        );
                        // Optionally refresh the job list or update the icon
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              result['message'] ?? 'Failed to save job',
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: Icon(
                    Icons
                        .bookmark_border, // This will become Icons.bookmark when saved
                    size: 24,
                    color: AppColors.secondary,
                  ),
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
                  job['location'] ?? 'Location',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: AppColors.placeholderBlue,
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
}

// Updated Custom delegate for sticky search bar
class StickySearchDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController searchController;

  StickySearchDelegate({required this.searchController});

  @override
  double get minExtent => 80.0; // Reduced from 100.0

  @override
  double get maxExtent => 80.0; // Reduced from 100.0

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: 80.0, // Reduced from 100.0
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ), // Reduced vertical padding
      child: Container(
        height: 48.0, // Reduced from 64.0
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12), // Added border radius
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: TextField(
          controller: searchController,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: 'Search job or company...',
            hintStyle: const TextStyle(
              color: AppColors.placeholderBlue,
              fontFamily: 'Inter',
              fontSize: 14, // Reduced font size
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0), // Reduced padding
              child: SvgPicture.asset(
                'assets/icons/search.svg',
                width: 18, // Reduced size
                height: 18,
                colorFilter: const ColorFilter.mode(
                  AppColors.placeholderBlue,
                  BlendMode.srcIn,
                ),
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.search,
                    color: AppColors.placeholderBlue,
                    size: 18, // Reduced size
                  );
                },
              ),
            ),
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      searchController.clear();
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: AppColors.placeholderBlue,
                      size: 18, // Reduced size
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12, // Reduced vertical padding
            ),
            isDense: true,
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
