import 'package:flutter/material.dart';
import '../../data/mock_data.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rewards = MockData.referralRewards;
    return Scaffold(
      appBar: AppBar(title: const Text('Referral program')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.card_giftcard_rounded),
              title: const Text('Share your link'),
              subtitle: const Text('When friends join, you both unlock premium perks.'),
              trailing: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share_rounded),
                label: const Text('Share'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Reward tiers', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...rewards.map((reward) => _RewardProgress(data: reward)),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Top ambassadors this month'),
                  SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(child: Text('J')),
                    title: Text('Jordan Blake'),
                    subtitle: Text('5 referrals · R450 rewards earned'),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(child: Text('S')),
                    title: Text('Sierra Lee'),
                    subtitle: Text('4 referrals · R400 rewards earned'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardProgress extends StatelessWidget {
  const _RewardProgress({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final progress = data['progress'] as num;
    final target = data['target'] as num;
    final ratio = (progress / target).clamp(0.0, 1.0);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data['label'] as String, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: ratio.toDouble(),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 6),
            Text('${progress.toInt()} of ${target.toInt()} referrals'),
          ],
        ),
      ),
    );
  }
}




