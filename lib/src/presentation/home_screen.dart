import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../domain/models/app_user.dart';
import 'home_shell.dart';
import 'widgets/common.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.user,
    required this.onOpenLibrary,
    required this.onPlay,
  });
  final AppUser user;
  final VoidCallback onOpenLibrary;
  final VoidCallback onPlay;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = '';
  final _items = const [
    _Meditation(
      'Meditation on Twin Hearts',
      'Master Choa Kok Sui',
      '24 min',
      Icons.public,
      [Color(0xFF2786E9), Color(0xFF5E67E9)],
      'Twin Hearts',
    ),
    _Meditation(
      'Peace & Illumination',
      'Guided meditation',
      '18 min',
      Icons.spa,
      [Color(0xFF61D3EF), Color(0xFF2683CC)],
      'शांति एवं प्रकाश',
    ),
    _Meditation(
      'Om: The Sound of Stillness',
      'Universal Mantra',
      '32 min',
      Icons.self_improvement,
      [Color(0xFFB36BE8), Color(0xFF60359D)],
      'ॐ',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _items
        .where(
          (item) => '${item.title} ${item.teacher}'.toLowerCase().contains(
            _query.toLowerCase(),
          ),
        )
        .toList();
    final firstName = widget.user.displayName.split(' ').first;
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpace.page, 14, AppSpace.page, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Happy Friday',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(fontSize: 25),
                  ),
                  Text(
                    'Harmonize your heart and mind today, $firstName.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => openSettings(context),
              icon: const Icon(Icons.settings_outlined, color: AppColors.ink),
            ),
          ],
        ),
        const SizedBox(height: 17),
        SearchField(onChanged: (value) => setState(() => _query = value)),
        const SizedBox(height: 19),
        Container(
          padding: const EdgeInsets.all(19),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF191834), Color(0xFF522773)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.violet.withValues(alpha: .18),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome, color: AppColors.gold, size: 16),
                  SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      'DAILY ARHATIC WISDOM',
                      style: TextStyle(
                        color: Color(0xFFF1E3FF),
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Pill('Sutra 108', color: Color(0x33FFFFFF)),
                ],
              ),
              SizedBox(height: 13),
              Text(
                '“Arhatic Yoga consists of yogic techniques designed to help us develop spiritually. It is prehysteric in origin.”',
                style: TextStyle(
                  color: Colors.white,
                  height: 1.55,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 14),
              Divider(color: Color(0x35FFFFFF), height: 1),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '— Master Choa Kok Sui',
                      style: TextStyle(color: AppColors.gold, fontSize: 12),
                    ),
                  ),
                  Text(
                    'Deep Contemplation  ↗',
                    style: TextStyle(color: Color(0xFFD8C7E9), fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpace.section),
        const SectionHeading('Featured album', action: 'View liner notes'),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: softCard(),
          child: Row(
            children: [
              const Artwork(
                icon: Icons.graphic_eq_rounded,
                colors: [Color(0xFF77278F), Color(0xFF37185C)],
                size: 92,
                label: 'OM\nSOUND OF\nSTILLNESS',
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Audio · 108 Repetitions',
                      style: TextStyle(
                        color: AppColors.violet,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Mantra OM: The Sound of Stillness',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Master Choa Kok Sui',
                      style: TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '32:45',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: widget.onPlay,
                          icon: const Icon(Icons.play_arrow, size: 16),
                          label: const Text('Play now'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 11),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpace.section),
        SectionHeading(
          'Popular meditations',
          action: 'See all',
          onAction: widget.onOpenLibrary,
        ),
        Text(
          'Most played global collective sessions',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 11),
        if (filtered.isEmpty)
          const _EmptySearch()
        else
          SizedBox(
            height: 188,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) =>
                  _MeditationCard(item: filtered[index], onPlay: widget.onPlay),
            ),
          ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.lavender.withValues(alpha: .65),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Text(
            '“When you do Meditation on Twin Hearts, divine energy flows into you, blessing the entire earth.”',
            style: TextStyle(
              color: AppColors.violetDark,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}

class _Meditation {
  const _Meditation(
    this.title,
    this.teacher,
    this.duration,
    this.icon,
    this.colors,
    this.artLabel,
  );
  final String title, teacher, duration, artLabel;
  final IconData icon;
  final List<Color> colors;
}

class _MeditationCard extends StatelessWidget {
  const _MeditationCard({required this.item, required this.onPlay});
  final _Meditation item;
  final VoidCallback onPlay;
  @override
  Widget build(BuildContext context) => Container(
    width: 148,
    padding: const EdgeInsets.all(10),
    decoration: softCard(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Artwork(
          icon: item.icon,
          colors: item.colors,
          size: 126,
          label: item.artLabel,
        ),
        const SizedBox(height: 8),
        Text(
          item.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
        Text(
          item.teacher,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 10, color: AppColors.muted),
        ),
        const Spacer(),
        Row(
          children: [
            Pill(item.duration),
            const Spacer(),
            InkWell(
              onTap: onPlay,
              child: const CircleAvatar(
                radius: 13,
                backgroundColor: AppColors.ink,
                child: Icon(Icons.play_arrow, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _EmptySearch extends StatelessWidget {
  const _EmptySearch();
  @override
  Widget build(BuildContext context) => Container(
    height: 130,
    decoration: softCard(),
    child: const Center(
      child: Text(
        'No meditations match your search.',
        style: TextStyle(color: AppColors.muted),
      ),
    ),
  );
}
