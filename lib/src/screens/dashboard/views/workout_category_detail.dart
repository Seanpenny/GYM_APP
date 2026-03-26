import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Lime green color matching the auth screen
const Color limeGreen = Color(0xFF39FF14);

class WorkoutCategoryDetail extends StatelessWidget {
  const WorkoutCategoryDetail({super.key, required this.category});

  final Map<String, dynamic> category;

  @override
  Widget build(BuildContext context) {
    final categoryName = category['name'] as String;
    final videos = _getVideosForCategory(categoryName);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header image with title and description
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: limeGreen,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    category['image'] as String,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: Colors.grey.shade800);
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoryName,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _getDescription(categoryName),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Video list
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final video = videos[index];
                  return _VideoCard(video: video);
                },
                childCount: videos.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getVideosForCategory(String categoryName) {
    final baseVideos = {
      'Boxing': [
        {'title': 'Introduction to Boxing', 'duration': '15:30', 'link': 'https://www.youtube.com/results?search_query=boxing+introduction'},
        {'title': 'Basic Stance and Footwork', 'duration': '12:45', 'link': 'https://www.youtube.com/results?search_query=boxing+stance'},
        {'title': 'Jab and Cross Techniques', 'duration': '18:20', 'link': 'https://www.youtube.com/results?search_query=boxing+jab+cross'},
        {'title': 'Hook and Uppercut Combinations', 'duration': '20:15', 'link': 'https://www.youtube.com/results?search_query=boxing+hook+uppercut'},
        {'title': 'Defensive Techniques', 'duration': '16:30', 'link': 'https://www.youtube.com/results?search_query=boxing+defense'},
        {'title': 'Bag Work Fundamentals', 'duration': '22:00', 'link': 'https://www.youtube.com/results?search_query=boxing+bag+work'},
        {'title': 'Sparring Basics', 'duration': '25:45', 'link': 'https://www.youtube.com/results?search_query=boxing+sparring'},
        {'title': 'Conditioning for Boxers', 'duration': '19:30', 'link': 'https://www.youtube.com/results?search_query=boxing+conditioning'},
      ],
      'CrossFit': [
        {'title': 'Introduction to CrossFit', 'duration': '18:45', 'link': 'https://www.youtube.com/results?search_query=crossfit+introduction'},
        {'title': 'Fundamental Movements', 'duration': '22:30', 'link': 'https://www.youtube.com/results?search_query=crossfit+fundamentals'},
        {'title': 'Olympic Lifts Basics', 'duration': '25:00', 'link': 'https://www.youtube.com/results?search_query=crossfit+olympic+lifts'},
        {'title': 'WOD Structure Explained', 'duration': '15:20', 'link': 'https://www.youtube.com/results?search_query=crossfit+wod'},
        {'title': 'Scaling for Beginners', 'duration': '17:45', 'link': 'https://www.youtube.com/results?search_query=crossfit+scaling'},
        {'title': 'Kipping and Pull-ups', 'duration': '20:30', 'link': 'https://www.youtube.com/results?search_query=crossfit+kipping'},
        {'title': 'Box Jumps and Burpees', 'duration': '14:15', 'link': 'https://www.youtube.com/results?search_query=crossfit+box+jumps'},
        {'title': 'Rowing Technique', 'duration': '19:00', 'link': 'https://www.youtube.com/results?search_query=crossfit+rowing'},
      ],
      'MMA': [
        {'title': 'Introduction to MMA', 'duration': '20:00', 'link': 'https://www.youtube.com/results?search_query=mma+introduction'},
        {'title': 'Striking Fundamentals', 'duration': '18:30', 'link': 'https://www.youtube.com/results?search_query=mma+striking'},
        {'title': 'Grappling Basics', 'duration': '22:45', 'link': 'https://www.youtube.com/results?search_query=mma+grappling'},
        {'title': 'Takedown Techniques', 'duration': '19:15', 'link': 'https://www.youtube.com/results?search_query=mma+takedowns'},
        {'title': 'Ground Control', 'duration': '21:00', 'link': 'https://www.youtube.com/results?search_query=mma+ground+control'},
        {'title': 'Submission Holds', 'duration': '17:30', 'link': 'https://www.youtube.com/results?search_query=mma+submissions'},
        {'title': 'Cage Work', 'duration': '16:45', 'link': 'https://www.youtube.com/results?search_query=mma+cage+work'},
        {'title': 'MMA Conditioning', 'duration': '23:20', 'link': 'https://www.youtube.com/results?search_query=mma+conditioning'},
      ],
      'Weightlifting': [
        {'title': 'Introduction to Weightlifting', 'duration': '16:00', 'link': 'https://www.youtube.com/results?search_query=weightlifting+introduction'},
        {'title': 'Squat Form and Technique', 'duration': '19:30', 'link': 'https://www.youtube.com/results?search_query=weightlifting+squat'},
        {'title': 'Deadlift Fundamentals', 'duration': '21:15', 'link': 'https://www.youtube.com/results?search_query=weightlifting+deadlift'},
        {'title': 'Bench Press Mastery', 'duration': '18:45', 'link': 'https://www.youtube.com/results?search_query=weightlifting+bench+press'},
        {'title': 'Overhead Press', 'duration': '15:20', 'link': 'https://www.youtube.com/results?search_query=weightlifting+overhead+press'},
        {'title': 'Program Design Basics', 'duration': '22:00', 'link': 'https://www.youtube.com/results?search_query=weightlifting+program'},
        {'title': 'Progressive Overload', 'duration': '17:30', 'link': 'https://www.youtube.com/results?search_query=weightlifting+progressive+overload'},
        {'title': 'Recovery and Nutrition', 'duration': '20:45', 'link': 'https://www.youtube.com/results?search_query=weightlifting+recovery'},
      ],
      'HIIT': [
        {'title': 'Introduction to HIIT', 'duration': '14:30', 'link': 'https://www.youtube.com/results?search_query=hiit+introduction'},
        {'title': 'HIIT Workout Structure', 'duration': '16:45', 'link': 'https://www.youtube.com/results?search_query=hiit+workout'},
        {'title': 'Bodyweight HIIT', 'duration': '18:20', 'link': 'https://www.youtube.com/results?search_query=bodyweight+hiit'},
        {'title': 'HIIT with Weights', 'duration': '20:00', 'link': 'https://www.youtube.com/results?search_query=hiit+weights'},
        {'title': 'Tabata Protocol', 'duration': '15:15', 'link': 'https://www.youtube.com/results?search_query=tabata'},
        {'title': 'HIIT for Beginners', 'duration': '17:30', 'link': 'https://www.youtube.com/results?search_query=hiit+beginners'},
        {'title': 'Advanced HIIT', 'duration': '22:45', 'link': 'https://www.youtube.com/results?search_query=advanced+hiit'},
        {'title': 'HIIT Recovery', 'duration': '13:20', 'link': 'https://www.youtube.com/results?search_query=hiit+recovery'},
      ],
      'Functional Training': [
        {'title': 'Introduction to Functional Training', 'duration': '19:00', 'link': 'https://www.youtube.com/results?search_query=functional+training+introduction'},
        {'title': 'Movement Patterns', 'duration': '21:30', 'link': 'https://www.youtube.com/results?search_query=functional+movement'},
        {'title': 'Kettlebell Basics', 'duration': '18:15', 'link': 'https://www.youtube.com/results?search_query=kettlebell+basics'},
        {'title': 'TRX Training', 'duration': '17:45', 'link': 'https://www.youtube.com/results?search_query=trx+training'},
        {'title': 'Medicine Ball Workouts', 'duration': '16:20', 'link': 'https://www.youtube.com/results?search_query=medicine+ball'},
        {'title': 'Battle Ropes', 'duration': '15:30', 'link': 'https://www.youtube.com/results?search_query=battle+ropes'},
        {'title': 'Plyometric Training', 'duration': '20:45', 'link': 'https://www.youtube.com/results?search_query=plyometric'},
        {'title': 'Core Stability', 'duration': '19:15', 'link': 'https://www.youtube.com/results?search_query=core+stability'},
      ],
      'Powerlifting': [
        {'title': 'Introduction to Powerlifting', 'duration': '20:30', 'link': 'https://www.youtube.com/results?search_query=powerlifting+introduction'},
        {'title': 'The Big Three', 'duration': '24:00', 'link': 'https://www.youtube.com/results?search_query=powerlifting+big+three'},
        {'title': 'Squat Technique', 'duration': '22:15', 'link': 'https://www.youtube.com/results?search_query=powerlifting+squat'},
        {'title': 'Bench Press Form', 'duration': '19:45', 'link': 'https://www.youtube.com/results?search_query=powerlifting+bench'},
        {'title': 'Deadlift Mastery', 'duration': '23:30', 'link': 'https://www.youtube.com/results?search_query=powerlifting+deadlift'},
        {'title': 'Programming for Powerlifting', 'duration': '21:00', 'link': 'https://www.youtube.com/results?search_query=powerlifting+program'},
        {'title': 'Peaking Strategies', 'duration': '18:20', 'link': 'https://www.youtube.com/results?search_query=powerlifting+peaking'},
        {'title': 'Accessory Work', 'duration': '17:45', 'link': 'https://www.youtube.com/results?search_query=powerlifting+accessories'},
      ],
      'Calisthenics': [
        {'title': 'Introduction to Calisthenics', 'duration': '16:45', 'link': 'https://www.youtube.com/results?search_query=calisthenics+introduction'},
        {'title': 'Push-up Progressions', 'duration': '18:30', 'link': 'https://www.youtube.com/results?search_query=push+up+progressions'},
        {'title': 'Pull-up Basics', 'duration': '17:15', 'link': 'https://www.youtube.com/results?search_query=pull+up+basics'},
        {'title': 'Handstand Training', 'duration': '20:00', 'link': 'https://www.youtube.com/results?search_query=handstand'},
        {'title': 'Muscle-up Progressions', 'duration': '19:45', 'link': 'https://www.youtube.com/results?search_query=muscle+up'},
        {'title': 'Planche Training', 'duration': '22:30', 'link': 'https://www.youtube.com/results?search_query=planche'},
        {'title': 'Human Flag', 'duration': '15:20', 'link': 'https://www.youtube.com/results?search_query=human+flag'},
        {'title': 'Calisthenics Routines', 'duration': '21:15', 'link': 'https://www.youtube.com/results?search_query=calisthenics+routine'},
      ],
    };

    return baseVideos[categoryName] ?? [];
  }

  String _getDescription(String categoryName) {
    final descriptions = {
      'Boxing': 'We use the best principles of combat sports to build strength, agility, and mental toughness.',
      'CrossFit': 'High-intensity functional movements designed to improve overall fitness and athleticism.',
      'MMA': 'Comprehensive martial arts training combining striking, grappling, and ground techniques.',
      'Weightlifting': 'Build strength and muscle through progressive resistance training and proper form.',
      'HIIT': 'High-intensity interval training to maximize calorie burn and improve cardiovascular fitness.',
      'Functional Training': 'Movement-based exercises that improve daily life activities and athletic performance.',
      'Powerlifting': 'Focus on the three main lifts: squat, bench press, and deadlift for maximum strength.',
      'Calisthenics': 'Bodyweight training to build strength, flexibility, and control using minimal equipment.',
    };
    return descriptions[categoryName] ?? 'Professional training to help you reach your fitness goals.';
  }
}

class _VideoCard extends StatelessWidget {
  const _VideoCard({required this.video});

  final Map<String, dynamic> video;

  Future<void> _launchVideo(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _launchVideo(video['link'] as String),
        child: Row(
          children: [
            Container(
              width: 140,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: Colors.grey.shade300);
                    },
                  ),
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: const Icon(
                      Icons.play_circle_filled,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video['title'] as String,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          video['duration'] as String,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                icon: const Icon(Icons.play_circle_filled, color: limeGreen, size: 40),
                onPressed: () => _launchVideo(video['link'] as String),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
