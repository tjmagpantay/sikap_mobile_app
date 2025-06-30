import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sikap/utils/colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80, // Reduced from 110 to 80
      decoration: BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, 'home', 'Home'),
            _buildNavItem(1, 'job', 'Jobs'),
            _buildNavItem(2, 'saved', 'Saved'),
            _buildNavItem(3, 'profile', 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String iconName, String label) {
    final bool isActive = currentIndex == index;
    
    // Fixed icon path logic to handle 'saved' correctly
    String iconPath;
    if (isActive) {
      iconPath = 'assets/icons/$iconName-secondary.svg';
    } else {
      iconPath = 'assets/icons/$iconName.svg';
    }

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8), // Adjusted padding
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isActive ? AppColors.secondary : Colors.white,
                BlendMode.srcIn,
              ),
              // Add error handling
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  _getIconFallback(iconName),
                  size: 24,
                  color: isActive ? AppColors.secondary : Colors.white,
                );
              },
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.secondary : Colors.white,
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for icon fallbacks
  IconData _getIconFallback(String iconName) {
    switch (iconName) {
      case 'home':
        return Icons.home;
      case 'job':
        return Icons.work;
      case 'saved':
        return Icons.bookmark;
      case 'profile':
        return Icons.person;
      default:
        return Icons.circle;
    }
  }
}