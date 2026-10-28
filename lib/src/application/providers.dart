import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/auth_repository.dart';
import '../domain/models/app_user.dart';
import '../core/firebase_status.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

final onboardingProvider = AsyncNotifierProvider<OnboardingController, bool>(
  OnboardingController.new,
);

class OnboardingController extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async =>
      (await SharedPreferences.getInstance()).getBool('onboarding_complete') ??
      false;

  Future<void> complete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    state = const AsyncData(true);
  }
}

final sessionProvider = AsyncNotifierProvider<SessionController, AppUser?>(
  SessionController.new,
);

class SessionController extends AsyncNotifier<AppUser?> {
  @override
  Future<AppUser?> build() async {
    if (!firebaseIsReady) {
      return ref.read(authRepositoryProvider).restoreDemoSession();
    }
    final repo = ref.read(authRepositoryProvider);
    final subscription = repo.userChanges.listen(
      (user) => state = AsyncData(user),
    );
    ref.onDispose(subscription.cancel);
    return repo.currentUser;
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password),
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .register(name: name, email: email, password: password),
    );
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncData(null);
  }

  Future<void> updateProfile(String name) async {
    final user = state.value;
    if (user == null) return;
    await ref.read(authRepositoryProvider).updateProfile(name: name);
    state = AsyncData(
      AppUser(uid: user.uid, email: user.email, displayName: name.trim()),
    );
  }
}
