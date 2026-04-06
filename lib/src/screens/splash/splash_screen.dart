import 'package:flutter/material.dart';
import '../../services/session_service.dart';

const Color accentGreen = Color(0xFF7ED957);
const Color charcoalBlack = Color(0xFF0B0D10);
const Color deepCharcoal = Color(0xFF161A20);

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
  late Animation<double> _pulseAnimation;

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

    _pulseAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
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
    final emblemSize = shortestSide < 380 ? 112.0 : 132.0;

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
                        color: accentGreen.withValues(
                          alpha: 0.06 * _pulseAnimation.value,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accentGreen.withValues(
                              alpha: 0.1 * _pulseAnimation.value,
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
                        color: accentGreen.withValues(
                          alpha: 0.04 * _pulseAnimation.value,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accentGreen.withValues(
                              alpha: 0.08 * _pulseAnimation.value,
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
                                width: emblemSize,
                                height: emblemSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF12161C),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.08),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.28),
                                      blurRadius: 28,
                                      offset: const Offset(0, 10),
                                    ),
                                    BoxShadow(
                                      color: accentGreen.withValues(
                                        alpha: 0.12 * _pulseAnimation.value,
                                      ),
                                      blurRadius: 36,
                                      spreadRadius: 3,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.fitness_center_rounded,
                                  size: emblemSize * 0.42,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Text(
                            'Gym App',
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
                            'Member access, check-ins, and training in one place.',
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
                                      accentGreen,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'Preparing your gym experience',
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
