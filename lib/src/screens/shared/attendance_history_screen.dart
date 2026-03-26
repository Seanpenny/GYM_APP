import 'package:flutter/material.dart';
import '../../data/mock_data.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = MockData.attendanceHistory;
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance history')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: history.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Card(
              child: ListTile(
                leading: const Icon(Icons.emoji_events_rounded),
                title: const Text('Longest streak · 14 visits'),
                subtitle: const Text('Unlocked 18 September 2025'),
                trailing: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Share'),
                ),
              ),
            );
          }
          final item = history[index - 1];
          final date = item['date'] as DateTime;
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                child: const Icon(Icons.check_circle_rounded),
              ),
              title: Text(item['className'] as String),
              subtitle: Text('${item['trainer']} · ${item['location']}'),
              trailing: Text('${date.day}/${date.month}/${date.year}'),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.download_rounded),
          label: const Text('Export attendance report'),
        ),
      ),
    );
  }
}
