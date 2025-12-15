import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/welcome_screen.dart';
import '../../features/onboarding/presentation/onboarding_profile_screen.dart';
import '../../features/solver/presentation/solver_screen.dart';
import '../../features/dashboard/presentation/home_screen.dart';
import '../../features/lesson/presentation/lesson_engine_screen.dart';
import '../../features/dashboard/presentation/dashboard_shell.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/leaderboard/presentation/leaderboard_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../core/services/supabase_service.dart';
import '../../features/social/presentation/link_agents_screen.dart';
import 'dart:async';

final appRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: GoRouterRefreshStream(SupabaseService().client.auth.onAuthStateChange),
  redirect: (context, state) {
    final session = SupabaseService().currentUser;
    final isLoggingIn = state.uri.path == '/login' || state.uri.path == '/';
    
    if (session != null && isLoggingIn) {
      return '/home';
    }
    
    // Optional: Protect other routes
    if (session == null && !isLoggingIn) return '/';
    
    return null; 
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => DashboardShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
           path: '/profile',
           builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
           path: '/rank',
           builder: (context, state) => const LeaderboardScreen(),
        ),
        GoRoute(
           path: '/social',
           builder: (context, state) => const LinkAgentsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingProfileScreen(),
    ),
    GoRoute(
      path: '/lesson',
      builder: (context, state) {
         final topic = state.uri.queryParameters['topic'];
         final level = state.uri.queryParameters['level'];
         final questId = state.uri.queryParameters['questId'] ?? 'unknown';
         return LessonEngineScreen(topic: topic, level: level, questId: questId);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/solver',
      builder: (context, state) => const SolverScreen(),
    ),
  ],
);

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
