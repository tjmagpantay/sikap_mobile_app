import 'package:flutter/material.dart';
import 'package:sikap/utils/colors.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionScreen extends StatelessWidget {
  final VoidCallback onGranted;

  const PermissionScreen({super.key, required this.onGranted});

  Future<void> _requestPermission(BuildContext context) async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      onGranted();
    } else {
      // Optionally show a message or open settings
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permission denied. You can enable it in settings.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Use your reference image here
                Image.asset(
                  'assets/images/app-permission.png', // <-- Add your image to assets
                  width: 260,
                  height: 260,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                Text(
                  'Enable Notifications',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Get important updates and reminders.\nYou can change this later in settings.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => _requestPermission(context),
                    child: const Text(
                      'Allow Notifications',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => onGranted(),
                    child: Text(
                      'Not Now',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
