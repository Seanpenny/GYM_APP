import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_theme.dart';

class EquipmentAvailabilityScreen extends StatelessWidget {
  const EquipmentAvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = MockData.equipmentAvailability;
    return Scaffold(
      appBar: AppBar(title: const Text('Equipment & amenities')),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          final progress = (item['available'] as int) / (item['total'] as int);
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['name'] as String, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text('Available now: ${item['available']}/${item['total']}'),
                      const Spacer(),
                      Chip(
                        label: Text('Peak: ${item['peakTime']}'),
                        backgroundColor: AppColors.platinumMist,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: AppColors.platinumMist,
                      valueColor: AlwaysStoppedAnimation(progress > 0.4 ? AppColors.deepSapphire : AppColors.energeticCoral),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Forecast: ${progress > 0.4 ? 'Comfortable availability expected over the next 3 hours.' : 'Consider booking ahead or visiting during quiet hours.'}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_active_outlined),
                    label: const Text('Notify me when open'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}




