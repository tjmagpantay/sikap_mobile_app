import 'package:flutter/material.dart';
import 'package:sikap/utils/colors.dart';

class LoadingScreen {
  // Basic skeleton loading widget
  static Widget skeleton({
    required double width,
    required double height,
    BorderRadius? borderRadius,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return _SkeletonWidget(
      width: width,
      height: height,
      borderRadius: borderRadius ?? BorderRadius.circular(4),
      baseColor: baseColor ?? Colors.grey[300]!,
      highlightColor: highlightColor ?? Colors.grey[200]!,
    );
  }

  // Profile skeleton loading
  static Widget profileSkeleton() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 150, 20, 20),
      child: Column(
        children: [
          // Personal Information Card Skeleton
          _buildSkeletonCard(
            children: [
              skeleton(width: 150, height: 18), // Title
              const SizedBox(height: 16),
              _buildSkeletonInfoRow(),
              _buildSkeletonInfoRow(),
              _buildSkeletonInfoRow(),
              _buildSkeletonInfoRow(),
            ],
          ),

          const SizedBox(height: 24),

          // Profile Completion Card Skeleton
          _buildSkeletonCard(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  skeleton(width: 120, height: 16),
                  skeleton(width: 50, height: 16),
                ],
              ),
              const SizedBox(height: 16),
              skeleton(width: double.infinity, height: 8),
            ],
          ),

          const SizedBox(height: 24),

          // Education Section Skeleton
          _buildSkeletonCard(
            children: [
              skeleton(width: 150, height: 18),
              const SizedBox(height: 16),
              _buildSkeletonEducationItem(),
              _buildSkeletonEducationItem(),
            ],
          ),

          const SizedBox(height: 24),

          // Skills Section Skeleton
          _buildSkeletonCard(
            children: [
              skeleton(width: 120, height: 18),
              const SizedBox(height: 16),
              _buildSkeletonSkillsRow(),
              const SizedBox(height: 12),
              _buildSkeletonSkillsRow(),
            ],
          ),

          const SizedBox(height: 24),

          // Work Experience Section Skeleton
          _buildSkeletonCard(
            children: [
              skeleton(width: 130, height: 18),
              const SizedBox(height: 16),
              _buildSkeletonWorkItem(),
            ],
          ),

          const SizedBox(height: 24),

          // Contact Section Skeleton
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              skeleton(width: 140, height: 18),
              const SizedBox(height: 16),
              _buildSkeletonContactRow(),
              const SizedBox(height: 20),
              _buildSkeletonContactRow(),
            ],
          ),

          const SizedBox(height: 32),

          // Sign Out Button Skeleton
          skeleton(
            width: double.infinity,
            height: 56,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Job list skeleton loading
  static Widget jobListSkeleton() {
    return Column(
      children: List.generate(
        3,
        (index) => Container(
          width: double.infinity,
          height: 140, // Match your actual card height
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar skeleton
              LoadingScreen.skeleton(
                width: 48,
                height: 48,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(width: 16),
              // Text skeletons
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LoadingScreen.skeleton(width: 120, height: 16),
                    const SizedBox(height: 8),
                    LoadingScreen.skeleton(width: 180, height: 14),
                    const SizedBox(height: 16),
                    LoadingScreen.skeleton(width: 100, height: 12),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        LoadingScreen.skeleton(width: 60, height: 12),
                        const SizedBox(width: 8),
                        LoadingScreen.skeleton(width: 40, height: 12),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Category tabs skeleton loading
  static Widget categoryTabsSkeleton() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 12),
            child: skeleton(
              width: 80,
              height: 32,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  // Home screen skeleton loading
  static Widget homeScreenSkeleton() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // Header Section
          skeleton(width: 200, height: 24),
          const SizedBox(height: 4),
          skeleton(width: 120, height: 16),

          const SizedBox(height: 24),

          // Welcome Card
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        skeleton(width: 80, height: 20),
                        const SizedBox(height: 8),
                        skeleton(width: 150, height: 14),
                        const SizedBox(height: 4),
                        skeleton(width: 120, height: 14),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Job Categories
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              skeleton(width: 120, height: 18),
              skeleton(width: 60, height: 14),
            ],
          ),
          const SizedBox(height: 16),

          // Categories Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 4.0,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    skeleton(
                      width: 32,
                      height: 32,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          skeleton(width: 80, height: 13),
                          const SizedBox(height: 2),
                          skeleton(width: 40, height: 11),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // Popular Jobs Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              skeleton(width: 100, height: 18),
              skeleton(width: 60, height: 16),
            ],
          ),
          const SizedBox(height: 16),

          // Job Cards
          Column(
            children: List.generate(
              2,
              (index) => Container(
                width: double.infinity,
                height: 120,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        skeleton(
                          width: 48,
                          height: 48,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              skeleton(width: 100, height: 14),
                              const SizedBox(height: 4),
                              skeleton(width: 150, height: 16),
                            ],
                          ),
                        ),
                        skeleton(width: 24, height: 24),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        skeleton(
                          width: 80,
                          height: 24,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(width: 8),
                        skeleton(
                          width: 70,
                          height: 24,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  static Widget _buildSkeletonCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  static Widget _buildSkeletonInfoRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          skeleton(width: 80, height: 14),
          const SizedBox(width: 20),
          Expanded(child: skeleton(width: double.infinity, height: 14)),
        ],
      ),
    );
  }

  static Widget _buildSkeletonEducationItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          skeleton(width: 200, height: 16),
          const SizedBox(height: 8),
          _buildSkeletonInfoRow(),
          _buildSkeletonInfoRow(),
          _buildSkeletonInfoRow(),
        ],
      ),
    );
  }

  static Widget _buildSkeletonSkillsRow() {
    return Row(
      children: [
        skeleton(width: 80, height: 32, borderRadius: BorderRadius.circular(8)),
        const SizedBox(width: 12),
        skeleton(
          width: 100,
          height: 32,
          borderRadius: BorderRadius.circular(8),
        ),
        const SizedBox(width: 12),
        skeleton(width: 90, height: 32, borderRadius: BorderRadius.circular(8)),
      ],
    );
  }

