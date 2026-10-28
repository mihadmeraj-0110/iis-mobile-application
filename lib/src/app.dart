import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'application/providers.dart';
import 'core/theme.dart';
import 'presentation/auth_screen.dart';
import 'presentation/home_shell.dart';
import 'presentation/onboarding_screen.dart';

class IISApp extends StatelessWidget {
  const IISApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Sanctuary · Sacred Sounds',
    debugShowCheckedModeBanner: false,
    theme: buildAppTheme(),
    home: const AppGate(),
  );
}

class AppGate extends ConsumerWidget {
  const AppGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarding = ref.watch(onboardingProvider);
    if (onboarding.isLoading) return const _LoadingScreen();
    if (onboarding.hasError) return const OnboardingScreen();
    if (onboarding.value != true) return const OnboardingScreen();
    final session = ref.watch(sessionProvider);
    return session.when(
      loading: () => const _LoadingScreen(),
      error: (error, _) => const AuthScreen(
        message: 'We could not restore your session. Please sign in again.',
      ),
      data: (user) => user == null ? const AuthScreen() : const HomeShell(),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(child: CircularProgressIndicator(color: AppColors.violet)),
  );
}
