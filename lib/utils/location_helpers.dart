import 'package:geolocator/geolocator.dart';

class LocationHelper {
  // Konstanta radius sesuai brief HashMicro
  static const double maxRadiusInMeters = 50.0;

  /// Menghitung jarak antara posisi user dan titik absensi
  static double calculateDistance(
    double startLat, 
    double startLng, 
    double endLat, 
    double endLng
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  /// Verifikasi apakah user berada dalam radius yang diizinkan
  static bool isWithinRadius(double distance) {
    return distance <= maxRadiusInMeters;
  }

  /// Format jarak agar lebih mudah dibaca di UI (misal: "45.2 m")
  static String formatDistance(double distance) {
    if (distance >= 1000) {
      return "${(distance / 1000).toStringAsFixed(2)} km";
    }
    return "${distance.toStringAsFixed(1)} m";
  }
}