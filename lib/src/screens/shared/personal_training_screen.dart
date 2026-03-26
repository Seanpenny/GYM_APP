import 'package:flutter/material.dart';
import '../../data/mock_data.dart';

class PersonalTrainingScreen extends StatelessWidget {
  const PersonalTrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = MockData.personalTrainingSlots;
    return Scaffold(
      appBar: AppBar(title: const Text('Personal training')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Choose your coach'),
          const SizedBox(height: 12),
          ...data.map((item) => _TrainerCard(data: item)),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today_rounded),
              title: const Text('Manage packages'),
              subtitle: const Text('View sessions remaining, renew or upgrade.'),
              trailing: ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/payments'),
                child: const Text('Manage'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrainerCard extends StatelessWidget {
  const _TrainerCard({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final nextAvailability = data['nextAvailability'] as DateTime;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                  child: Text(data['trainer'].toString().isNotEmpty ? data['trainer'].toString()[0] : '?'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['trainer'] as String, style: Theme.of(context).textTheme.titleMedium),
                    Text(data['specialty'] as String),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber),
                    Text('${data['rating']}'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.access_time_rounded),
                const SizedBox(width: 8),
                Text('Next availability: ${_formatDate(nextAvailability)}'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('View profile'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Book session'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month} · ${date.hour}:00';
}
