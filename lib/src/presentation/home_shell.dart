import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/providers.dart';
import '../core/theme.dart';
import '../domain/models/app_user.dart';
import 'home_screen.dart';
import 'library_screens.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});
  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;
  bool _playing = false;

  @override
  Widget build(BuildContext context) {
    final user =
        ref.watch(sessionProvider).value ??
        const AppUser(uid: '', email: '', displayName: 'Meditation seeker');
    final screens = [
      HomeScreen(
        user: user,
        onOpenLibrary: () => setState(() => _index = 1),
        onPlay: () => setState(() => _playing = !_playing),
      ),
      const MyAlbumsScreen(),
      const PlaylistsScreen(),
      ProfileScreen(
        user: user,
        onPlay: () => setState(() => _playing = !_playing),
      ),
    ];
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(index: _index, children: screens),
            ),
            if (_playing)
              _MiniPlayer(onPause: () => setState(() => _playing = false)),
            NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (value) => setState(() => _index = value),
              backgroundColor: Colors.white,
              indicatorColor: AppColors.lavender,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.album_outlined),
                  selectedIcon: Icon(Icons.album_rounded),
                  label: 'My Albums',
                ),
                NavigationDestination(
                  icon: Icon(Icons.queue_music_outlined),
                  selectedIcon: Icon(Icons.queue_music_rounded),
                  label: 'Playlists',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniPlayer extends StatelessWidget {
  const _MiniPlayer({required this.onPause});
  final VoidCallback onPause;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(15, 7, 15, 7),
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
    decoration: BoxDecoration(
      color: AppColors.violetDark,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        const Icon(Icons.graphic_eq_rounded, color: Colors.white),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Meditation on Twin Hearts',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              Text(
                'Master Choa Kok Sui · 24 min',
                style: TextStyle(color: Color(0xFFD7C7F7), fontSize: 10),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onPause,
          icon: const Icon(
            Icons.pause_circle_filled_rounded,
            color: Colors.white,
            size: 29,
          ),
        ),
      ],
    ),
  );
}

Future<void> openSettings(BuildContext context) => Navigator.of(
  context,
).push(MaterialPageRoute<void>(builder: (_) => const SettingsScreen()));
