import 'package:flutter/material.dart';
import 'package:sikap/pages/welcome_screen.dart';
import 'package:sikap/utils/colors.dart';

class SplashScreen extends StatefulWidget {
    const SplashScreen({super.key});

    @override
    State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
    late AnimationController _animationController;
    late Animation<double> _fadeAnimation;
    late Animation<double> _scaleAnimation;

    @override
    void initState() {
        super.initState();
        
        // Initialize animation controller
        _animationController = AnimationController(
            duration: const Duration(seconds: 4),
            vsync: this,
        );

        // Fade animation
        _fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
        ).animate(CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeIn,
        ));

        // Scale animation
        _scaleAnimation = Tween<double>(
            begin: 0.5,
            end: 1.0,
        ).animate(CurvedAnimation(
            parent: _animationController,
            curve: Curves.elasticOut,
        ));

        // Start animation and navigate after delay
        _startSplashScreen();
    }

    void _startSplashScreen() async {
        _animationController.forward();
        
        // Wait for 4 seconds then navigate to home
        await Future.delayed(const Duration(seconds: 10));
        
        if (mounted) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const WelcomePage()),
            );
        }
    }

    @override
    void dispose() {
        _animationController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: AppColors.primaryLight,
            body: Center(
                child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                        return FadeTransition(
                            opacity: _fadeAnimation,
                            child: ScaleTransition(
                                scale: _scaleAnimation,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        // Logo
                                        Image.asset(
                                            'assets/logo/sikap-logo.png',
                                            width: 100,
                                            height: 100,
                                        ),
                                        const SizedBox(height: 20),                              // Loading indicator
                                        const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: AppColors.secondary,
                                            )
                                          ),
                                    ],
                                ),
                            ),
                        );
                    },
                ),
            ),
        );
    }
}
