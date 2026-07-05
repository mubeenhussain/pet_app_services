import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Google Maps configuration.
///
/// Pass at build time:
/// `flutter run --dart-define=GOOGLE_MAPS_API_KEY=your_key`
class MapsConfig {
  MapsConfig._();

  static const apiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');

  static bool get isConfigured => apiKey.isNotEmpty;

  /// Riyadh default (BRD: Saudi Arabia)
  static const defaultLocation = LatLng(24.7136, 46.6753);
}
