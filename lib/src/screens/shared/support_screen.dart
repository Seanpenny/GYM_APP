import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Support & chat'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Chat'),
              Tab(text: 'Help center'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ChatTab(),
            _HelpCenterTab(),
          ],
        ),
      ),
    );
  }
}

class _ChatTab extends StatelessWidget {
  const _ChatTab();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: const [
              _MessageBubble(
                alignment: Alignment.centerLeft,
                backgroundColor: Color(0xFFF2F4F7),
                text: 'Hi Alex! I’m your concierge. Want help rescheduling tomorrow’s PT session?',
              ),
              SizedBox(height: 12),
              _MessageBubble(
                alignment: Alignment.centerRight,
                backgroundColor: Color(0xFF102A66),
                textColor: Colors.white,
                text: 'Yes please, can we move it to 18:00?',
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Type a message',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.attach_file_rounded),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FloatingActionButton.small(
                onPressed: () {},
                child: const Icon(Icons.send_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HelpCenterTab extends StatelessWidget {
  const _HelpCenterTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Popular topics', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        const _HelpTopic(title: 'Update payment method', description: 'Keep autopay active and avoid lapses.'),
        const SizedBox(height: 12),
        const _HelpTopic(title: 'Freeze membership', description: 'Need a break? Submit a request in seconds.'),
        const SizedBox(height: 12),
        const _HelpTopic(title: 'Guest pass policy', description: 'Invite friends and unlock referral tiers.'),
        const SizedBox(height: 24),
        Card(
          child: ListTile(
            leading: const Icon(Icons.call_rounded),
            title: const Text('Call concierge'),
            subtitle: const Text('+27 21 555 0198 · 05:00 - 22:00 daily'),
            trailing: ElevatedButton(
              onPressed: () {},
              child: const Text('Call now'),
            ),
          ),
        ),
      ],
    );
  }
}

class _HelpTopic extends StatelessWidget {
  const _HelpTopic({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.live_help_rounded),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {},
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.alignment,
    required this.backgroundColor,
    required this.text,
    this.textColor,
  });

  final Alignment alignment;
  final Color backgroundColor;
  final Color? textColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor ?? Colors.black87),
        ),
      ),
    );
  }
}




