import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/attendance_service.dart';
import '../../utils/safe_fonts.dart';

class ProgressTrackerScreen extends StatefulWidget {
  const ProgressTrackerScreen({super.key});

  @override
  State<ProgressTrackerScreen> createState() => _ProgressTrackerScreenState();
}

class _ProgressTrackerScreenState extends State<ProgressTrackerScreen> {
  int _selectedPeriod = 12; // 12, 26, or 52 weeks
  DateTime _selectedMonth = DateTime.now();
  int _weeklyVisits = 0;
  int _weeklyStreak = 0;
  List<DateTime> _visitDates = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final weeklyCount = await AttendanceService.getWeeklyVisitCount();
    final streak = await AttendanceService.getWeeklyStreak();
    final visits = await AttendanceService.getVisitDatesAsDateTime();

    if (mounted) {
      setState(() {
        _weeklyVisits = weeklyCount;
        _weeklyStreak = streak;
        _visitDates = visits;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reward Progress')),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header Stats
            _buildHeaderStats(),
            const SizedBox(height: 24),
            // Period Selector
            _buildPeriodSelector(),
            const SizedBox(height: 24),
            // Calendar Section
            _buildCalendarSection(),
            const SizedBox(height: 24),
            // Motivational Message
            _buildMotivationalCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This Week',
              style: SafeFonts.interTight(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _StatBox(
                    label: 'Times Visited',
                    value: '$_weeklyVisits',
                    icon: Icons.fitness_center_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatBox(
                    label: 'Week Streaks',
                    value: '$_weeklyStreak',
                    icon: Icons.local_fire_department_rounded,
                    color: AppColors.energeticCoral,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.platinumMist,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.deepSapphire,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Visit at least twice a week to build your streak!',
                      style: TextStyle(
                        color: AppColors.deepSapphire,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress Period',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _PeriodChip(
                  label: '12 Weeks',
                  weeks: 12,
                  isSelected: _selectedPeriod == 12,
                  onTap: () => setState(() => _selectedPeriod = 12),
                ),
                const SizedBox(width: 8),
                _PeriodChip(
                  label: '26 Weeks',
                  weeks: 26,
                  isSelected: _selectedPeriod == 26,
                  onTap: () => setState(() => _selectedPeriod = 26),
                ),
                const SizedBox(width: 8),
                _PeriodChip(
                  label: '52 Weeks',
                  weeks: 52,
                  isSelected: _selectedPeriod == 52,
                  onTap: () => setState(() => _selectedPeriod = 52),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${_getMonthName(_selectedMonth.month)} ${_selectedMonth.year}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded),
                  onPressed: () {
                    setState(() {
                      _selectedMonth = DateTime(
                        _selectedMonth.year,
                        _selectedMonth.month - 1,
                      );
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded),
                  onPressed: () {
                    setState(() {
                      _selectedMonth = DateTime(
                        _selectedMonth.year,
                        _selectedMonth.month + 1,
                      );
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildMonthCalendar(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthCalendar() {
    final firstDay = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final lastDay = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    final firstWeekday = firstDay.weekday;
    final daysInMonth = lastDay.day;

    // Get all dates in month that have visits
    final monthVisits = _visitDates.where((date) {
      return date.year == _selectedMonth.year &&
          date.month == _selectedMonth.month;
    }).toList();

    return Column(
      children: [
        // Day headers (MTWTFSS)
        Row(
          children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
              .map(
                (day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        // Calendar grid
        ...List.generate(6, (weekIndex) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: List.generate(7, (dayIndex) {
                final dayNumber = (weekIndex * 7) + dayIndex - firstWeekday + 2;

                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return const Expanded(child: SizedBox());
                }

                final dayDate = DateTime(
                  _selectedMonth.year,
                  _selectedMonth.month,
                  dayNumber,
                );

                final hasVisit = monthVisits.any((visit) {
                  return visit.year == dayDate.year &&
                      visit.month == dayDate.month &&
                      visit.day == dayDate.day;
                });

                final isToday =
                    dayDate.year == DateTime.now().year &&
                    dayDate.month == DateTime.now().month &&
                    dayDate.day == DateTime.now().day;

                return Expanded(
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hasVisit
                            ? AppColors.deepSapphire
                            : Colors.transparent,
                        border: isToday
                            ? Border.all(
                                color: AppColors.energeticCoral,
                                width: 2,
                              )
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '$dayNumber',
                          style: TextStyle(
                            color: hasVisit
                                ? Colors.white
                                : isToday
                                ? AppColors.energeticCoral
                                : Colors.black87,
                            fontWeight: hasVisit || isToday
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
        const SizedBox(height: 12),
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendItem(color: AppColors.deepSapphire, label: 'Visited'),
            const SizedBox(width: 16),
            _LegendItem(
              color: AppColors.energeticCoral,
              label: 'Today',
              isBorder: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMotivationalCard() {
    return Card(
      color: AppColors.deepSapphire,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emoji_events_rounded, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Meet Your Weekly Goals',
                  style: SafeFonts.interTight(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Build your streak to get your milestone. Every visit counts!',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Scan your QR code at the gym to automatically track your progress.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.platinumMist,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color ?? AppColors.deepSapphire),
          const SizedBox(height: 8),
          Text(
            value,
            style: SafeFonts.interTight(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: color ?? AppColors.deepSapphire,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  const _PeriodChip({
    required this.label,
    required this.weeks,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int weeks;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.deepSapphire : AppColors.platinumMist,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    this.isBorder = false,
  });

  final Color color;
  final String label;
  final bool isBorder;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isBorder ? Colors.transparent : color,
            border: isBorder ? Border.all(color: color, width: 2) : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
