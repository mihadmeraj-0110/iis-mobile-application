import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/providers.dart';
import '../core/theme.dart';
import 'widgets/common.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _page = 0;

  static const _slides = [
    _Slide(
      Icons.self_improvement_rounded,
      'A little stillness\nchanges everything',
      'Make space for peace with guided meditation, sacred sound and daily practice.',
    ),
    _Slide(
      Icons.spa_rounded,
      'Find your sacred\nrhythm',
      'Explore Twin Hearts meditations, mantras and playlists for every moment.',
    ),
    _Slide(
      Icons.favorite_rounded,
      'Your sanctuary,\nwherever you are',
      'Build a practice that feels like yours. Begin gently, and return whenever you need.',
    ),
  ];

  Future<void> _finish() async =>
      ref.read(onboardingProvider.notifier).complete();

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_page];
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(26, 12, 26, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _finish,
                  child: const Text('Skip'),
                ),
              ),
              const Spacer(),
              Center(
                child: Container(
                  height: 228,
                  width: 228,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.lavender,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.violet.withValues(alpha: .16),
                        blurRadius: 45,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      height: 160,
                      width: 160,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        slide.icon,
                        size: 76,
                        color: AppColors.violet,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 52),
              Text(
                slide.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 15),
              Text(
                slide.subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 7,
                    width: _page == index ? 25 : 7,
                    decoration: BoxDecoration(
                      color: _page == index
                          ? AppColors.violet
                          : const Color(0xFFD8D0E8),
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              PrimaryButton(
                label: _page == 2 ? 'Enter your sanctuary' : 'Continue',
                onPressed: () {
                  if (_page == 2) {
                    _finish();
                  } else {
                    setState(() => _page++);
                  }
                },
              ),
              const SizedBox(height: 12),
              Text(
                'A calmer moment begins here',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Slide {
  const _Slide(this.icon, this.title, this.subtitle);
  final IconData icon;
  final String title;
  final String subtitle;
}
