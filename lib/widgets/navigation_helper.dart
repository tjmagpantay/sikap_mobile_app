import 'package:flutter/material.dart';
import 'package:sikap/widgets/bottom_navbar.dart';

class NavigationHelper {
  static BottomNavBar createBottomNavBar(BuildContext context, int currentIndex) {
    return BottomNavBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/jobs');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/saved');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/profile');
            break;
        }
      },
    );
  }
}