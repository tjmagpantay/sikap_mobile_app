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
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 24,
        top: 8,
      ), // top: 2
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.primary, // Main background is primary
          borderRadius: BorderRadius.circular(16),
        ),
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

    String iconPath;
    if (isActive) {
      iconPath = 'assets/icons/$iconName-secondary.svg';
    } else {
      iconPath = 'assets/icons/$iconName.svg';
    }

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: isActive
            ? BoxDecoration(borderRadius: BorderRadius.circular(8))
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isActive
                    ? AppColors.secondary
                    : Colors.white, // Active: secondary, Inactive: white
                BlendMode.srcIn,
              ),
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  _getIconFallback(iconName),
                  size: 24,
                  color: isActive ? AppColors.secondary : Colors.white,
                );
              },
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? AppColors.secondary
                    : Colors.white, // Active: secondary, Inactive: white
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