static Widget recentJobSkeleton() {
  return Column(
    children: List.generate(
      3, // Show 3 skeleton cards for recent jobs
      (index) => Container(
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
            // Company Logo Skeleton
            LoadingScreen.skeleton(
              width: 40,
              height: 40,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(width: 12),
            // Job Info Skeleton
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LoadingScreen.skeleton(width: 100, height: 14),
                  const SizedBox(height: 8),
                  LoadingScreen.skeleton(width: 60, height: 12),
                ],
              ),
            ),
            // "NEW" Badge Skeleton
            LoadingScreen.skeleton(
              width: 36,
              height: 20,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
      ),
    ),
  );
}

  static Widget categoryGridSkeleton() {
  return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 6, bottom: 6),
              child: LoadingScreen.skeleton(width: double.infinity, height: 60, borderRadius: BorderRadius.circular(8)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 6, bottom: 6),
              child: LoadingScreen.skeleton(width: double.infinity, height: 60, borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 6, top: 6),
              child: LoadingScreen.skeleton(width: double.infinity, height: 60, borderRadius: BorderRadius.circular(8)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 6, top: 6),
              child: LoadingScreen.skeleton(width: double.infinity, height: 60, borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    ],
  );
}

  static Widget _buildSkeletonWorkItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          skeleton(width: 180, height: 16),
          const SizedBox(height: 4),
          skeleton(width: 140, height: 14),
          const SizedBox(height: 8),
          _buildSkeletonInfoRow(),
          _buildSkeletonInfoRow(),
        ],
      ),
    );
  }

  static Widget _buildSkeletonContactRow() {
    return Row(
      children: [
        skeleton(width: 40, height: 40, borderRadius: BorderRadius.circular(4)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              skeleton(width: 60, height: 14),
              const SizedBox(height: 4),
              skeleton(width: 160, height: 16),
            ],
          ),
        ),
      ],
    );
  }
}



// Private skeleton widget with animation
class _SkeletonWidget extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final Color baseColor;
  final Color highlightColor;

  const _SkeletonWidget({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.baseColor,
    required this.highlightColor,
  });

  @override
  State<_SkeletonWidget> createState() => _SkeletonWidgetState();
}

class _SkeletonWidgetState extends State<_SkeletonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: [0.0, _animation.value, 1.0],
            ),
          ),
        );
      },
    );
  }
}
