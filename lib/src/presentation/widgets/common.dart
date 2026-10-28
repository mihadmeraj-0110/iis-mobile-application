import 'package:flutter/material.dart';

import '../../core/theme.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.busy = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool busy;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 54,
    width: double.infinity,
    child: FilledButton.icon(
      onPressed: busy ? null : onPressed,
      icon: busy
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Icon(icon ?? Icons.arrow_forward_rounded, size: 19),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.violet,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
        elevation: 2,
        shadowColor: AppColors.violet.withValues(alpha: .28),
      ),
    ),
  );
}

class SectionHeading extends StatelessWidget {
  const SectionHeading(this.title, {super.key, this.action, this.onAction});
  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(title, style: Theme.of(context).textTheme.titleMedium),
      ),
      if (action != null)
        TextButton(
          onPressed: onAction,
          child: Text(
            action!,
            style: const TextStyle(
              color: AppColors.violet,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
    ],
  );
}

class Artwork extends StatelessWidget {
  const Artwork({
    super.key,
    required this.icon,
    required this.colors,
    this.size = 66,
    this.label,
  });
  final IconData icon;
  final List<Color> colors;
  final double size;
  final String? label;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(size * .28),
      boxShadow: const [
        BoxShadow(
          color: Color(0x1C7145D9),
          blurRadius: 12,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Center(
      child: label == null
          ? Icon(icon, size: size * .42, color: Colors.white)
          : Text(
              label!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: size * .16,
              ),
            ),
    ),
  );
}

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    this.hint = 'Search mantras, Twin Hearts, affirmations…',
    this.onChanged,
  });
  final String hint;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) => TextField(
    onChanged: onChanged,
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.violet),
      hintText: hint,
      suffixIcon: const Icon(Icons.tune_rounded, color: AppColors.muted),
    ),
  );
}

class Pill extends StatelessWidget {
  const Pill(this.label, {super.key, this.color = AppColors.lavender});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        color: AppColors.violetDark,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
