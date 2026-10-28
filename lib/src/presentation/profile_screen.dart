import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/providers.dart';
import '../core/theme.dart';
import '../domain/models/app_user.dart';
import 'home_shell.dart';
import 'widgets/common.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key, required this.user, required this.onPlay});
  final AppUser user;
  final VoidCallback onPlay;
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String _tab = 'Recently Played';
  final _recent = const [
    _History(
      'Meditation on Twin Hearts',
      'Master Choa Kok Sui',
      'Played 2h ago · 24 mins',
      Icons.self_improvement,
      [Color(0xFFB46DEC), Color(0xFF7644C0)],
    ),
    _History(
      'Om Namah Shivaya Chanting',
      'Sacred Resonance Mantra',
      'Yesterday · 18 mins',
      Icons.graphic_eq,
      [Color(0xFFFFA05D), Color(0xFFFFC74F)],
    ),
    _History(
      'Aura Cleansing Affirmation',
      'Chakra Balance Guidance',
      '3 days ago · 15 mins',
      Icons.star_outline,
      [Color(0xFF75BCD9), Color(0xFF657BE1)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(sessionProvider).value ?? widget.user;
    final items = _tab == 'Recently Played' ? _recent : const <_History>[];
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpace.page, 18, AppSpace.page, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'My Profile',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            IconButton(
              onPressed: () => openSettings(context),
              icon: const Icon(Icons.menu_rounded, color: AppColors.ink),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              height: 78,
              width: 78,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFE0D2), Color(0xFFDCC8F7)],
                ),
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: const [
                  BoxShadow(color: Color(0x1E7044D8), blurRadius: 15),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.person_rounded,
                  size: 42,
                  color: AppColors.violet,
                ),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.displayName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Pill('ARHATIC PRACTITIONER · LEVEL 1'),
                ],
              ),
            ),
            const SizedBox(width: 4),
            const Pill('India'),
          ],
        ),
        const SizedBox(height: 20),
        const Row(
          children: [
            _StatCard(
              Icons.access_time_rounded,
              '128',
              'Hours Meditated',
              Color(0xFF8E51D3),
            ),
            SizedBox(width: 9),
            _StatCard(
              Icons.water_drop_rounded,
              '45',
              'Day Streak',
              Color(0xFFE35D78),
            ),
            SizedBox(width: 9),
            _StatCard(
              Icons.favorite_rounded,
              '24',
              'Sacred Tracks',
              Color(0xFF6575E8),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Row(
            children: ['Recently Played', 'Favorites', 'Downloads']
                .map(
                  (tab) => Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _tab = tab),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                          vertical: 11,
                          horizontal: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _tab == tab
                              ? AppColors.lavender
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Text(
                          tab,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: _tab == tab
                                ? AppColors.violetDark
                                : AppColors.muted,
                            fontWeight: _tab == tab
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 17),
        Row(
          children: [
            const Expanded(
              child: Text(
                'RECENT MEDITATIONS',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .6,
                ),
              ),
            ),
            Pill('${items.length} Spiritual Sessions'),
          ],
        ),
        const SizedBox(height: 10),
        if (items.isEmpty)
          Container(
            padding: const EdgeInsets.all(22),
            decoration: softCard(),
            child: Column(
              children: [
                Icon(
                  _tab == 'Favorites'
                      ? Icons.favorite_border_rounded
                      : Icons.download_done_outlined,
                  color: AppColors.violet,
                  size: 30,
                ),
                const SizedBox(height: 8),
                Text(
                  _tab == 'Favorites'
                      ? 'No favorites saved'
                      : 'No downloads yet',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  _tab == 'Favorites'
                      ? 'Save a track or album to find it here.'
                      : 'Your offline meditations will appear here.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          )
        else
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _HistoryCard(item: item, onPlay: widget.onPlay),
            ),
          ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF5ECFA),
            borderRadius: BorderRadius.circular(17),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.auto_awesome, size: 16, color: AppColors.violet),
              SizedBox(width: 9),
              Expanded(
                child: Text(
                  '“When you do Meditation on Twin Hearts, divine energy flows into you, blessing the entire earth.”',
                  style: TextStyle(
                    color: AppColors.violetDark,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard(this.icon, this.value, this.label, this.color);
  final IconData icon;
  final String value, label;
  final Color color;
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 4),
      decoration: softCard(radius: 18),
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, fontSize: 9),
          ),
        ],
      ),
    ),
  );
}

class _History {
  const _History(this.title, this.subtitle, this.meta, this.icon, this.colors);
  final String title, subtitle, meta;
  final IconData icon;
  final List<Color> colors;
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.item, required this.onPlay});
  final _History item;
  final VoidCallback onPlay;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: softCard(radius: 19),
    child: Row(
      children: [
        Artwork(icon: item.icon, colors: item.colors, size: 46),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item.subtitle,
                style: const TextStyle(color: AppColors.muted, fontSize: 11),
              ),
              const SizedBox(height: 4),
              Text(
                item.meta,
                style: const TextStyle(color: AppColors.muted, fontSize: 10),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onPlay,
          icon: const Icon(
            Icons.play_circle_fill_rounded,
            size: 33,
            color: AppColors.violet,
          ),
        ),
      ],
    ),
  );
}
