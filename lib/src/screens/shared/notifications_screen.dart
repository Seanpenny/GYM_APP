import 'package:flutter/material.dart';
import '../../data/mock_data.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = MockData.notifications;
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = notifications[index];
          final timestamp = item['timestamp'] as DateTime;
          return Card(
            child: ListTile(
              leading: Icon(_iconForType(item['type'] as String)),
              title: Text(item['title'] as String),
              subtitle: Text(item['body'] as String),
              trailing: Text('${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}'),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: OutlinedButton.icon(
          onPressed: () => Navigator.of(context).pushNamed('/settings'),
          icon: const Icon(Icons.tune_rounded),
          label: const Text('Notification preferences'),
        ),
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'streak':
        return Icons.local_fire_department_rounded;
      case 'class':
        return Icons.event_available_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }
}




