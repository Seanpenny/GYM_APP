class MemberProfile {
  MemberProfile({
    required this.name,
    required this.membershipTier,
    required this.nextBillingDate,
    required this.visitStreak,
    required this.avatarUrl,
  });

  final String name;
  final String membershipTier;
  final DateTime nextBillingDate;
  final int visitStreak;
  final String avatarUrl;
}

class MockData {
  static final member = MemberProfile(
    name: 'Alex Morgan',
    membershipTier: 'Elite',
    nextBillingDate: DateTime.now().add(const Duration(days: 12)),
    visitStreak: 7,
    avatarUrl: 'assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg',
  );

  static final List<Map<String, dynamic>> upcomingClasses = [
    {
      'title': 'HIIT Power Hour',
      'trainer': 'Jordan Blake',
      'startTime': DateTime.now().add(const Duration(hours: 4)),
      'spotsLeft': 3,
      'intensity': 'High',
      'location': 'Studio A',
    },
    {
      'title': 'Vinyasa Flow',
      'trainer': 'Sierra Lee',
      'startTime': DateTime.now().add(const Duration(hours: 8)),
      'spotsLeft': 8,
      'intensity': 'Medium',
      'location': 'Zen Loft',
    },
  ];

  static final List<Map<String, dynamic>> personalTrainingSlots = [
    {
      'trainer': 'Marcus Reed',
      'specialty': 'Strength & Conditioning',
      'nextAvailability': DateTime.now().add(const Duration(days: 1, hours: 2)),
      'rating': 4.9,
    },
    {
      'trainer': 'Nia Patel',
      'specialty': 'Mobility & Recovery',
      'nextAvailability': DateTime.now().add(const Duration(days: 2, hours: 4)),
      'rating': 4.7,
    },
  ];

  static final List<Map<String, dynamic>> paymentHistory = [
    {
      'date': DateTime.now().subtract(const Duration(days: 18)),
      'amount': 89.00,
      'method': 'Visa **** 1342',
      'status': 'Completed',
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 48)),
      'amount': 89.00,
      'method': 'Visa **** 1342',
      'status': 'Completed',
    },
  ];

  static final List<Map<String, dynamic>> attendanceHistory = List.generate(8, (index) {
    final date = DateTime.now().subtract(Duration(days: index * 2));
    return {
      'date': date,
      'className': index % 2 == 0 ? 'Strength Lab' : 'Skillmill Sprint',
      'trainer': index % 2 == 0 ? 'Jordan Blake' : 'Nia Patel',
      'location': index % 3 == 0 ? 'Main Floor' : 'Studio B',
    };
  });

  static final List<Map<String, dynamic>> equipmentAvailability = [
    {
      'name': 'Skillmill Treadmills',
      'available': 3,
      'total': 8,
      'peakTime': '6:00 PM',
    },
    {
      'name': 'Squat Racks',
      'available': 1,
      'total': 5,
      'peakTime': '7:30 PM',
    },
    {
      'name': 'Cold Plunge Suite',
      'available': 2,
      'total': 4,
      'peakTime': '5:00 PM',
    },
  ];

  static final List<Map<String, String>> communityHighlights = [
    {
      'title': 'Member Spotlight: Taylor hits a new deadlift PR!',
      'description': '3x bodyweight lift with coach Marcus cheering on.',
      'image': 'assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg',
    },
    {
      'title': 'Sunrise Run Club conquers Table Mountain',
      'description': 'Twelve members completed the 12km ascent—next challenge incoming.',
      'image': 'assets/images/GEORGELOOTS GYM IMAGE FOR SPLASH.jpg',
    },
  ];

  static final List<Map<String, dynamic>> goals = [
    {
      'label': 'Weekly Sessions',
      'target': 4,
      'current': 3,
    },
    {
      'label': 'Strength Focus',
      'target': 5,
      'current': 4,
    },
    {
      'label': 'Recovery Minutes',
      'target': 120,
      'current': 75,
      'unit': 'min',
    },
  ];

  static final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Keep your streak alive',
      'body': 'One more check-in unlocks an Elite perk. We’ve got a mat ready for you.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
      'type': 'streak',
    },
    {
      'title': 'Limited spots for Boxing Lab',
      'body': 'Only 2 slots left with Coach Mia at 18:30 tonight. Book now.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 6)),
      'type': 'class',
    },
  ];

  static final List<Map<String, dynamic>> referralRewards = [
    {
      'label': 'Free PT Session',
      'progress': 2,
      'target': 3,
    },
    {
      'label': 'Guest Pass Bundle',
      'progress': 1,
      'target': 2,
    },
  ];
}



