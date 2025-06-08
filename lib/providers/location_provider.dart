import 'dart:async'; // ADDED: untuk TimeoutException
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart'; // BARU: untuk flutter_map coordinates

class LocationProvider with ChangeNotifier {
  // Location data
  Position? _currentPosition;
  String? _currentAddress;
  LatLng? _currentLatLng; // BARU: untuk flutter_map

  // Status
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLocationServiceEnabled = false;
  LocationPermission _permissionStatus = LocationPermission.denied;

  // Getters
  Position? get currentPosition => _currentPosition;
  String? get currentAddress => _currentAddress;
  LatLng? get currentLatLng => _currentLatLng; // BARU: getter untuk koordinat peta
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLocationServiceEnabled => _isLocationServiceEnabled;
  LocationPermission get permissionStatus => _permissionStatus;
  bool get hasLocationPermission =>
      _permissionStatus == LocationPermission.always ||
          _permissionStatus == LocationPermission.whileInUse;

  // BARU: Default location (Jakarta) jika GPS tidak tersedia
  static const LatLng defaultLocation = LatLng(-6.2088, 106.8456);

  // Initialize location service
  Future<void> initializeLocationService() async {
    try {
      _setLoading(true);
      _clearError();

      _isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
      _permissionStatus = await Geolocator.checkPermission();

      if (!_isLocationServiceEnabled) {
        _setError('Location services are disabled. Please enable GPS.');
        return;
      }

      // Check permission status
      if (_permissionStatus == LocationPermission.denied ||
          _permissionStatus == LocationPermission.deniedForever) {
        _setError('Location permission is required for this feature.');
      }

    } catch (e) {
      _setError('Failed to initialize location service: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Request location permission
  Future<bool> requestLocationPermission() async {
    try {
      _setLoading(true);
      _clearError();

      _permissionStatus = await Geolocator.requestPermission();

      if (hasLocationPermission) {
        return true;
      } else {
        _setError('Location permission denied');
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get current location and address
  Future<bool> getCurrentLocation() async {
    try {
      _setLoading(true);
      _clearError();

      // Check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _setError('Location services are disabled. Please enable GPS in settings.');
        return false;
      }

      // Check and request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _setError('Location permission denied. Please allow location access.');
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _setError('Location permission permanently denied. Please enable in app settings.');
        return false;
      }

      // Get current position with timeout
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      // BARU: Convert to LatLng untuk flutter_map
      _currentLatLng = LatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude
      );

      // Get address from coordinates
      _currentAddress = await getAddressFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      return true;

    } catch (e) {
      // Handle different types of exceptions
      String errorMessage;

      if (e is LocationServiceDisabledException) {
        errorMessage = 'GPS is turned off. Please enable location services.';
      } else if (e is PermissionDeniedException) {
        errorMessage = 'Location permission denied. Please allow location access.';
      } else if (e is TimeoutException) {
        errorMessage = 'Location request timed out. Please try again.';
      } else if (e.toString().contains('timeout') || e.toString().contains('TIMEOUT')) {
        errorMessage = 'Location request timed out. Please try again.';
      } else {
        errorMessage = 'Failed to get location: ${e.toString()}';
      }

      _setError(errorMessage);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get address from coordinates
  Future<String?> getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        return _formatAddress(placemarks[0]);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting address from coordinates: $e');
      return null;
    }
  }

  // Calculate distance to a destination
  String? calculateDistanceToDestination(double destLat, double destLng) {
    if (_currentPosition == null) return null;

    double distance = Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      destLat,
      destLng,
    );

    return _getReadableDistance(distance);
  }

  // Check if within delivery radius
  bool isWithinDeliveryRadius(double storeLat, double storeLng, {double radiusKm = 10.0}) {
    if (_currentPosition == null) return false;

    double distance = Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      storeLat,
      storeLng,
    );

    return distance <= (radiusKm * 1000); // Convert km to meters
  }

  // Clear current location data
  void clearLocationData() {
    _currentPosition = null;
    _currentAddress = null;
    _currentLatLng = null;
    _clearError();
  }

  // BARU: Get LatLng from address string (untuk search functionality)
  Future<LatLng?> getLatLngFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return LatLng(locations.first.latitude, locations.first.longitude);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting coordinates from address: $e');
      return null;
    }
  }

  // BARU: Get address from LatLng (untuk reverse geocoding)
  Future<String?> getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          latLng.latitude,
          latLng.longitude
      );

      if (placemarks.isNotEmpty) {
        return _formatAddress(placemarks[0]);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting address from coordinates: $e');
      return null;
    }
  }

  // BARU: Set manual location (untuk testing atau manual input)
  void setManualLocation(LatLng latLng, String address) {
    _currentLatLng = latLng;
    _currentAddress = address;
    _currentPosition = Position(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
    notifyListeners();
  }

  // BARU: Reset location data
  void resetLocation() {
    _currentPosition = null;
    _currentAddress = null;
    _currentLatLng = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  // BARU: Check if current location is available
  bool get hasLocation => _currentLatLng != null;

  // BARU: Get current location or default
  LatLng get currentLocationOrDefault => _currentLatLng ?? defaultLocation;

  // Private helper methods
  String _formatAddress(Placemark place) {
    List<String> addressParts = [];

    if (place.street != null && place.street!.isNotEmpty) {
      addressParts.add(place.street!);
    }
    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      addressParts.add(place.subLocality!);
    }
    if (place.locality != null && place.locality!.isNotEmpty) {
      addressParts.add(place.locality!);
    }
    if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
      addressParts.add(place.administrativeArea!);
    }
    if (place.postalCode != null && place.postalCode!.isNotEmpty) {
      addressParts.add(place.postalCode!);
    }

    return addressParts.join(', ');
  }

  String _getReadableDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear error manually
  void clearError() {
    _clearError();
  }

  // Open app settings for permission
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }
}