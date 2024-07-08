import 'package:location/location.dart';

class LocationService {
  static LocationData? currentLocation;

  static Future<void> init() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location services are enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Check for location permissions
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Get current location
    currentLocation = await location.getLocation();
  }

  static Future<void> getCurrentLocation() async {
    Location location = Location();
    currentLocation = await location.getLocation();
  }
}
