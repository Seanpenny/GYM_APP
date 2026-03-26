import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../data/mock_data.dart';
import '../../services/session_service.dart';
import '../../theme/app_theme.dart';
import '../../services/attendance_service.dart';

class MembershipCardScreen extends StatefulWidget {
  const MembershipCardScreen({super.key});

  @override
  State<MembershipCardScreen> createState() => _MembershipCardScreenState();
}

class _MembershipCardScreenState extends State<MembershipCardScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _highContrast = false;
  String _qrCode = '';
  String _memberName = MockData.member.name;
  String _membershipTier = MockData.member.membershipTier;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _loadSessionData();
  }

  Future<void> _loadSessionData() async {
    final session = await SessionService.getSession();
    final firstName = session['firstName']?.toString().trim() ?? '';
    final lastName = session['lastName']?.toString().trim() ?? '';
    final username = session['username']?.toString().trim() ?? '';
    final displayName = [firstName, lastName].where((value) => value.isNotEmpty).join(' ');
    if (mounted) {
      setState(() {
        _qrCode = session['qrCode']?.toString() ?? '';
        _memberName = displayName.isNotEmpty ? displayName : username;
      });
    }
  }

  Widget _buildQrCode() {
    if (_qrCode.isEmpty) {
      return Icon(
        Icons.qr_code_2_rounded,
        size: 160,
        color: _highContrast ? Colors.black : AppColors.deepSapphire,
      );
    }

    return QrImageView(
      data: _qrCode,
      version: QrVersions.auto,
      size: 180,
      backgroundColor: Colors.white,
      foregroundColor: _highContrast ? Colors.black : AppColors.deepSapphire,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final member = MockData.member;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Membership card')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final t = _controller.value;
                final gradientColors = [
                  Color.lerp(
                    AppColors.deepSapphire,
                    AppColors.electricIndigo,
                    (math.sin(t * math.pi * 2) + 1) / 2,
                  )!,
                  Color.lerp(
                    AppColors.electricIndigo,
                    AppColors.energeticCoral,
                    (math.cos(t * math.pi * 2) + 1) / 2,
                  )!,
                ];
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: gradientColors.first.withValues(alpha: 0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: member.avatarUrl.startsWith('assets/')
                                ? AssetImage(member.avatarUrl) as ImageProvider
                                : CachedNetworkImageProvider(member.avatarUrl),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _memberName,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '$_membershipTier member',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.center,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.8, end: 1.0),
                          duration: const Duration(milliseconds: 1200),
                          curve: Curves.easeInOut,
                          builder: (context, value, child) =>
                              Transform.scale(scale: value, child: child),
                          child: Container(
                            height: 220,
                            width: 220,
                            decoration: BoxDecoration(
                              color: _highContrast
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                width: 2,
                                color: _highContrast
                                    ? Colors.black
                                    : Colors.white70,
                              ),
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(16),
                            child: _buildQrCode(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _qrCode.isEmpty ? 'No barcode assigned yet' : 'Official member barcode',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const Icon(
                            Icons.security_rounded,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            SwitchListTile.adaptive(
              title: const Text('High-contrast QR for accessibility'),
              subtitle: const Text(
                'Optimized for scanners in low-light conditions.',
              ),
              value: _highContrast,
              onChanged: (value) => setState(() => _highContrast = value),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: const Text('Need help at the gate?'),
                subtitle: const Text(
                  'Show this screen or contact the concierge from support.',
                ),
                trailing: TextButton(
                  onPressed: () => Navigator.of(context).pushNamed('/support'),
                  child: const Text('Support'),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.refresh_rounded),
                title: const Text('Reload barcode'),
                subtitle: const Text('Refresh the official barcode from your session'),
                trailing: IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  onPressed: _loadSessionData,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _CheckInButton(),
          ],
        ),
      ),
    );
  }
}

class _CheckInButton extends StatefulWidget {
  const _CheckInButton();

  @override
  State<_CheckInButton> createState() => _CheckInButtonState();
}

class _CheckInButtonState extends State<_CheckInButton> {
  bool _isCheckingIn = false;

  Future<void> _handleCheckIn() async {
    setState(() => _isCheckingIn = true);
    
    // Record visit (simulates QR code scan at gym entrance)
    await AttendanceService.recordVisit(DateTime.now());
    
    if (mounted) {
      setState(() => _isCheckingIn = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Check-in recorded! Visit tracked in your progress.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.deepSapphire,
      child: InkWell(
        onTap: _isCheckingIn ? null : _handleCheckIn,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isCheckingIn)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else
                const Icon(Icons.check_circle_rounded, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                _isCheckingIn ? 'Recording visit...' : 'Simulate Check-In',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
