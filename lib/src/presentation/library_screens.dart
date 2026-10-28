import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'widgets/common.dart';

class MyAlbumsScreen extends StatefulWidget {
  const MyAlbumsScreen({super.key});
  @override
  State<MyAlbumsScreen> createState() => _MyAlbumsScreenState();
}

class _MyAlbumsScreenState extends State<MyAlbumsScreen> {
  String _filter = 'All Albums';
  String _query = '';
  final Set<String> _saved = {};
  static const _recommendations = [
    _Album(
      'Meditation on Twin Hearts',
      'Grand Master Choa Kok Sui',
      '2 Tracks · 28 Mins',
      'Illumination',
      Icons.favorite_outline,
      [Color(0xFFFFF3D9), Color(0xFFFFE7ED)],
    ),
    _Album(
      'Meditation on the Soul',
      'Achieving Oneness with Higher Soul',
      '3 Tracks · 45 Mins',
      'Chakra Energy',
      Icons.visibility_outlined,
      [Color(0xFFD9FBF3), Color(0xFFEAF5FF)],
    ),
    _Album(
      'Mantra OM',
      'Sacred Resonance',
      '4 Tracks · 32 Mins',
      'Mantra',
      Icons.graphic_eq,
      [Color(0xFFF4E8FF), Color(0xFFFFE8F2)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final results = _recommendations
        .where(
          (album) => '${album.title} ${album.teacher}'.toLowerCase().contains(
            _query.toLowerCase(),
          ),
        )
        .toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpace.page, 18, AppSpace.page, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'My Albums',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            IconButton(
              onPressed: () => setState(() {
                _saved.clear();
                _filter = 'All Albums';
              }),
              icon: const Icon(Icons.history_rounded, color: AppColors.violet),
            ),
          ],
        ),
        const SizedBox(height: 15),
        SearchField(
          hint: 'Search chants, mantras, sutras…',
          onChanged: (value) => setState(() => _query = value),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 39,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: ['All Albums', 'Downloaded', 'Favorites', 'Chants']
                .map(
                  (label) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(label),
                      selected: _filter == label,
                      showCheckmark: false,
                      selectedColor: AppColors.violet,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: _filter == label ? Colors.white : AppColors.ink,
                        fontSize: 12,
                      ),
                      onSelected: (_) => setState(() => _filter = label),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 19),
        Container(
          height: 242,
          decoration: BoxDecoration(
            gradient: const RadialGradient(
              colors: [Color(0xFFFFE3F0), Color(0xFFF1E4FF), AppColors.canvas],
              stops: [0, .48, 1],
            ),
            borderRadius: BorderRadius.circular(26),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD5B6F3), width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.violet.withValues(alpha: .14),
                      blurRadius: 24,
                      spreadRadius: 6,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.spa_rounded,
                  color: Color(0xFFD873BC),
                  size: 54,
                ),
              ),
              const SizedBox(height: 13),
              const Text(
                'Your sanctuary is empty',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 6),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'You haven’t added any meditation albums to your sacred library yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ),
              const SizedBox(height: 13),
              FilledButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Discover sessions from the recommendations below.',
                    ),
                  ),
                ),
                icon: const Icon(Icons.explore_outlined, size: 17),
                label: const Text('Explore discovery'),
                style: FilledButton.styleFrom(shape: const StadiumBorder()),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const SectionHeading(
          'Recommended for your practice',
          action: 'View all',
        ),
        Text(
          'Pranic healing foundational essentials',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 10),
        if (results.isEmpty)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'No albums found.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted),
            ),
          )
        else
          ...results.map(
            (album) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _AlbumRow(
                album: album,
                saved: _saved.contains(album.title),
                onSave: () => setState(() {
                  if (!_saved.add(album.title)) _saved.remove(album.title);
                }),
              ),
            ),
          ),
      ],
    );
  }
}

class _Album {
  const _Album(
    this.title,
    this.teacher,
    this.meta,
    this.category,
    this.icon,
    this.colors,
  );
  final String title, teacher, meta, category;
  final IconData icon;
  final List<Color> colors;
}

