import 'package:flutter/material.dart';
import 'workout_category_detail.dart';
import 'class_history_view.dart';

// Lime green color matching the auth screen
const Color limeGreen = Color(0xFF39FF14);

class WorkoutsView extends StatelessWidget {
  const WorkoutsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Top image with title
          SliverToBoxAdapter(
            child: Stack(
              children: [
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: Colors.grey.shade800);
                    },
                  ),
                ),
                // Gradient overlay for text readability
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                // Title blending into image
                Positioned(
                  bottom: 40,
                  left: 20,
                  right: 20,
                  child: Text(
                    "Let's Get Moving",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Class History Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Class History',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ClassHistoryView(),
                            ),
                          );
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(color: limeGreen),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Class History Widget
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: const Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Class History',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Find a Workout Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Find a Workout',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'View',
                          style: TextStyle(color: limeGreen),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          // Workout Categories Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final categories = _workoutCategories;
                  final category = categories[index];
                  return _WorkoutCategoryCard(
                    category: category,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => WorkoutCategoryDetail(
                            category: category,
                          ),
                        ),
                      );
                    },
                  );
                },
                childCount: _workoutCategories.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  static final List<Map<String, dynamic>> _workoutCategories = [
    {
      'name': 'Boxing',
      'image': 'assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg',
    },
    {
      'name': 'CrossFit',
      'image': 'assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg',
    },
    {
      'name': 'MMA',
      'image': 'assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg',
    },
    {
      'name': 'Weightlifting',
      'image': 'assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg',
    },
    {
      'name': 'HIIT',
      'image': 'assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg',
    },
    {
      'name': 'Functional Training',
      'image': 'assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg',
    },
    {
      'name': 'Powerlifting',
      'image': 'assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg',
    },
    {
      'name': 'Calisthenics',
      'image': 'assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg',
    },
  ];
}

class _WorkoutCategoryCard extends StatelessWidget {
  const _WorkoutCategoryCard({
    required this.category,
    required this.onTap,
  });

  final Map<String, dynamic> category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                category['image'] as String,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: Colors.grey.shade800);
                },
              ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              // Title blending into image
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    category['name'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

