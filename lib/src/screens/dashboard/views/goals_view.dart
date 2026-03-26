import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class GoalsView extends StatelessWidget {
  const GoalsView({super.key, required this.goals});

  final List<Map<String, dynamic>> goals;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      children: [
        Text('Goal tracking', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 12),
        ...goals.map((goal) => _GoalCard(goal: goal)),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Weekly insights', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                const Text('• You hit 75% of your strength sessions target.'),
                const SizedBox(height: 6),
                const Text('• Add 15 recovery minutes to unlock a sleep perk.'),
                const SizedBox(height: 12),
                FilledButton.tonal(
                  onPressed: () => Navigator.of(context).pushNamed('/goal-insights'),
                  child: const Text('View detailed analytics'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.sync_rounded),
            title: const Text('Link your wearable'),
            subtitle: const Text('Sync Apple Health, Google Fit, Garmin and more.'),
            trailing: ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/settings'),
              child: const Text('Connect'),
            ),
          ),
        ),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.goal});

  final Map<String, dynamic> goal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final current = goal['current'] as num;
    final target = goal['target'] as num;
    final progress = (current / target).clamp(0.0, 1.0);
    final unit = goal['unit'] as String? ?? 'sessions';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(goal['label'] as String, style: theme.textTheme.titleMedium),
                ),
                Text('${(progress * 100).round()}%'),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: progress.toDouble(),
                minHeight: 10,
                backgroundColor: AppColors.platinumMist,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress >= 1 ? AppColors.energeticCoral : AppColors.deepSapphire,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text('$current of $target $unit logged'),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_task_rounded),
              label: const Text('Log progress'),
            ),
          ],
        ),
      ),
    );
  }
}




