import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../services/session_service.dart';
import 'views/dashboard_home_view.dart';
import 'views/schedule_view.dart';
import 'views/ai_assistant_view.dart';
import 'views/workouts_view.dart';
import 'views/profile_view.dart';

// Lime green color matching the auth screen
const Color limeGreen = Color(0xFF39FF14);

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int _selectedIndex = 0;
  String _firstName = MockData.member.name.split(' ').first;
  String _displayName = MockData.member.name;

  late final List<Widget> _views = [
    DashboardHomeView(member: MockData.member),
    ScheduleView(data: MockData.upcomingClasses),
    const AiAssistantView(),
    const WorkoutsView(),
    ProfileView(member: MockData.member),
  ];

  void _onNavTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final navigator = Navigator.of(context);
    if (!await SessionService.isLoggedIn()) {
      if (!mounted) return;
      navigator.pushNamedAndRemoveUntil('/auth', (route) => false);
      return;
    }

    final session = await SessionService.getSession();
    if (!mounted) return;
    final firstName = session['firstName']?.toString().trim() ?? '';
    final lastName = session['lastName']?.toString().trim() ?? '';
    final username = session['username']?.toString().trim() ?? '';
    final displayName = [firstName, lastName].where((value) => value.isNotEmpty).join(' ');

    setState(() {
      _firstName = firstName.isNotEmpty ? firstName : username;
      _displayName = displayName.isNotEmpty ? displayName : username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi $_firstName,'),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () => Navigator.of(context).pushNamed('/notifications'),
          ),
        ],
      ),
      drawer: _DashboardDrawer(displayName: _displayName),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 240),
        child: IndexedStack(index: _selectedIndex, children: _views),
      ),
      bottomNavigationBar: _CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}

class _DashboardDrawer extends StatelessWidget {
  const _DashboardDrawer({required this.displayName});

  final String displayName;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: limeGreen,
                child: Icon(Icons.person),
              ),
              title: Text(displayName),
              subtitle: const Text('Elite Membership'),
              trailing: IconButton(
                icon: const Icon(Icons.qr_code_2_rounded),
                onPressed: () =>
                    Navigator.of(context).pushNamed('/membership-card'),
              ),
            ),
            const Divider(),
            _drawerItem(
              context,
              title: 'Attendance history',
              icon: Icons.history_rounded,
              route: '/attendance',
            ),
            _drawerItem(
              context,
              title: 'Personal training',
              icon: Icons.fitness_center_rounded,
              route: '/personal-training',
            ),
            _drawerItem(
              context,
              title: 'Equipment availability',
              icon: Icons.devices_other_rounded,
              route: '/equipment',
            ),
            _drawerItem(
              context,
              title: 'Payments & upgrades',
              icon: Icons.account_balance_wallet_rounded,
              route: '/payments',
            ),
            _drawerItem(
              context,
              title: 'Referral program',
              icon: Icons.card_giftcard_rounded,
              route: '/referrals',
            ),
            _drawerItem(
              context,
              title: 'Goal insights',
              icon: Icons.insights_rounded,
              route: '/goal-insights',
            ),
            _drawerItem(
              context,
              title: 'Support & chat',
              icon: Icons.support_agent_rounded,
              route: '/support',
            ),
            _drawerItem(
              context,
              title: 'Settings',
              icon: Icons.settings_rounded,
              route: '/settings',
            ),
          ],
        ),
      ),
    );
  }

  ListTile _drawerItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(route);
      },
    );
  }
}

class _CustomBottomNavBar extends StatelessWidget {
  const _CustomBottomNavBar({required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: limeGreen,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home_rounded,
            label: 'Home',
            isSelected: selectedIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavItem(
            icon: Icons.event_available_outlined,
            selectedIcon: Icons.event_available_rounded,
            label: 'Schedule',
            isSelected: selectedIndex == 1,
            onTap: () => onTap(1),
          ),
          // Special circular button for Goals (middle button)
          _CircularNavButton(
            isSelected: selectedIndex == 2,
            onTap: () => onTap(2),
          ),
          _NavItem(
            icon: Icons.fitness_center_outlined,
            selectedIcon: Icons.fitness_center_rounded,
            label: 'Workouts',
            isSelected: selectedIndex == 3,
            onTap: () => onTap(3),
          ),
          _NavItem(
            icon: Icons.person_outline_rounded,
            selectedIcon: Icons.person_rounded,
            label: 'Profile',
            isSelected: selectedIndex == 4,
            onTap: () => onTap(4),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? selectedIcon : icon,
            color: isSelected ? Colors.white : Colors.white70,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.white70,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircularNavButton extends StatelessWidget {
  const _CircularNavButton({required this.isSelected, required this.onTap});

  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: limeGreen, width: isSelected ? 3 : 2),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: limeGreen.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg',
                fit: BoxFit.cover,
                width: 50,
                height: 50,
                errorBuilder: (context, error, stackTrace) {
                  debugPrint('Dashboard nav image error: $error');
                  return Container(
                    color: limeGreen,
                    child: const Icon(
                      Icons.fitness_center_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Goals',
            style: TextStyle(
              fontSize: 11,
              color: isSelected ? Colors.white : Colors.white70,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
