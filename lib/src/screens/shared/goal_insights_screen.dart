import 'package:flutter/material.dart';

class GoalInsightsScreen extends StatelessWidget {
  const GoalInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Goal insights')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Weekly performance', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Theme.of(context).colorScheme.surface,
            ),
            alignment: Alignment.center,
            child: const Text('Chart placeholder'),
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.auto_graph_rounded),
              title: const Text('Strength volume up 18%'),
              subtitle: const Text('Keep intensity, add recovery to break plateau next week.'),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.monitor_heart_rounded),
              title: const Text('Heart rate zones'),
              subtitle: const Text('Zone 2 sessions trending down. Schedule an aerobic ride.'),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.mail_outline_rounded),
            label: const Text('Send insights to your trainer'),
          ),
        ],
      ),
    );
  }
}




