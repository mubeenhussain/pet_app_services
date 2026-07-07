import 'package:flutter/material.dart';
import 'package:pet_app/core/extensions/context_extensions.dart';

/// App logo: a rounded, gradient brand tile with a centered glyph.
///
/// Reused on auth screens and anywhere the brand mark is needed.
class AppBrandMark extends StatelessWidget {
  const AppBrandMark({
    super.key,
    this.size = 72,
    this.icon = Icons.pets,
  });

  final double size;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primary, context.colors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.30),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(icon, color: scheme.onPrimary, size: size * 0.5),
    );
  }
}
