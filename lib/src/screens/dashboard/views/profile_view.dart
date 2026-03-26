import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/mock_data.dart';
import '../../../theme/app_theme.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key, required this.member});

  final MemberProfile member;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage: member.avatarUrl.startsWith('assets/')
                  ? AssetImage(member.avatarUrl) as ImageProvider
                  : CachedNetworkImageProvider(member.avatarUrl),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.name, style: theme.textTheme.titleLarge),
                Text('${member.membershipTier} member', style: theme.textTheme.bodyMedium),
              ],
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pushNamed('/membership-card'),
              icon: const Icon(Icons.qr_code_2_rounded),
              label: const Text('Check-in'),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Card(
          child: ListTile(
            leading: const Icon(Icons.workspace_premium_rounded, color: AppColors.deepSapphire),
            title: const Text('Membership & billing'),
            subtitle: Text('Next billing ${_formatDate(member.nextBillingDate)}'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.of(context).pushNamed('/payments'),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              _profileTile(
                context,
                title: 'Attendance history',
                subtitle: 'Track your check-ins and class streaks.',
                icon: Icons.history_rounded,
                route: '/attendance',
              ),
              const Divider(indent: 72),
              _profileTile(
                context,
                title: 'Personal training',
                subtitle: 'Book or reschedule your coaching.',
                icon: Icons.fitness_center_rounded,
                route: '/personal-training',
              ),
              const Divider(indent: 72),
              _profileTile(
                context,
                title: 'Goal insights',
                subtitle: 'Advanced analytics & weekly summary.',
                icon: Icons.insights_rounded,
                route: '/goal-insights',
              ),
              const Divider(indent: 72),
              _profileTile(
                context,
                title: 'Settings',
                subtitle: 'Notifications, privacy, linked devices.',
                icon: Icons.settings_rounded,
                route: '/settings',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Referral rewards', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                ...MockData.referralRewards.map((reward) {
                  final progress = reward['progress'] as num;
                  final target = reward['target'] as num;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(reward['label'] as String)),
                            Text('${progress.toInt()}/${target.toInt()}'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: LinearProgressIndicator(
                            value: (progress / target).clamp(0.0, 1.0).toDouble(),
                            minHeight: 8,
                            backgroundColor: AppColors.platinumMist,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.deepSapphire),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pushNamed('/referrals'),
                  icon: const Icon(Icons.card_giftcard_rounded),
                  label: const Text('Share your referral link'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: TextButton.icon(
            onPressed: () => Navigator.of(context).pushNamed('/support'),
            icon: const Icon(Icons.support_agent_rounded),
            label: const Text('Talk to support'),
          ),
        ),
      ],
    );
  }

  Widget _profileTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String route,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () => Navigator.of(context).pushNamed(route),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}




