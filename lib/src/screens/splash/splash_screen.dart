import 'package:flutter/material.dart';
import '../../services/session_service.dart';

// Lime green color matching the auth screen
const Color limeGreen = Color(0xFF39FF14);
const Color charcoalBlack = Color(0xFF0B0D10);
const Color deepCharcoal = Color(0xFF14181D);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Fade in animation for smooth appearance
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeIn,
      ),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOutCubic,
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.45, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeInOut,
      ),
    );

    // Start fade animation
    _fadeController.forward();

    // Navigate after splash duration (7 seconds)
    Future.delayed(const Duration(milliseconds: 2500), () async {
      if (!mounted) return;
      final route = await SessionService.isLoggedIn() ? '/dashboard' : '/auth';
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(route);
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final shortestSide = size.shortestSide;
    final logoSize = shortestSide < 380 ? shortestSide * 0.62 : shortestSide * 0.56;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _fadeController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.18),
                  radius: 1.1,
                  colors: [
                    deepCharcoal,
                    charcoalBlack,
                  ],
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    top: -size.height * 0.12,
                    left: -size.width * 0.15,
                    child: Container(
                      width: size.width * 0.7,
                      height: size.width * 0.7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: limeGreen.withValues(
                          alpha: 0.08 * _glowAnimation.value,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: limeGreen.withValues(
                              alpha: 0.14 * _glowAnimation.value,
                            ),
                            blurRadius: 120,
                            spreadRadius: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -size.height * 0.1,
                    right: -size.width * 0.1,
                    child: Container(
                      width: size.width * 0.5,
                      height: size.width * 0.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: limeGreen.withValues(
                          alpha: 0.05 * _glowAnimation.value,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: limeGreen.withValues(
                              alpha: 0.1 * _glowAnimation.value,
                            ),
                            blurRadius: 100,
                            spreadRadius: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: Column(
                        children: [
                          const Spacer(flex: 2),
                          Center(
                            child: Transform.scale(
                              scale: _logoScaleAnimation.value,
                              child: Container(
                                width: logoSize,
                                height: logoSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.28),
                                      blurRadius: 28,
                                      offset: const Offset(0, 10),
                                    ),
                                    BoxShadow(
                                      color: limeGreen.withValues(
                                        alpha: 0.12 * _glowAnimation.value,
                                      ),
                                      blurRadius: 36,
                                      spreadRadius: 3,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg',
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Text(
                            'George Loots Gym',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.4,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Hardcore bodybuilding. Premium member access.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white70,
                                  letterSpacing: 0.2,
                                ),
                          ),
                          const Spacer(flex: 3),
                          Column(
                            children: [
                              SizedBox(
                                width: shortestSide < 380 ? 140 : 168,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: LinearProgressIndicator(
                                    minHeight: 4,
                                    backgroundColor:
                                        Colors.white.withValues(alpha: 0.12),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                      limeGreen,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'Loading your training space',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.white60),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
