import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key, required this.data});

  final List<Map<String, dynamic>> data;

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  final Set<String> _filters = {'All'};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      children: [
        Text('Browse & book classes', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final filter in ['All', 'HIIT', 'Yoga', 'Strength', 'Mind & Body'])
              FilterChip(
                label: Text(filter),
                selected: _filters.contains(filter),
                onSelected: (_) {
                  setState(() {
                    if (filter == 'All') {
                      _filters
                        ..clear()
                        ..add('All');
                    } else {
                      _filters.remove('All');
                      if (!_filters.add(filter)) {
                        _filters.remove(filter);
                        if (_filters.isEmpty) _filters.add('All');
                      }
                    }
                  });
                },
              ),
          ],
        ),
        const SizedBox(height: 18),
        ...widget.data.map((item) => _ScheduleCard(item: item)),
        const SizedBox(height: 24),
        Card(
          child: ListTile(
            leading: const Icon(Icons.group_add_rounded),
            title: const Text('Invite a friend'),
            subtitle: const Text('Share a guest pass and earn referral points.'),
            trailing: OutlinedButton(
              onPressed: () => Navigator.of(context).pushNamed('/referrals'),
              child: const Text('Refer now'),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final startTime = item['startTime'] as DateTime;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['title'] as String, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        '${_formatTime(startTime)} · ${item['trainer']} · ${item['location']}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Book'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.signal_cellular_alt_rounded, color: AppColors.deepSapphire),
                const SizedBox(width: 8),
                Text('Intensity: ${item['intensity']}'),
                const SizedBox(width: 18),
                Chip(
                  label: Text('${item['spotsLeft']} spots left'),
                  backgroundColor: AppColors.platinumMist,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}




