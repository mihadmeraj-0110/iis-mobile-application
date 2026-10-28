import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../application/providers.dart';
import '../core/theme.dart';
import '../domain/models/app_user.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _reminders = true;
  String _language = 'English';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _reminders = prefs.getBool('daily_reminders') ?? true;
      _language = prefs.getString('language') ?? 'English';
    });
  }

  @override
  Widget build(BuildContext context) {
    final user =
        ref.watch(sessionProvider).value ??
        const AppUser(uid: '', email: '', displayName: 'Meditation seeker');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings & Practice',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: false,
        backgroundColor: AppColors.canvas,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpace.page, 0, AppSpace.page, 27),
        children: [
          const Text(
            'PRANIC HEALING SANCTUARY',
            style: TextStyle(
              color: AppColors.violet,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: softCard(radius: 19),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.lavender,
                  child: Icon(
                    Icons.person_rounded,
                    color: AppColors.violet,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        user.email,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => _editProfile(user),
                  child: const Text('Edit  ›'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 21),
          _SettingsGroup(
            children: [
              _SettingsRow(
                Icons.volume_up_outlined,
                'Audio Quality & Binaural Beats',
                'Hi-Res Lossless · 432 Hz',
                onTap: () => _chooseAudio(),
              ),
              _SettingsRow(
                Icons.download_outlined,
                'Offline Sanctuary & Downloads',
                '6 guided meditations available',
                onTap: () => _showInfo(
                  'Offline Sanctuary',
                  'Saved meditations are managed from My Profile → Downloads.',
                ),
              ),
              _SettingsRow(
                Icons.notifications_none_rounded,
                'Daily Sadhana Reminders',
                'Twin Hearts · 6:30 AM daily',
                trailing: Switch.adaptive(
                  value: _reminders,
                  onChanged: (value) async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('daily_reminders', value);
                    setState(() => _reminders = value);
                  },
                ),
                onTap: () async {
                  final value = !_reminders;
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('daily_reminders', value);
                  setState(() => _reminders = value);
                },
              ),
            ],
          ),
          const SizedBox(height: 17),
          _SettingsGroup(
            children: [
              _SettingsRow(
                Icons.favorite_border_rounded,
                'Wishlist & Sacred Bookmarks',
                '12 saved',
                onTap: () => _showInfo(
                  'Sacred Bookmarks',
                  'Your saved tracks and albums will appear in My Albums.',
                ),
              ),
              _SettingsRow(
                Icons.translate_rounded,
                'Language / भाषा',
                _language,
                onTap: () => _chooseLanguage(),
              ),
              _SettingsRow(
                Icons.lock_outline_rounded,
                'Security & Password',
                'Manage your sign-in details',
                onTap: () => _showInfo(
                  'Security & Password',
                  'Password reset can be requested from the sign-in screen.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          _SettingsGroup(
            children: [
              _SettingsRow(
                Icons.menu_book_outlined,
                'About Master Choa Kok Sui & Teachings',
                null,
                onTap: () => _showInfo(
                  'About the teachings',
                  'Explore pranic healing, meditation and Arhatic Yoga teachings in your daily practice.',
                ),
              ),
              _SettingsRow(
                Icons.language_rounded,
                'Global Meditation Centers',
                null,
                onTap: () => _showInfo(
                  'Global Meditation Centers',
                  'Connect with a meditation community in your region.',
                ),
              ),
              _SettingsRow(
                Icons.policy_outlined,
                'Terms & Privacy Policy',
                null,
                onTap: () => _showInfo(
                  'Terms & Privacy',
                  'Review the terms and privacy information for your account.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Container(
            decoration: softCard(radius: 17),
            child: ListTile(
              leading: const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFFCF4054),
              ),
              title: const Text(
                'Delete Account & Data',
                style: TextStyle(
                  color: Color(0xFFCF4054),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFCF4054),
              ),
              onTap: _confirmDelete,
            ),
          ),
          const SizedBox(height: 17),
          Container(
            decoration: softCard(radius: 18),
            child: ListTile(
              leading: const Icon(
                Icons.logout_rounded,
                color: AppColors.violet,
              ),
              title: const Text(
                'LOG OUT',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
              ),
              trailing: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'End Session',
                    style: TextStyle(color: AppColors.muted, fontSize: 11),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, color: AppColors.muted),
                ],
              ),
              onTap: () async {
                await ref.read(sessionProvider.notifier).signOut();
                if (context.mounted) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Sacred Practice Sounds  ·  version 1.0.0',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Future<void> _editProfile(AppUser user) async {
    final controller = TextEditingController(text: user.displayName);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit profile'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Display name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty) return;
    await ref.read(sessionProvider.notifier).updateProfile(name);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile updated.')));
    }
  }

  Future<void> _chooseAudio() async {
    const options = [
      'Standard · 44.1 kHz',
      'Hi-Res Lossless · 96 kHz',
      'Binaural · 432 Hz',
    ];
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text(
                'Audio quality',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            ...options.map(
              (option) => ListTile(
                leading: const Icon(
                  Icons.graphic_eq_rounded,
                  color: AppColors.violet,
                ),
                title: Text(option),
                onTap: () => Navigator.pop(context, option),
              ),
            ),
          ],
        ),
      ),
    );
    if (selected != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Audio preference set to $selected.')),
      );
    }
  }

  Future<void> _chooseLanguage() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text(
                'Choose language',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            ...['English', 'हिन्दी'].map(
              (language) => ListTile(
                title: Text(language),
                trailing: language == _language
                    ? const Icon(Icons.check, color: AppColors.violet)
                    : null,
                onTap: () => Navigator.pop(context, language),
              ),
            ),
          ],
        ),
      ),
    );
    if (selected == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', selected);
    if (mounted) setState(() => _language = selected);
  }

  Future<void> _showInfo(String title, String body) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete account and data?'),
        content: const Text(
          'This will remove the account and its profile data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFCF4054),
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'For account safety, request account deletion through support.',
          ),
        ),
      );
    }
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Container(
    decoration: softCard(radius: 19),
    child: Column(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          children[i],
          if (i < children.length - 1)
            const Divider(
              height: 1,
              indent: 51,
              endIndent: 12,
              color: Color(0xFFF1EEF5),
            ),
        ],
      ],
    ),
  );
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow(
    this.icon,
    this.title,
    this.subtitle, {
    required this.onTap,
    this.trailing,
  });
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    leading: Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: AppColors.lavender,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Icon(icon, color: AppColors.violet, size: 18),
    ),
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
    ),
    subtitle: subtitle == null
        ? null
        : Text(
            subtitle!,
            style: const TextStyle(color: AppColors.muted, fontSize: 10),
          ),
    trailing:
        trailing ??
        const Icon(
          Icons.chevron_right_rounded,
          size: 20,
          color: AppColors.muted,
        ),
    onTap: onTap,
  );
}
