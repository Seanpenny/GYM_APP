import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../data/mock_data.dart';
import '../../../services/attendance_service.dart';
import '../../../services/session_service.dart';
import '../../../theme/app_theme.dart';

const Color limeGreen = Color(0xFF39FF14);

class DashboardHomeView extends StatelessWidget {
  const DashboardHomeView({super.key, required this.member});

  final MemberProfile member;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
      children: [
        _MembershipCard(member: member),
        const SizedBox(height: 18),
        _VisitStreakCard(
          streak: member.visitStreak,
          nextBilling: member.nextBillingDate,
        ),
        const SizedBox(height: 18),
        const _CheckMyProgressCard(),
        const SizedBox(height: 18),
        Text("Today's schedule", style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        ...MockData.upcomingClasses.map((item) => _ClassTile(item: item)),
        const SizedBox(height: 18),
        _AmenityAvailability(data: MockData.equipmentAvailability),
        const SizedBox(height: 18),
        const _WeeklyInsights(),
      ],
    );
  }
}

class _MembershipCard extends StatefulWidget {
  const _MembershipCard({required this.member});

  final MemberProfile member;

  @override
  State<_MembershipCard> createState() => _MembershipCardState();
}

class _MembershipCardState extends State<_MembershipCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  String _memberName = '';
  String _membershipTier = 'Active';
  String _qrCode = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _loadCardData();
  }

  Future<void> _loadCardData() async {
    final session = await SessionService.getSession();
    final firstName = session['firstName']?.toString().trim() ?? '';
    final lastName = session['lastName']?.toString().trim() ?? '';
    final username = session['username']?.toString().trim() ?? '';
    final displayName = [firstName, lastName]
        .where((value) => value.isNotEmpty)
        .join(' ');

    if (!mounted) return;
    setState(() {
      _memberName = displayName.isNotEmpty ? displayName : username;
      _qrCode = session['qrCode']?.toString() ?? '';
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('/membership-card'),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final pulse = 0.7 + (_controller.value * 0.3);
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  limeGreen,
                  limeGreen.withValues(alpha: 0.8),
                  limeGreen.withValues(alpha: 0.9),
                ],
                transform: GradientRotation(_controller.value * math.pi * 2),
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 340;
                    final memberInfo = Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _memberName.isNotEmpty
                                ? _memberName
                                : widget.member.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '$_membershipTier Member',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    );

                    if (compact) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _buildBadgeIcon(),
                              const SizedBox(width: 16),
                              memberInfo,
                            ],
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.qr_code_2_rounded,
                              color: Colors.white.withValues(
                                alpha: pulse.clamp(0.0, 1.0),
                              ),
                              size: 40,
                            ),
                          ),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        _buildBadgeIcon(),
                        const SizedBox(width: 16),
                        memberInfo,
                        const SizedBox(width: 12),
                        Icon(
                          Icons.qr_code_2_rounded,
                          color: Colors.white.withValues(
                            alpha: pulse.clamp(0.0, 1.0),
                          ),
                          size: 44,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(
                      'Digital card',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    height: 110,
                    decoration: const BoxDecoration(color: Colors.white12),
                    alignment: Alignment.center,
                    child: _qrCode.isEmpty
                        ? Icon(
                            Icons.qr_code_2_rounded,
                            size: 84,
                            color: Colors.white.withValues(alpha: 0.85),
                          )
                        : Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: QrImageView(
                              data: _qrCode,
                              version: QrVersions.auto,
                              size: 88,
                              backgroundColor: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBadgeIcon() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.badge_rounded,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}

class _VisitStreakCard extends StatelessWidget {
  const _VisitStreakCard({required this.streak, required this.nextBilling});

  final int streak;
  final DateTime nextBilling;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 340;
            final streakBadge = Container(
              decoration: const BoxDecoration(
                color: AppColors.platinumMist,
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$streak', style: theme.textTheme.headlineMedium),
                  const Text('day streak'),
                ],
              ),
            );

            final details = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Keep the streak alive!',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  'Tap in today to unlock an Elite recovery perk.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  'Next billing: ${_formatDate(nextBilling)}',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: limeGreen,
                  ),
                ),
              ],
            );

            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  streakBadge,
                  const SizedBox(height: 16),
                  details,
                ],
              );
            }

            return Row(
              children: [
                streakBadge,
                const SizedBox(width: 24),
                Expanded(child: details),
              ],
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

class _ClassTile extends StatelessWidget {
  const _ClassTile({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final startTime = item['startTime'] as DateTime;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 360;
            final leading = Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: limeGreen.withValues(alpha: 0.1),
              ),
              child: const Icon(
                Icons.flash_on_rounded,
                color: limeGreen,
              ),
            );

            final details = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] as String,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatTime(startTime)} · ${item['trainer']} · ${item['location']}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            );

            final meta = Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  compact ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                Chip(
                  label: Text('${item['spotsLeft']} spots'),
                  backgroundColor: AppColors.platinumMist,
                ),
                const SizedBox(height: 6),
                Text(
                  item['intensity'] as String,
                  style: theme.textTheme.labelLarge,
                ),
              ],
            );

            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      leading,
                      const SizedBox(width: 16),
                      Expanded(child: details),
                    ],
                  ),
                  const SizedBox(height: 12),
                  meta,
                ],
              );
            }

            return Row(
              children: [
                leading,
                const SizedBox(width: 16),
                Expanded(child: details),
                const SizedBox(width: 12),
                meta,
              ],
            );
          },
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}

