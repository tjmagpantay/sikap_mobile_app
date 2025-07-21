import 'package:flutter/material.dart';
import 'package:sikap/pages/welcome_first.dart';
import 'package:sikap/pages/welcome_two.dart';
import 'package:sikap/pages/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
    print('ONBOARDING FLAG: $onboardingComplete'); // <-- Add this line
    if (onboardingComplete) {
      _startSplashAnimation(goToWelcomePage: true);
    } else {
      _startSplashAnimation(goToWelcomePage: false);
    }
  }

  Future<void> _startSplashAnimation({required bool goToWelcomePage}) async {
    _animationStartTime = DateTime.now();
    _logoAnimationController.forward();
    await Future.delayed(const Duration(milliseconds: 2000));
    _dotsAnimationController.repeat();

    if (goToWelcomePage) {
      final splashTimeElapsed = DateTime.now().difference(_animationStartTime!);
      final remainingTime =
          const Duration(seconds: 4, milliseconds: 4000) - splashTimeElapsed;
      if (remainingTime > Duration.zero) {
        await Future.delayed(remainingTime);
      }
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const WelcomePage()),
        );
      }
    } else {
      await _handlePermissionAndAnimation();
    }
  }

  Future<void> _handlePermissionAndAnimation() async {
    if (!_permissionHandled) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PermissionScreen(
            onGranted: () async {
              _permissionHandled = true;
              Navigator.of(context).pop();
              // Set onboarding flag here
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('onboarding_complete', true);
            },
          ),
        ),
      );
    }

    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const WelcomeFirst()));
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const WelcomeTwo()));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const WelcomePage()),
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
