import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String qrCodeKey = 'qr_code';
  static const String memberIdKey = 'member_id';
  static const String usernameKey = 'username';
  static const String emailKey = 'email';
  static const String firstNameKey = 'first_name';
  static const String lastNameKey = 'last_name';
  static const String attendanceKey = 'gym_attendance_dates';

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final memberId = prefs.getInt(memberIdKey);
    final username = prefs.getString(usernameKey);
    return memberId != null && memberId > 0 && username != null && username.isNotEmpty;
  }

  static Future<void> saveSession({
    required int memberId,
    required String username,
    String? email,
    String? firstName,
    String? lastName,
    String? qrCode,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(memberIdKey, memberId);
    await prefs.setString(usernameKey, username);

    if (email != null && email.isNotEmpty) {
      await prefs.setString(emailKey, email);
    }
    if (firstName != null && firstName.isNotEmpty) {
      await prefs.setString(firstNameKey, firstName);
    }
    if (lastName != null && lastName.isNotEmpty) {
      await prefs.setString(lastNameKey, lastName);
    }
    if (qrCode != null && qrCode.isNotEmpty) {
      await prefs.setString(qrCodeKey, qrCode);
    }
  }

  static Future<Map<String, dynamic>> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'memberId': prefs.getInt(memberIdKey) ?? 0,
      'username': prefs.getString(usernameKey) ?? '',
      'email': prefs.getString(emailKey) ?? '',
      'firstName': prefs.getString(firstNameKey) ?? '',
      'lastName': prefs.getString(lastNameKey) ?? '',
      'qrCode': prefs.getString(qrCodeKey) ?? '',
    };
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(qrCodeKey);
    await prefs.remove(memberIdKey);
    await prefs.remove(usernameKey);
    await prefs.remove(emailKey);
    await prefs.remove(firstNameKey);
    await prefs.remove(lastNameKey);
    await prefs.remove(attendanceKey);
  }
}