class _AmenityAvailability extends StatelessWidget {
  const _AmenityAvailability({required this.data});

  final List<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Amenity availability',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed('/equipment'),
                  child: const Text('View more'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...data.map((item) {
              final available = item['available'] as int;
              final total = item['total'] as int;
              final progress = available / total;
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(item['name'] as String)),
                        Text('$available/$total'),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: AppColors.platinumMist,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progress < 0.35
                              ? AppColors.energeticCoral
                              : limeGreen,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Peak time: ${item['peakTime']}'),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _WeeklyInsights extends StatelessWidget {
  const _WeeklyInsights();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Weekly insights', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            const Text("You're 1 session away from a new streak record!"),
            const SizedBox(height: 6),
            const Text(
              'Recovery minutes are trending up 14% versus last week.',
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: limeGreen,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Trainer Marcus suggests adding mobility before tomorrow's HIIT session.",
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckMyProgressCard extends StatefulWidget {
  const _CheckMyProgressCard();

  @override
  State<_CheckMyProgressCard> createState() => _CheckMyProgressCardState();
}

class _CheckMyProgressCardState extends State<_CheckMyProgressCard> {
  int _weeklyVisits = 0;
  List<bool> _weekDays = [false, false, false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final visits = await AttendanceService.getWeeklyVisitCount();
    final weekDays = await AttendanceService.getCurrentWeekDayVisits();

    if (mounted) {
      setState(() {
        _weeklyVisits = visits;
        _weekDays = weekDays;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('/progress-tracker'),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: limeGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.track_changes_rounded,
                      color: limeGreen,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Check My Progress',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$_weeklyVisits visits this week',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: limeGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _WeekDayIndicator(day: 'M', hasVisit: _weekDays[0]),
                  _WeekDayIndicator(day: 'T', hasVisit: _weekDays[1]),
                  _WeekDayIndicator(day: 'W', hasVisit: _weekDays[2]),
                  _WeekDayIndicator(day: 'T', hasVisit: _weekDays[3]),
                  _WeekDayIndicator(day: 'F', hasVisit: _weekDays[4]),
                  _WeekDayIndicator(day: 'S', hasVisit: _weekDays[5]),
                  _WeekDayIndicator(day: 'S', hasVisit: _weekDays[6]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeekDayIndicator extends StatelessWidget {
  const _WeekDayIndicator({required this.day, required this.hasVisit});

  final String day;
  final bool hasVisit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hasVisit ? limeGreen : AppColors.platinumMist,
          ),
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                color: hasVisit ? Colors.white : Colors.grey[600],
                fontWeight: hasVisit ? FontWeight.w600 : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
