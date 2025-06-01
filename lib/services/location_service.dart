// lib/services/location_service.dart - Enhanced with real-time tracking
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  // Stream controller for real-time tracking
  StreamController<Position>? _positionStreamController;
  StreamSubscription<Position>? _positionStreamSubscription;

  // Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Enhanced permission request with permission_handler fallback
  Future<LocationPermission> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      // If still denied, try permission_handler as fallback
      if (permission == LocationPermission.denied) {
        final status = await Permission.location.request();
        if (status.isGranted) {
          permission = LocationPermission.whileInUse;
        }
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationServiceException(
          'Location permissions are permanently denied. Please enable them in settings.'
      );
    }

    return permission;
  }

  // Get current position with retry mechanism
  Future<Position> getCurrentPosition({int retryCount = 3}) async {
    bool serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceException(
          'Location services are disabled. Please enable location services.'
      );
    }

    LocationPermission permission = await requestLocationPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw LocationServiceException(
          'Location permission denied. Cannot access current location.'
      );
    }

    // Retry mechanism for better reliability
    for (int i = 0; i < retryCount; i++) {
      try {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10 + (i * 5)), // Increase timeout with retries
        );
      } catch (e) {
        if (i == retryCount - 1) rethrow; // Last attempt, rethrow error
        await Future.delayed(Duration(seconds: 2)); // Wait before retry
      }
    }

    throw LocationServiceException('Failed to get location after $retryCount attempts');
  }

  // Enhanced address conversion with Google Geocoding API fallback
  Future<String> getAddressFromCoordinates(double latitude, double longitude, {bool useGoogleAPI = false}) async {
    try {
      // First, try the built-in geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = _buildAddressFromPlacemark(place);

        // If we got a good address, return it
        if (address.isNotEmpty && !address.contains('null') && address.length > 10) {
          return address;
        }
      }

      // If built-in geocoding fails and Google API is enabled, try Google Geocoding API
      if (useGoogleAPI) {
        String? googleAddress = await _getAddressFromGoogleAPI(latitude, longitude);
        if (googleAddress != null) {
          return googleAddress;
        }
      }

      // FALLBACK: Return formatted coordinates with area guess
      return _formatCoordinatesAsAddress(latitude, longitude);

    } catch (e) {
      // If Google API enabled, try it as fallback
      if (useGoogleAPI) {
        try {
          String? googleAddress = await _getAddressFromGoogleAPI(latitude, longitude);
          if (googleAddress != null) {
            return googleAddress;
          }
        } catch (googleError) {
          // Google API also failed, use coordinate fallback
        }
      }

      // FINAL FALLBACK: Return coordinates
      return _formatCoordinatesAsAddress(latitude, longitude);
    }
  }

  // Build address from placemark
  String _buildAddressFromPlacemark(Placemark place) {
    List<String> addressParts = [];

    if (place.street?.isNotEmpty == true && place.street != 'null') {
      addressParts.add(place.street!);
    }
    if (place.subLocality?.isNotEmpty == true && place.subLocality != 'null') {
      addressParts.add(place.subLocality!);
    }
    if (place.locality?.isNotEmpty == true && place.locality != 'null') {
      addressParts.add(place.locality!);
    }
    if (place.subAdministrativeArea?.isNotEmpty == true && place.subAdministrativeArea != 'null') {
      addressParts.add(place.subAdministrativeArea!);
    }
    if (place.administrativeArea?.isNotEmpty == true && place.administrativeArea != 'null') {
      addressParts.add(place.administrativeArea!);
    }
    if (place.postalCode?.isNotEmpty == true && place.postalCode != 'null') {
      addressParts.add(place.postalCode!);
    }
    if (place.country?.isNotEmpty == true && place.country != 'null') {
      addressParts.add(place.country!);
    }

    return addressParts.join(', ');
  }

  // Google Geocoding API fallback (requires API key in AndroidManifest.xml)
  Future<String?> _getAddressFromGoogleAPI(double latitude, double longitude) async {
    try {
      // You can get the API key from AndroidManifest.xml or environment
      // For now, we'll skip this implementation as it requires additional setup
      // To enable this, you would need to:
      // 1. Extract API key from AndroidManifest.xml
      // 2. Make HTTP request to Google Geocoding API
      // 3. Parse the JSON response

      // final String apiKey = 'YOUR_API_KEY_HERE';
      // final String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';
      // final response = await http.get(Uri.parse(url));
      // ... parse response and return formatted address

      return null; // Disabled for now
    } catch (e) {
      return null;
    }
  }

  // Enhanced coordinate formatting
  String _formatCoordinatesAsAddress(double latitude, double longitude) {
    String latStr = latitude.toStringAsFixed(6);
    String lngStr = longitude.toStringAsFixed(6);
    String areaGuess = _guessAreaFromCoordinates(latitude, longitude);

    return '$areaGuess\n📍 $latStr, $lngStr\n(Tap to use this location)';
  }

  // Enhanced area guessing for Indonesia
  String _guessAreaFromCoordinates(double latitude, double longitude) {
    // Jakarta area (more precise)
    if (latitude >= -6.5 && latitude <= -5.8 && longitude >= 106.4 && longitude <= 107.2) {
      if (latitude >= -6.3 && latitude <= -6.1 && longitude >= 106.7 && longitude <= 106.9) {
        return 'Central Jakarta Area';
      }
      return 'Greater Jakarta Area (Jabodetabek)';
    }
    // Surabaya area
    else if (latitude >= -7.5 && latitude <= -7.0 && longitude >= 112.5 && longitude <= 113.0) {
      return 'Surabaya Area, East Java';
    }
    // Bandung area
    else if (latitude >= -7.2 && latitude <= -6.7 && longitude >= 107.4 && longitude <= 108.0) {
      return 'Bandung Area, West Java';
    }
    // Bali area
    else if (latitude >= -8.8 && latitude <= -8.0 && longitude >= 114.8 && longitude <= 115.8) {
      return 'Bali Province';
    }
    // Yogyakarta area
    else if (latitude >= -8.0 && latitude <= -7.6 && longitude >= 110.2 && longitude <= 110.6) {
      return 'Yogyakarta Area';
    }
    // Medan area
    else if (latitude >= 3.4 && latitude <= 3.8 && longitude >= 98.5 && longitude <= 98.8) {
      return 'Medan Area, North Sumatra';
    }
    // Makassar area
    else if (latitude >= -5.3 && latitude <= -4.9 && longitude >= 119.3 && longitude <= 119.6) {
      return 'Makassar Area, South Sulawesi';
    }
    // General Indonesia
    else if (latitude >= -11 && latitude <= 6 && longitude >= 95 && longitude <= 141) {
      return 'Indonesia';
    }
    // Outside Indonesia
    else {
      return 'Unknown Location';
    }
  }

  // Get current address with better error handling
  Future<String> getCurrentAddress({bool useGoogleAPI = false}) async {
    try {
      Position position = await getCurrentPosition();
      return await getAddressFromCoordinates(position.latitude, position.longitude, useGoogleAPI: useGoogleAPI);
    } catch (e) {
      rethrow;
    }
  }

  // Calculate distance between two points (in meters)
  double calculateDistance(
      double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude,
      ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Enhanced distance formatting
  String getReadableDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} m';
    } else if (distanceInMeters < 10000) {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
    } else {
      return '${(distanceInMeters / 1000).round()} km';
    }
  }

  // Enhanced delivery radius check with different zones
  bool isWithinDeliveryRadius(
      double userLat,
      double userLng,
      double storeLat,
      double storeLng, {
        double radiusKm = 50.0,
      }) {
    double distance = calculateDistance(userLat, userLng, storeLat, storeLng);
    return distance <= (radiusKm * 1000);
  }

  // Get delivery zone info
  String getDeliveryZoneInfo(
      double userLat,
      double userLng,
      double storeLat,
      double storeLng,
      ) {
    double distanceKm = calculateDistance(userLat, userLng, storeLat, storeLng) / 1000;

    if (distanceKm <= 5) {
      return 'Express Zone (Same day delivery)';
    } else if (distanceKm <= 15) {
      return 'Standard Zone (1-2 days delivery)';
    } else if (distanceKm <= 50) {
      return 'Extended Zone (2-3 days delivery)';
    } else {
      return 'Outside delivery area';
    }
  }

  // Real-time position tracking
  Stream<Position> startRealTimeTracking({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10,
    int timeInterval = 5000,
  }) {
    _positionStreamController?.close();
    _positionStreamController = StreamController<Position>.broadcast();

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
          (Position position) {
        _positionStreamController?.add(position);
      },
      onError: (error) {
        _positionStreamController?.addError(error);
      },
    );

    return _positionStreamController!.stream;
  }

  // Stop real-time tracking
  void stopRealTimeTracking() {
    _positionStreamSubscription?.cancel();
    _positionStreamController?.close();
    _positionStreamSubscription = null;
    _positionStreamController = null;
  }

  // Check if currently tracking
  bool get isTracking => _positionStreamSubscription != null;

  // Convert address to coordinates
  Future<Position?> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        Location location = locations.first;
        return Position(
          latitude: location.latitude,
          longitude: location.longitude,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0,
        );
      }

      return null;
    } catch (e) {
      throw LocationServiceException('Failed to get coordinates from address: $e');
    }
  }

  // Get estimated travel time (basic calculation)
  String getEstimatedTravelTime(double distanceKm) {
    // Assume average speed of 30 km/h for city traffic
    double hours = distanceKm / 30;
    int minutes = (hours * 60).round();

    if (minutes < 60) {
      return '$minutes min';
    } else {
      int hrs = minutes ~/ 60;
      int mins = minutes % 60;
      return '${hrs}h ${mins}m';
    }
  }

  // Cleanup method
  void dispose() {
    stopRealTimeTracking();
  }
}

// Enhanced custom exception
class LocationServiceException implements Exception {
  final String message;
  final String? code;

  LocationServiceException(this.message, {this.code});

  @override
  String toString() => 'LocationServiceException: $message${code != null ? ' (Code: $code)' : ''}';
}