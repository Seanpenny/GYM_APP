import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CommunityView extends StatelessWidget {
  const CommunityView({super.key, required this.highlights});

  final List<Map<String, String>> highlights;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      children: [
        Text('Community highlights', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 12),
        ...highlights.map((item) => _HighlightCard(item: item)),
        const SizedBox(height: 24),
        Card(
          child: ListTile(
            leading: const Icon(Icons.emoji_events_rounded),
            title: const Text('Join the Summit Challenge'),
            subtitle: const Text('Complete 5 outdoor sessions this month to unlock limited merch.'),
            trailing: ElevatedButton(
              onPressed: () {},
              child: const Text('Join now'),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Upcoming events', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.brightness_5_rounded),
                  title: Text('Sunrise Run Club · Saturday 06:00'),
                  subtitle: Text('Meet at the waterfront. Pace groups for all levels.'),
                ),
                const Divider(),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.local_florist_rounded),
                  title: Text('Recovery & Breathwork Workshop'),
                  subtitle: Text('Coach Nia guides you through a 45-min immersive reset.'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({required this.item});

  final Map<String, String> item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item['image'] != null)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: item['image']!.startsWith('assets/')
                  ? Image.asset(
                      item['image']!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: item['image']!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
            ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['title'] ?? '', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(item['description'] ?? '', style: theme.textTheme.bodyMedium),
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border_rounded),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.mode_comment_outlined),
                      onPressed: () {},
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Share highlight'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




