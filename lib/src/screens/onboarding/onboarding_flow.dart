import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../utils/safe_fonts.dart';

// Lime green color matching the auth screen
const Color limeGreen = Color(0xFF39FF14);

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _pages = const [
    _OnboardingPageData(
      title: 'Unlock Your Strongest Self',
      description:
          'Frictionless check-ins, elite coaching, and real-time insights with the George Loots companion.',
      asset: 'assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg',
      isAsset: true,
    ),
    _OnboardingPageData(
      title: 'Your Schedule, Supercharged',
      description:
          'Book classes, personal training, and amenities in a tap. Sync reminders across every device.',
      asset: 'assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg',
      isAsset: true,
    ),
    _OnboardingPageData(
      title: 'Celebrate Every Milestone',
      description:
          'Track streaks, unlock rewards, and champion your community with premium storytelling.',
      asset: 'assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg',
      isAsset: true,
    ),
  ];

  void _goTo(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
    );
  }

  void _handleSkip() {
    Navigator.of(context).pushReplacementNamed('/auth');
  }

  void _handleNext() {
    if (_currentPage == _pages.length - 1) {
      _handleSkip();
    } else {
      _goTo(_currentPage + 1);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 380 ? 16.0 : 24.0;
    final titleSize = screenWidth < 380 ? 28.0 : 32.0;
    return Scaffold(
      backgroundColor: AppColors.midnightCharcoal,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _handleSkip,
                child: const Text('Skip', style: TextStyle(color: limeGreen)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 16,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                page.isAsset
                                    ? _AssetImageWidget(assetPath: page.asset)
                                    : Image.network(
                                        page.asset,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return DecoratedBox(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.white.withValues(
                                                        alpha: 0.1,
                                                      ),
                                                      Colors.white.withValues(
                                                        alpha: 0.08,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                child: const Center(
                                                  child:
                                                      CircularProgressIndicator.adaptive(),
                                                ),
                                              );
                                            },
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  color: Colors.grey.shade800,
                                                  child: const Icon(
                                                    Icons.image_not_supported,
                                                    color: Colors.white,
                                                    size: 48,
                                                  ),
                                                ),
                                      ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withValues(alpha: 0.65),
                                          Colors.black.withValues(alpha: 0.2),
                                        ],
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          page.title,
                                          style: SafeFonts.interTight(
                                            fontSize: titleSize,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: -1,
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        Text(
                                          page.description,
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _pages.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 320),
                              curve: Curves.easeOut,
                              width: _currentPage == index ? 26 : 10,
                              height: 10,
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? limeGreen
                                    : Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _handleNext,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: limeGreen,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: Text(
                              _currentPage == _pages.length - 1
                                  ? 'Enter the Club'
                                  : 'Next',
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => _goTo(_pages.length - 1),
                          child: const Text(
                            'Already a member? Sign in',
                            style: TextStyle(color: limeGreen),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.title,
    required this.description,
    required this.asset,
    this.isAsset = false,
  });

  final String title;
  final String description;
  final String asset;
  final bool isAsset;
}

class _AssetImageWidget extends StatelessWidget {
  const _AssetImageWidget({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(assetPath), fit: BoxFit.cover),
      ),
    );
  }
}
