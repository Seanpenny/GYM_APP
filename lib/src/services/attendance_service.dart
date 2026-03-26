import 'package:shared_preferences/shared_preferences.dart';

class AttendanceService {
  static const String _attendanceKey = 'gym_attendance_dates';

  /// Record a visit when user checks in via QR code
  static Future<void> recordVisit(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final visits = await getVisitDates();
    
    // Only record one visit per day (normalize to date only)
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final dateString = _dateToString(normalizedDate);
    
    if (!visits.contains(dateString)) {
      visits.add(dateString);
      await prefs.setStringList(_attendanceKey, visits);
    }
  }

  /// Get all visit dates as strings
  static Future<List<String>> getVisitDates() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_attendanceKey) ?? [];
  }

  /// Get all visit dates as DateTime objects
  static Future<List<DateTime>> getVisitDatesAsDateTime() async {
    final dateStrings = await getVisitDates();
    return dateStrings.map((s) => _stringToDate(s)).toList();
  }

  /// Check if a specific date has a visit
  static Future<bool> hasVisitOnDate(DateTime date) async {
    final visits = await getVisitDates();
    final dateString = _dateToString(DateTime(date.year, date.month, date.day));
    return visits.contains(dateString);
  }

  /// Get visits count for current week
  static Future<int> getWeeklyVisitCount() async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    
    final visits = await getVisitDatesAsDateTime();
    return visits.where((date) {
      return date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
             date.isBefore(weekEnd.add(const Duration(days: 1)));
    }).length;
  }

  /// Get visits for a specific week
  static Future<List<DateTime>> getWeekVisits(DateTime weekStart) async {
    final weekEnd = weekStart.add(const Duration(days: 6));
    final visits = await getVisitDatesAsDateTime();
    
    return visits.where((date) {
      return date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
             date.isBefore(weekEnd.add(const Duration(days: 1)));
    }).toList();
  }

  /// Check if week has minimum 2 visits (weak streak requirement)
  static Future<bool> meetsWeeklyGoal(DateTime weekStart) async {
    final weekVisits = await getWeekVisits(weekStart);
    return weekVisits.length >= 2;
  }

  /// Get current streak of weeks with 2+ visits
  static Future<int> getWeeklyStreak() async {
    final now = DateTime.now();
    int streak = 0;
    
    // Start from current week and go backwards
    DateTime weekStart = now.subtract(Duration(days: now.weekday - 1));
    weekStart = DateTime(weekStart.year, weekStart.month, weekStart.day);
    
    while (true) {
      if (await meetsWeeklyGoal(weekStart)) {
        streak++;
        weekStart = weekStart.subtract(const Duration(days: 7));
      } else {
        break;
      }
    }
    
    return streak;
  }

  /// Get visits count for a specific month
  static Future<int> getMonthlyVisitCount(DateTime month) async {
    final visits = await getVisitDatesAsDateTime();
    return visits.where((date) {
      return date.year == month.year && date.month == month.month;
    }).length;
  }

  /// Helper: Convert DateTime to string (YYYY-MM-DD)
  static String _dateToString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Helper: Convert string to DateTime
  static DateTime _stringToDate(String dateString) {
    final parts = dateString.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  /// Get day of week visits for current week (MTWTFSS format)
  static Future<List<bool>> getCurrentWeekDayVisits() async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final visits = await getVisitDatesAsDateTime();
    
    final weekDays = List.generate(7, (index) {
      final day = weekStart.add(Duration(days: index));
      final normalizedDay = DateTime(day.year, day.month, day.day);
      return visits.any((visit) {
        final normalizedVisit = DateTime(visit.year, visit.month, visit.day);
        return normalizedVisit.year == normalizedDay.year &&
               normalizedVisit.month == normalizedDay.month &&
               normalizedVisit.day == normalizedDay.day;
      });
    });
    
    return weekDays;
  }
}

