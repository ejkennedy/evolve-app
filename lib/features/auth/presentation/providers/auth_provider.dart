import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/providers.dart';
import '../../../auth/data/models/app_user.dart';

class AuthStatus {
  final bool isAuthenticated;
  final bool isOnboarded;
  final AppUser? user;

  const AuthStatus({
    required this.isAuthenticated,
    required this.isOnboarded,
    this.user,
  });
}

final authStateProvider = StreamProvider<AuthStatus>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final userBox = ref.watch(userBoxProvider);

  return supabase.auth.onAuthStateChange.map((event) {
    final supaUser = event.session?.user;
    if (supaUser == null) {
      return const AuthStatus(isAuthenticated: false, isOnboarded: false);
    }
    final appUser = userBox.get(supaUser.id);
    return AuthStatus(
      isAuthenticated: true,
      isOnboarded: appUser?.onboardingComplete ?? false,
      user: appUser,
    );
  });
});

final currentUserProvider = Provider<AppUser?>((ref) {
  return ref.watch(authStateProvider).valueOrNull?.user;
});

final supabaseClientProvider2 = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final SupabaseClient _supabase;
  final HiveJsonBox<AppUser> _userBox;

  AuthNotifier(this._supabase, this._userBox) : super(const AsyncData(null));

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    });
  }

  Future<void> signUp(String email, String password, String name) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final res = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': name},
      );
      // Persist a local user record immediately on sign-up
      if (res.user != null) {
        final user = AppUser(
          id: res.user!.id,
          email: email,
          displayName: name,
          createdAt: DateTime.now(),
        );
        await _userBox.put(user.id, user.toJson());
      }
    });
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  /// Save the completed AppUser after onboarding
  Future<void> saveUser(AppUser user) async {
    await _userBox.put(user.id, user.toJson());
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  return AuthNotifier(
    ref.watch(supabaseClientProvider),
    ref.watch(userBoxProvider),
  );
});
