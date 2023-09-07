import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Get current location of the user
  /// onFailed is called when a failure occurs
  static Future<Position> getCurrentLocation(
    Function(String, Future Function())? onFailed,
  ) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      onFailed?.call(
        'Location service is disabled, please enable to continue',
        Geolocator.openLocationSettings,
      );
      return Future.error('Location service is disabled');
    }

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      onFailed?.call(
        'Location permission is not granted, please grant to continue',
        Geolocator.requestPermission,
      );
      return Future.error('Location permissions are denied');
    }

    if (permission == LocationPermission.deniedForever) {
      onFailed?.call(
        'Location permission is permanently denied, we cannot request permissions, so please open settings and grant the permission.',
        Geolocator.openAppSettings,
      );
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
