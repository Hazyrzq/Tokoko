// lib/services/tracking_service.dart
import 'dart:async';
import 'dart:math';
import 'package:geolocator/geolocator.dart';

class TrackingService {
  static final TrackingService _instance = TrackingService._internal();
  factory TrackingService() => _instance;
  TrackingService._internal();

  // Stream controllers for real-time tracking
  final StreamController<CourierLocation> _courierLocationController =
  StreamController<CourierLocation>.broadcast();
  final StreamController<TrackingStatus> _trackingStatusController =
  StreamController<TrackingStatus>.broadcast();

  // Getters for streams
  Stream<CourierLocation> get courierLocationStream => _courierLocationController.stream;
  Stream<TrackingStatus> get trackingStatusStream => _trackingStatusController.stream;

  // Simulation variables
  Timer? _simulationTimer;
  bool _isTracking = false;
  double _currentProgress = 0.0;

  // Default locations (Jakarta area)
  final Position _storeLocation = Position(
    latitude: -6.2088,
    longitude: 106.8456,
    timestamp: DateTime.now(),
    accuracy: 0.0,
    altitude: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
    altitudeAccuracy: 0.0,
    headingAccuracy: 0.0,
  );

  Position? _customerLocation;
  List<Position> _route = [];

  // Start tracking simulation
  Future<void> startTracking(String orderId, {Position? customerLocation}) async {
    if (_isTracking) return;

    _isTracking = true;
    _currentProgress = 0.0;

    // Set customer location (use default if not provided)
    _customerLocation = customerLocation ?? Position(
      latitude: -6.1944, // Default: South Jakarta
      longitude: 106.8229,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );

    // Generate route points
    _generateRoute();

    // Start simulation
    _simulationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _updateCourierPosition();
    });

    // Initial status
    _trackingStatusController.add(TrackingStatus(
      orderId: orderId,
      status: TrackingStatusEnum.preparing,
      message: 'Pesanan sedang disiapkan',
      estimatedArrival: DateTime.now().add(const Duration(minutes: 45)),
    ));
  }

  // Generate route points between store and customer
  void _generateRoute() {
    _route.clear();

    double startLat = _storeLocation.latitude;
    double startLng = _storeLocation.longitude;
    double endLat = _customerLocation!.latitude;
    double endLng = _customerLocation!.longitude;

    // Generate intermediate points (simple linear interpolation)
    int numPoints = 20;
    for (int i = 0; i <= numPoints; i++) {
      double progress = i / numPoints;
      double lat = startLat + (endLat - startLat) * progress;
      double lng = startLng + (endLng - startLng) * progress;

      // Add some random variation to make it more realistic
      lat += (Random().nextDouble() - 0.5) * 0.002; // ~200m variation
      lng += (Random().nextDouble() - 0.5) * 0.002;

      _route.add(Position(
        latitude: lat,
        longitude: lng,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      ));
    }
  }

  // Update courier position simulation
  void _updateCourierPosition() {
    if (!_isTracking || _route.isEmpty) return;

    _currentProgress += 0.05; // 5% progress each update

    if (_currentProgress >= 1.0) {
      // Arrived at destination
      _currentProgress = 1.0;
      _trackingStatusController.add(TrackingStatus(
        orderId: 'current',
        status: TrackingStatusEnum.delivered,
        message: 'Pesanan telah sampai!',
        estimatedArrival: DateTime.now(),
      ));
      stopTracking();
      return;
    }

    // Calculate current position along route
    int routeIndex = (_currentProgress * (_route.length - 1)).floor();
    routeIndex = routeIndex.clamp(0, _route.length - 1);

    Position currentPos = _route[routeIndex];

    // Calculate distance remaining
    double distanceRemaining = Geolocator.distanceBetween(
      currentPos.latitude,
      currentPos.longitude,
      _customerLocation!.latitude,
      _customerLocation!.longitude,
    );

    // Estimate time remaining (assuming 20 km/h average speed)
    int timeRemainingMinutes = (distanceRemaining / 1000 * 3).round(); // 3 minutes per km

    // Update status based on progress
    TrackingStatusEnum status;
    String message;

    if (_currentProgress < 0.1) {
      status = TrackingStatusEnum.preparing;
      message = 'Pesanan sedang disiapkan';
    } else if (_currentProgress < 0.2) {
      status = TrackingStatusEnum.pickedUp;
      message = 'Pesanan telah diambil kurir';
    } else if (_currentProgress < 0.9) {
      status = TrackingStatusEnum.onTheWay;
      message = 'Kurir sedang dalam perjalanan';
    } else {
      status = TrackingStatusEnum.nearDestination;
      message = 'Kurir sudah dekat dengan lokasi Anda';
    }

    // Send updates
    _courierLocationController.add(CourierLocation(
      position: currentPos,
      courierName: 'Ahmad (Kurir)',
      courierPhone: '+62 812-3456-7890',
      estimatedArrival: DateTime.now().add(Duration(minutes: timeRemainingMinutes)),
      distanceRemaining: distanceRemaining,
    ));

    _trackingStatusController.add(TrackingStatus(
      orderId: 'current',
      status: status,
      message: message,
      estimatedArrival: DateTime.now().add(Duration(minutes: timeRemainingMinutes)),
    ));
  }

  // Stop tracking
  void stopTracking() {
    _isTracking = false;
    _simulationTimer?.cancel();
    _simulationTimer = null;
    _currentProgress = 0.0;
  }

  // Get route for map display
  List<Position> getRoute() => _route;

  // Get store location
  Position getStoreLocation() => _storeLocation;

  // Get customer location
  Position? getCustomerLocation() => _customerLocation;

  // Check if currently tracking
  bool get isTracking => _isTracking;

  // Dispose
  void dispose() {
    stopTracking();
    _courierLocationController.close();
    _trackingStatusController.close();
  }
}

// Data models
class CourierLocation {
  final Position position;
  final String courierName;
  final String courierPhone;
  final DateTime estimatedArrival;
  final double distanceRemaining;

  CourierLocation({
    required this.position,
    required this.courierName,
    required this.courierPhone,
    required this.estimatedArrival,
    required this.distanceRemaining,
  });
}

class TrackingStatus {
  final String orderId;
  final TrackingStatusEnum status;
  final String message;
  final DateTime estimatedArrival;

  TrackingStatus({
    required this.orderId,
    required this.status,
    required this.message,
    required this.estimatedArrival,
  });
}

enum TrackingStatusEnum {
  preparing,
  pickedUp,
  onTheWay,
  nearDestination,
  delivered,
}