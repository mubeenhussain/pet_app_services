import 'package:flutter/material.dart';

/// Google "G" logo used on social auth buttons.
///
/// Centralizes the asset path so it lives in a single place.
class GoogleGlyph extends StatelessWidget {
  const GoogleGlyph({super.key, this.size = 20});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/google.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
