import 'package:flutter/material.dart';
import '../../data/mock_data.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final payments = MockData.paymentHistory;
    return Scaffold(
      appBar: AppBar(title: const Text('Payments & upgrades')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.workspace_premium_rounded),
              title: const Text('Upgrade to Black tier'),
              subtitle: const Text('Unlimited PT credits, concierge lounge, exclusive events.'),
              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text('Compare plans'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Payment history', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...payments.map((item) => _PaymentTile(item: item)),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.payment_rounded),
            label: const Text('Update payment method'),
          ),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final date = item['date'] as DateTime;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.receipt_long_rounded),
        title: Text('Membership · ${_formatDate(date)}'),
        subtitle: Text(item['method'] as String),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('R${(item['amount'] as num).toStringAsFixed(2)}'),
            Text(item['status'] as String, style: const TextStyle(color: Colors.green)),
          ],
        ),
        onTap: () {},
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}




