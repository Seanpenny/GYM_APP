import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Lime green color matching the auth screen
const Color limeGreen = Color(0xFF39FF14);

class ClassHistoryView extends StatelessWidget {
  const ClassHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class History'),
        backgroundColor: limeGreen,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Your Video History',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 20),
          ..._videoHistory.map((video) => _VideoHistoryCard(video: video)),
        ],
      ),
    );
  }

  static final List<Map<String, dynamic>> _videoHistory = [
    {
      'title': 'Introduction to Boxing',
      'duration': '15:30',
      'link': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      'image': 'assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg',
    },
    {
      'title': 'Boxing Fundamentals',
      'duration': '22:45',
      'link': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      'image': 'assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg',
    },
    {
      'title': 'CrossFit Basics',
      'duration': '18:20',
      'link': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      'image': 'assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg',
    },
    {
      'title': 'MMA Striking Techniques',
      'duration': '25:10',
      'link': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      'image': 'assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg',
    },
    {
      'title': 'Weightlifting Form Guide',
      'duration': '20:00',
      'link': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      'image': 'assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg',
    },
  ];
}

class _VideoHistoryCard extends StatelessWidget {
  const _VideoHistoryCard({required this.video});

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
              width: 120,
              height: 90,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(video['image'] as String),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: const Icon(
                  Icons.play_circle_filled,
                  color: Colors.white,
                  size: 40,
                ),
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
            IconButton(
              icon: const Icon(Icons.play_arrow_rounded, color: limeGreen),
              onPressed: () => _launchVideo(video['link'] as String),
            ),
          ],
        ),
      ),
    );
  }
}

