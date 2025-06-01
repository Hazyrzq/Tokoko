// lib/providers/location_provider.dart
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

class LocationProvider with ChangeNotifier {
  final LocationService _locationService = LocationService();

  // State variables
  Position? _currentPosition;
  String? _currentAddress;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLocationServiceEnabled = false;
  LocationPermission _permissionStatus = LocationPermission.denied;

  // Getters
  Position? get currentPosition => _currentPosition;
  String? get currentAddress => _currentAddress;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLocationServiceEnabled => _isLocationServiceEnabled;
  LocationPermission get permissionStatus => _permissionStatus;
  bool get hasLocationPermission =>
      _permissionStatus == LocationPermission.always ||
          _permissionStatus == LocationPermission.whileInUse;

  // Initialize location service
  Future<void> initializeLocationService() async {
    try {
      _setLoading(true);
      _clearError();

      // Check if location service is enabled
      _isLocationServiceEnabled = await _locationService.isLocationServiceEnabled();

      // Check permission status
      _permissionStatus = await Geolocator.checkPermission();

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Request location permission
  Future<bool> requestLocationPermission() async {
    try {
      _setLoading(true);
      _clearError();

      _permissionStatus = await _locationService.requestLocationPermission();

      if (hasLocationPermission) {
        notifyListeners();
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

      // Get current position
      _currentPosition = await _locationService.getCurrentPosition();

      // Convert to address
      if (_currentPosition != null) {
        _currentAddress = await _locationService.getAddressFromCoordinates(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
      }

      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get address from coordinates
  Future<String?> getAddressFromCoordinates(double lat, double lng) async {
    try {
      return await _locationService.getAddressFromCoordinates(lat, lng);
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  // Calculate distance to a destination
  String? calculateDistanceToDestination(double destLat, double destLng) {
    if (_currentPosition == null) return null;

    double distance = _locationService.calculateDistance(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      destLat,
      destLng,
    );

    return _locationService.getReadableDistance(distance);
  }

  // Check if within delivery radius
  bool isWithinDeliveryRadius(double storeLat, double storeLng) {
    if (_currentPosition == null) return false;

    return _locationService.isWithinDeliveryRadius(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      storeLat,
      storeLng,
    );
  }

  // Clear current location data
  void clearLocationData() {
    _currentPosition = null;
    _currentAddress = null;
    _clearError();
    notifyListeners();
  }

  // Helper methods
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
}