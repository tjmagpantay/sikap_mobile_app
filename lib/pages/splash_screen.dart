import 'package:flutter/material.dart';
import 'package:sikap/pages/welcome_first.dart'; 
import 'package:sikap/utils/colors.dart';

class SplashScreen extends StatefulWidget {
    const SplashScreen({super.key});

    @override
    State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
    late AnimationController _logoAnimationController;
    late AnimationController _dotsAnimationController;
    late Animation<double> _fadeAnimation;
    late Animation<double> _scaleAnimation;

    @override
    void initState() {
        super.initState();
        
        // Initialize logo animation controller
        _logoAnimationController = AnimationController(
            duration: const Duration(seconds: 2),
            vsync: this,
        );

        // Initialize dots animation controller
        _dotsAnimationController = AnimationController(
            duration: const Duration(milliseconds: 1200),
            vsync: this,
        );

        // Fade animation for logo
        _fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
        ).animate(CurvedAnimation(
            parent: _logoAnimationController,
            curve: Curves.easeIn,
        ));

        // Scale animation for logo
        _scaleAnimation = Tween<double>(
            begin: 0.5,
            end: 1.0,
        ).animate(CurvedAnimation(
            parent: _logoAnimationController,
            curve: Curves.elasticOut,
        ));

        // Start animation and navigate after delay
        _startSplashScreen();
    }

    void _startSplashScreen() async {
        // Start logo animation
        _logoAnimationController.forward();
        
        // Wait a bit then start dots animation
        await Future.delayed(const Duration(milliseconds: 500));
        _dotsAnimationController.repeat();
        
        // Wait for total 5 seconds then navigate
        await Future.delayed(const Duration(seconds: 4, milliseconds: 500));
        
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
            backgroundColor: AppColors.primary, // Dark blue background
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        // Logo with animations
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
                                                            // Fallback if image doesn't load
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
                        
                        // Animated loading dots
                        AnimatedBuilder(
                            animation: _dotsAnimationController,
                            builder: (context, child) {
                                return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(4, (index) {
                                        final delay = index * 0.2;
                                        final animationValue = Curves.easeInOut.transform(
                                            (((_dotsAnimationController.value - delay) % 1.0).clamp(0.0, 1.0))
                                        );
                                        
                                        return Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 4),
                                            child: AnimatedContainer(
                                                duration: const Duration(milliseconds: 300),
                                                width: index == 0 ? 24 : 8, // First dot is longer (orange)
                                                height: 8,
                                                decoration: BoxDecoration(
                                                    color: index == 0 
                                                        ? AppColors.secondary.withOpacity(0.4 + (animationValue * 0.6))
                                                        : Colors.white.withOpacity(0.4 + (animationValue * 0.6)),
                                                    borderRadius: BorderRadius.circular(4),
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

class CheckmarkPainter extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {
        final paint = Paint()
            ..color = AppColors.secondary
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5;

        final path = Path()
            ..moveTo(size.width * 0.3, size.height * 0.5)
            ..lineTo(size.width * 0.45, size.height * 0.65)
            ..lineTo(size.width * 0.7, size.height * 0.35);

        canvas.drawPath(path, paint);
    }

    @override
    bool shouldRepaint(covariant CustomPainter oldDelegate) {
        return false;
    }
}
