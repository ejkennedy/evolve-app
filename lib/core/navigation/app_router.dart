import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/coach/presentation/screens/coach_chat_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/goals/presentation/screens/create_goal_screen.dart';
import '../../features/goals/presentation/screens/goal_detail_screen.dart';
import '../../features/goals/presentation/screens/goals_screen.dart';
import '../../features/habits/presentation/screens/create_habit_screen.dart';
import '../../features/habits/presentation/screens/habit_detail_screen.dart';
import '../../features/habits/presentation/screens/habits_screen.dart';
import '../../features/insights/presentation/screens/insights_screen.dart';
import '../../features/logging/presentation/screens/quick_log_sheet.dart';
import '../../features/onboarding/presentation/screens/onboarding_chat_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../shared/widgets/bottom_nav_bar.dart';
import '../constants/route_constants.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final onboardingComplete = ref.watch(onboardingCompleteProvider);

  return GoRouter(
    initialLocation: RouteConstants.splash,
    redirect: (context, state) {
      final isAuthenticated = authState.valueOrNull?.isAuthenticated ?? false;
      final isOnboarded =
          (authState.valueOrNull?.isOnboarded ?? false) || onboardingComplete;

      final onAuthScreens = state.matchedLocation == RouteConstants.login ||
          state.matchedLocation == RouteConstants.signup ||
          state.matchedLocation == RouteConstants.splash;

      if (!isAuthenticated && !onAuthScreens) return RouteConstants.login;
      if (isAuthenticated && !isOnboarded &&
          state.matchedLocation != RouteConstants.onboarding) {
        return RouteConstants.onboarding;
      }
      if (isAuthenticated && onAuthScreens &&
          state.matchedLocation != RouteConstants.splash) {
        return RouteConstants.dashboard;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RouteConstants.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteConstants.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteConstants.signup,
        builder: (_, __) => const SignupScreen(),
      ),
      GoRoute(
        path: RouteConstants.onboarding,
        builder: (_, __) => const OnboardingChatScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: RouteConstants.dashboard,
            builder: (_, __) => const DashboardScreen(),
          ),
          GoRoute(
            path: RouteConstants.goals,
            builder: (_, __) => const GoalsScreen(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (_, __) => const CreateGoalScreen(),
              ),
              GoRoute(
                path: ':goalId',
                builder: (_, state) =>
                    GoalDetailScreen(goalId: state.pathParameters['goalId']!),
              ),
            ],
          ),
          GoRoute(
            path: RouteConstants.habits,
            builder: (_, __) => const HabitsScreen(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (_, __) => const CreateHabitScreen(),
              ),
              GoRoute(
                path: ':habitId',
                builder: (_, state) => HabitDetailScreen(
                  habitId: state.pathParameters['habitId']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: RouteConstants.coach,
            builder: (_, __) => const CoachChatScreen(),
          ),
          GoRoute(
            path: RouteConstants.insights,
            builder: (_, __) => const InsightsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: RouteConstants.quickLog,
        pageBuilder: (context, state) => ModalBottomSheetPage(
          child: const QuickLogSheet(),
        ),
      ),
      GoRoute(
        path: RouteConstants.settings,
        builder: (_, __) => const SettingsScreen(),
      ),
    ],
  );
});

class ModalBottomSheetPage<T> extends Page<T> {
  final Widget child;
  const ModalBottomSheetPage({required this.child});

  @override
  Route<T> createRoute(BuildContext context) {
    return ModalBottomSheetRoute<T>(
      settings: this,
      isScrollControlled: true,
      builder: (_) => child,
    );
  }
}
