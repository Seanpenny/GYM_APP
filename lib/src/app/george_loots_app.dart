import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_flow.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/dashboard/dashboard_shell.dart';
import '../screens/shared/membership_card_screen.dart';
import '../screens/shared/attendance_history_screen.dart';
import '../screens/shared/personal_training_screen.dart';
import '../screens/shared/equipment_availability_screen.dart';
import '../screens/shared/notifications_screen.dart';
import '../screens/shared/support_screen.dart';
import '../screens/shared/payments_screen.dart';
import '../screens/shared/referral_screen.dart';
import '../screens/shared/goal_insights_screen.dart';
import '../screens/shared/settings_screen.dart';
import '../screens/shared/progress_tracker_screen.dart';

class GeorgeLootsApp extends StatefulWidget {
  const GeorgeLootsApp({super.key});

  @override
  State<GeorgeLootsApp> createState() => _GeorgeLootsAppState();
}

class _GeorgeLootsAppState extends State<GeorgeLootsApp> {
  // Load theme asynchronously to prevent blocking
  late final Future<ThemeData> _themeFuture;

  @override
  void initState() {
    super.initState();
    // Load theme in background to prevent blocking main thread
    _themeFuture = Future<ThemeData>.microtask(() => buildAppTheme());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ThemeData>(
      future: _themeFuture,
      builder: (context, snapshot) {
        // Use system theme as fallback while loading
        final theme = snapshot.data ?? ThemeData.light();
        
        return MaterialApp(
          title: 'George Loots Gym',
          debugShowCheckedModeBanner: false,
          theme: theme,
          scrollBehavior: const _AppScrollBehavior(),
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);
            final clampedScaler = mediaQuery.textScaler.clamp(
              minScaleFactor: 0.95,
              maxScaleFactor: 1.15,
            );

            Widget content = MediaQuery(
              data: mediaQuery.copyWith(textScaler: clampedScaler),
              child: child ?? const SizedBox.shrink(),
            );

            if (kIsWeb) {
              content = LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth <= 700) {
                    return content;
                  }

                  return ColoredBox(
                    color: theme.scaffoldBackgroundColor,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: ClipRect(child: content),
                      ),
                    ),
                  );
                },
              );
            }

            return content;
          },
          initialRoute: '/splash',
          routes: {
            '/splash': (_) => const SplashScreen(),
            '/onboarding': (_) => const OnboardingFlow(),
            '/auth': (_) => const AuthScreen(),
            '/signup': (_) => const SignupScreen(),
            '/dashboard': (_) => const DashboardShell(),
            '/membership-card': (_) => const MembershipCardScreen(),
            '/attendance': (_) => const AttendanceHistoryScreen(),
            '/personal-training': (_) => const PersonalTrainingScreen(),
            '/equipment': (_) => const EquipmentAvailabilityScreen(),
            '/notifications': (_) => const NotificationsScreen(),
            '/support': (_) => const SupportScreen(),
            '/payments': (_) => const PaymentsScreen(),
            '/referrals': (_) => const ReferralScreen(),
            '/goal-insights': (_) => const GoalInsightsScreen(),
            '/settings': (_) => const SettingsScreen(),
            '/progress-tracker': (_) => const ProgressTrackerScreen(),
          },
          onUnknownRoute: (_) => MaterialPageRoute(builder: (_) => const DashboardShell()),
        );
      },
    );
  }
}

class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };
}
