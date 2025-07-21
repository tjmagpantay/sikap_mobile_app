import 'package:flutter/material.dart';
import 'package:sikap/pages/welcome_first.dart';
import 'package:sikap/utils/colors.dart';
import 'package:sikap/pages/permission_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _dotsAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _permissionHandled = false;
  DateTime? _animationStartTime;

  @override
  void initState() {
    super.initState();

    _logoAnimationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _dotsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoAnimationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _handlePermissionAndAnimation();
  }

  Future<void> _handlePermissionAndAnimation() async {
    _animationStartTime = DateTime.now();

    // First show the splash animation
    _logoAnimationController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _dotsAnimationController.repeat();

    // Navigate to permission screen if not handled
    if (!_permissionHandled) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PermissionScreen(
            onGranted: () {
              _permissionHandled = true;
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    }

    // After permission is handled, wait for minimum splash time (4.5s total)
    final splashTimeElapsed = DateTime.now().difference(_animationStartTime!);
    final remainingTime =
        const Duration(seconds: 4, milliseconds: 500) - splashTimeElapsed;
    if (remainingTime > Duration.zero) {
      await Future.delayed(remainingTime);
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const WelcomeFirst()),
      );
    }
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _dotsAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 8, 53, 95),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _logoAnimationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: ClipOval(
                          child: Image.asset(
                            'assets/logo/sikap-logo.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.work,
                                size: 50,
                                color: AppColors.secondary,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 60),

            AnimatedBuilder(
              animation: _dotsAnimationController,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    final currentPosition =
                        (_dotsAnimationController.value * 4) % 4;
                    final isActive =
                        (currentPosition >= index &&
                        currentPosition < index + 1);
                    final delay = index * 0.15;
                    final animationValue = Curves.easeInOut.transform(
                      (((_dotsAnimationController.value - delay) % 1.0).clamp(
                        0.0,
                        1.0,
                      )),
                    );

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.secondary.withOpacity(
                                  0.8 + (animationValue * 0.2),
                                )
                              : Colors.white.withOpacity(
                                  0.3 + (animationValue * 0.3),
                                ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
