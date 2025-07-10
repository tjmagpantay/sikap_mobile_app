import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sikap/utils/colors.dart';
import 'package:sikap/pages/job_detail_screen.dart';
import 'package:sikap/pages/login_screen.dart';
import 'package:sikap/services/api_service.dart';
import 'package:sikap/utils/loading_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<dynamic> _jobPosts = [];
  List<dynamic> _filteredJobPosts = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  List<Map<String, dynamic>> _categories = [];
  bool _categoriesLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
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
    setState(() {
      List<dynamic> filteredByCategory = _jobPosts;

      // Filter by category first
      if (_selectedCategory != 'All') {
        final selectedCategoryData = _categories.firstWhere(
          (cat) => cat['category_name'] == _selectedCategory,
          orElse: () => {'category_id': null},
        );

        final selectedCategoryId = selectedCategoryData['category_id']?.toString();

        if (selectedCategoryId != null) {
          filteredByCategory = _jobPosts.where((job) {
            final jobCategoryId = job['job_category_id']?.toString();
            return jobCategoryId == selectedCategoryId;
          }).toList();
        }
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
    });
  }

  Future<void> _loadCategories() async {
    try {
      final result = await ApiService.getCategories();
      if (result['success'] && result['categories'] != null) {
        setState(() {
          _categories = List<Map<String, dynamic>>.from(result['categories']);
          _categoriesLoading = false;
        });
      } else {
        setState(() {
          _categoriesLoading = false;
        });
      }
    } catch (e) {
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

  void _showLoginPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.lightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: const Text(
            'Login Required',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          content: const Text(
            'You need to login to view job details and save jobs. Would you like to login now?',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.textGray,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.textGray,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        title: const Text(
          'Explore Jobs',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.primary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Search Bar
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
                    const Text(
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
                                // "All" category first
                                _buildCategoryTab('All', null),
                                // Then all database categories
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
                          LoadingScreen.jobListSkeleton(), 
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
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    color: AppColors.textGray,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index >= _filteredJobPosts.length) return null;
                              final job = _filteredJobPosts[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildJobCard(job: job),
                              );
                            },
                            childCount: _filteredJobPosts.length,
                          ),
                        ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String categoryName, int? jobCount) {
    final isSelected = categoryName == _selectedCategory;
    
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () => _onCategoryChanged(categoryName),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            border: Border.all(
              color: AppColors.primary,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(20),
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
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? Colors.white.withOpacity(0.2) 
                        : AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
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

  Widget _buildJobCard({required Map<String, dynamic> job}) {
    return GestureDetector(
      onTap: () {
        // Show login prompt when clicking on job card
        _showLoginPrompt();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
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
            // Header row with company info and login prompt
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
                        style: const TextStyle(
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

                // Login to Save prompt
                GestureDetector(
                  onTap: _showLoginPrompt,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.secondary,
                        width: 1,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.bookmark_border,
                          size: 16,
                          color: AppColors.secondary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Save',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Location
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.placeholderBlue,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  job['location'] ?? 'Location',
                  style: const TextStyle(
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
                    borderRadius: BorderRadius.circular(20),
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

            const SizedBox(height: 12),

            // Login prompt banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Login to view full job details and apply',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.primary,
                    size: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reuse the same StickySearchDelegate from job_list_screen.dart
class StickySearchDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController searchController;

  StickySearchDelegate({required this.searchController});

  @override
  double get minExtent => 80.0;

  @override
  double get maxExtent => 80.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: 80.0,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        height: 48.0,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: TextField(
          controller: searchController,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: 'Search job or company...',
            hintStyle: const TextStyle(
              color: AppColors.placeholderBlue,
              fontFamily: 'Inter',
              fontSize: 14,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SvgPicture.asset(
                'assets/icons/search.svg',
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(
                  AppColors.placeholderBlue,
                  BlendMode.srcIn,
                ),
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.search,
                    color: AppColors.placeholderBlue,
                    size: 18,
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
                      size: 18,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
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