class _AlbumRow extends StatelessWidget {
  const _AlbumRow({
    required this.album,
    required this.saved,
    required this.onSave,
  });
  final _Album album;
  final bool saved;
  final VoidCallback onSave;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
    decoration: softCard(radius: 18),
    child: Row(
      children: [
        Artwork(icon: album.icon, colors: album.colors, size: 44),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                album.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                album.teacher,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, color: AppColors.muted),
              ),
              const SizedBox(height: 5),
              Text(
                '${album.meta}  ·  ${album.category}',
                style: const TextStyle(fontSize: 10, color: AppColors.violet),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onSave,
          icon: Icon(
            saved ? Icons.check_rounded : Icons.add_rounded,
            color: AppColors.violet,
          ),
          style: IconButton.styleFrom(backgroundColor: AppColors.lavender),
        ),
      ],
    ),
  );
}

class PlaylistsScreen extends StatefulWidget {
  const PlaylistsScreen({super.key});
  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  String _sort = 'Recent';
  final List<_Playlist> _playlists = [
    const _Playlist(
      'Morning Twin Hearts Routine',
      'Physical Exercises, Meditation & B',
      '42 mins',
      'TH-01',
      Icons.wb_sunny_outlined,
      [Color(0xFFFFE8BF), Color(0xFFFFDAE4)],
    ),
    const _Playlist(
      'Evening Aura Cleansing & Calm',
      '108 OM Chants with Tibetan Singing',
      '5 tracks · 1h 10m',
      'AURA',
      Icons.nightlight_round,
      [Color(0xFFEADFFF), Color(0xFFE3EEFF)],
    ),
    const _Playlist(
      'Arhatic Dhyan & Kundalini',
      'Spiritual Cord Affirmation & Blue Pearl',
      '4 tracks · 55 mins',
      'YOGA',
      Icons.spa_outlined,
      [Color(0xFFFFE4D9), Color(0xFFF6DFFF)],
    ),
  ];

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(AppSpace.page, 20, AppSpace.page, 24),
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              'Playlists',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Search playlists from the list below.'),
              ),
            ),
            icon: const Icon(Icons.search_rounded, color: AppColors.violet),
          ),
        ],
      ),
      const SizedBox(height: 15),
      SizedBox(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: ['Recent', 'Created', 'Most Played', 'Sacred OM']
              .map(
                (label) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(label),
                    selected: _sort == label,
                    showCheckmark: false,
                    selectedColor: AppColors.ink,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: _sort == label ? Colors.white : AppColors.ink,
                      fontSize: 12,
                    ),
                    onSelected: (_) => setState(() => _sort = label),
                  ),
                ),
              )
              .toList(),
        ),
      ),
      const SizedBox(height: 16),
      InkWell(
        onTap: () => _createPlaylist(),
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF3F9), Color(0xFFEFE5FF)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.add_rounded, color: AppColors.violet),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create sacred playlist',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Curate your daily sadhana, Twin Hearts or meditation sessions.',
                      style: TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.auto_awesome,
                size: 19,
                color: Color(0xFFC67AE2),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 15),
      ..._playlists.map(
        (playlist) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _PlaylistCard(
            playlist: playlist,
            onDelete: () => setState(() => _playlists.remove(playlist)),
            onPlay: () => ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Playing ${playlist.name}'))),
          ),
        ),
      ),
    ],
  );

  Future<void> _createPlaylist() async {
    final controller = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New playlist'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Playlist name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (title == null || title.isEmpty) return;
    setState(
      () => _playlists.insert(
        0,
        _Playlist(
          title,
          'Your personal sacred collection',
          '0 tracks',
          'NEW',
          Icons.queue_music,
          [const Color(0xFFDDEAFF), AppColors.lavender],
        ),
      ),
    );
  }
}

class _Playlist {
  const _Playlist(
    this.name,
    this.subtitle,
    this.meta,
    this.badge,
    this.icon,
    this.colors,
  );
  final String name, subtitle, meta, badge;
  final IconData icon;
  final List<Color> colors;
}

class _PlaylistCard extends StatelessWidget {
  const _PlaylistCard({
    required this.playlist,
    required this.onPlay,
    required this.onDelete,
  });
  final _Playlist playlist;
  final VoidCallback onPlay;
  final VoidCallback onDelete;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: softCard(radius: 20),
    child: Row(
      children: [
        Artwork(
          icon: playlist.icon,
          colors: playlist.colors,
          size: 55,
          label: playlist.badge,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Pill(playlist.meta.split(' ').first),
                  const SizedBox(width: 6),
                  Text(
                    '• ${playlist.meta}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                playlist.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                playlist.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.muted, fontSize: 11),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onPlay,
          icon: const Icon(
            Icons.play_circle_fill_rounded,
            color: AppColors.violet,
            size: 30,
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') onDelete();
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'delete', child: Text('Remove playlist')),
          ],
        ),
      ],
    ),
  );
}
