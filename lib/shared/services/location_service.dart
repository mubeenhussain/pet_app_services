import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_app/core/config/maps_config.dart';

class LocationService {
  LocationService._();

  static Future<LatLng?> getCurrentLatLng() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    final position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }

  static Future<double> distanceKm(LatLng from, LatLng to) async {
    final meters = Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
    return meters / 1000;
  }

  static LatLng offsetDemo(LatLng base, {double kmEast = 3}) {
    return LatLng(base.latitude, base.longitude + (kmEast / 111));
  }

  static LatLng get defaultLocation => MapsConfig.defaultLocation;
}
