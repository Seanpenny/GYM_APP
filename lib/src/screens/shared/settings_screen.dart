import 'package:flutter/material.dart';
import '../../services/session_service.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool pushReminders = true;
  bool pushPromos = false;
  bool pushExpiring = true;
  bool quietHours = false;
  bool shareWorkoutData = true;
  bool shareCommunityName = true;

  Future<void> _handleSignOut() async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await SessionService.clearSession();

    if (!mounted) return;

    messenger.showSnackBar(
      const SnackBar(
        content: Text('Signed out successfully.'),
        duration: Duration(seconds: 1),
      ),
    );

    navigator.pushNamedAndRemoveUntil('/auth', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Notifications', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          SwitchListTile.adaptive(
            value: pushReminders,
            onChanged: (value) => setState(() => pushReminders = value),
            title: const Text('Class reminders'),
            subtitle: const Text('Receive alerts 60 minutes before check-in.'),
          ),
          SwitchListTile.adaptive(
            value: pushPromos,
            onChanged: (value) => setState(() => pushPromos = value),
            title: const Text('Promotions & retail drops'),
          ),
          SwitchListTile.adaptive(
            value: pushExpiring,
            onChanged: (value) => setState(() => pushExpiring = value),
            title: const Text('Expiring memberships'),
          ),
          SwitchListTile.adaptive(
            value: quietHours,
            onChanged: (value) => setState(() => quietHours = value),
            title: const Text('Enable quiet hours (21:00 - 07:00)'),
          ),
          const Divider(height: 32),
          Text('Privacy & sharing', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          SwitchListTile.adaptive(
            value: shareWorkoutData,
            onChanged: (value) => setState(() => shareWorkoutData = value),
            title: const Text('Share workout data with trainers'),
            subtitle: const Text('Helps coaches personalize sessions.'),
          ),
          SwitchListTile.adaptive(
            value: shareCommunityName,
            onChanged: (value) => setState(() => shareCommunityName = value),
            title: const Text('Display name in community highlights'),
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline_rounded),
            title: const Text('Privacy policy'),
            trailing: const Icon(Icons.open_in_new_rounded),
            onTap: () {},
          ),
          const Divider(height: 32),
          Text('Linked wearables', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Card(
            child: const ListTile(
              leading: Icon(Icons.watch_rounded),
              title: Text('Apple Health'),
              subtitle: Text('Connected · syncing daily'),
              trailing: Icon(Icons.check_circle_rounded, color: AppColors.deepSapphire),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.watch_rounded),
              title: const Text('Garmin Connect'),
              subtitle: const Text('Tap to connect'),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Connect'),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.energeticCoral),
            title: const Text('Sign out'),
            onTap: _handleSignOut,
          ),
        ],
      ),
    );
  }
}




