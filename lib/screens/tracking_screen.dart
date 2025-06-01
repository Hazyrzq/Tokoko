// lib/screens/tracking_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../services/tracking_service.dart';
import '../providers/location_provider.dart';
import 'package:geolocator/geolocator.dart';

class TrackingScreen extends StatefulWidget {
  final String orderId;
  final String orderDescription;

  const TrackingScreen({
    Key? key,
    required this.orderId,
    required this.orderDescription,
  }) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final TrackingService _trackingService = TrackingService();
  StreamSubscription<CourierLocation>? _courierLocationSubscription;
  StreamSubscription<TrackingStatus>? _trackingStatusSubscription;

  // Current tracking data
  CourierLocation? _currentCourierLocation;
  TrackingStatus? _currentTrackingStatus;

  // Map simulation (since we can't use real Google Maps without API key)
  bool _isMapLoaded = false;

  @override
  void initState() {
    super.initState();
    _initializeTracking();
  }

  void _initializeTracking() async {
    // Get user's current location if available
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    Position? customerLocation;

    try {
      await locationProvider.getCurrentLocation();
      customerLocation = locationProvider.currentPosition;
    } catch (e) {
      // Use default location if GPS fails
      print('GPS failed, using default location');
    }

    // Start tracking simulation
    await _trackingService.startTracking(
      widget.orderId,
      customerLocation: customerLocation,
    );

    // Listen to updates
    _courierLocationSubscription = _trackingService.courierLocationStream.listen((location) {
      setState(() {
        _currentCourierLocation = location;
      });
    });

    _trackingStatusSubscription = _trackingService.trackingStatusStream.listen((status) {
      setState(() {
        _currentTrackingStatus = status;
      });
    });

    // Simulate map loading
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isMapLoaded = true;
      });
    });
  }

  @override
  void dispose() {
    _courierLocationSubscription?.cancel();
    _trackingStatusSubscription?.cancel();
    _trackingService.stopTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF2D7BEE);
    final secondaryColor = const Color(0xFFFF8C00);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Lacak Pesanan',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: primaryColor,
              size: 16,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Order Info Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pesanan ${widget.orderId}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        widget.orderDescription,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Map Container (Simulated)
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildMapSimulation(primaryColor),
              ),
            ),
          ),

          // Tracking Status Card
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _buildTrackingInfo(primaryColor, secondaryColor),
          ),

          // Courier Info Card
          if (_currentCourierLocation != null)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _buildCourierInfo(primaryColor),
            ),
        ],
      ),
    );
  }

  // Map simulation (without Google Maps API)
  Widget _buildMapSimulation(Color primaryColor) {
    if (!_isMapLoaded) {
      return Container(
        color: Colors.grey[100],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
              const SizedBox(height: 16),
              Text(
                'Loading Map...',
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        // Map background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue[50]!,
                Colors.green[50]!,
              ],
            ),
          ),
          child: CustomPaint(
            painter: MapPainter(),
            size: Size.infinite,
          ),
        ),

        // Store marker
        Positioned(
          top: 50,
          left: 50,
          child: _buildMarker(
            Icons.store,
            primaryColor,
            'Toko',
          ),
        ),

        // Customer marker
        Positioned(
          bottom: 80,
          right: 60,
          child: _buildMarker(
            Icons.home,
            Colors.green[700]!,
            'Alamat Anda',
          ),
        ),

        // Courier marker (animated)
        if (_currentCourierLocation != null)
          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            top: _getCourierMapPosition().dy,
            left: _getCourierMapPosition().dx,
            child: _buildCourierMarker(primaryColor),
          ),

        // Route line (simplified)
        CustomPaint(
          painter: RoutePainter(
            primaryColor.withOpacity(0.6),
            _currentCourierLocation != null ? _trackingService.getRoute() : [],
          ),
          size: Size.infinite,
        ),
      ],
    );
  }

  // Get courier position on map (simulation)
  Offset _getCourierMapPosition() {
    if (_currentCourierLocation == null) return const Offset(50, 50);

    // Simulate movement between store (50,50) and customer (right-60, bottom-80)
    // This is just for visual effect
    double progress = (_trackingService.isTracking)
        ? (DateTime.now().millisecondsSinceEpoch / 10000) % 1.0
        : 0.0;

    double startX = 50;
    double startY = 50;
    double endX = MediaQuery.of(context).size.width - 60 - 50; // Account for margins
    double endY = 200; // Approximate position

    double currentX = startX + (endX - startX) * progress;
    double currentY = startY + (endY - startY) * progress;

    return Offset(currentX, currentY);
  }

  // Build map marker
  Widget _buildMarker(IconData icon, Color color, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  // Build courier marker (animated)
  Widget _buildCourierMarker(Color primaryColor) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.orange[600],
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.motorcycle,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.orange[600],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            'Kurir',
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // Build tracking info
  Widget _buildTrackingInfo(Color primaryColor, Color secondaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.timeline,
                color: primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Status Pengiriman',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Current status
        if (_currentTrackingStatus != null) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getStatusColor(_currentTrackingStatus!.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getStatusColor(_currentTrackingStatus!.status).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getStatusIcon(_currentTrackingStatus!.status),
                  color: _getStatusColor(_currentTrackingStatus!.status),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentTrackingStatus!.message,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      if (_currentCourierLocation != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Estimasi tiba: ${_formatTime(_currentTrackingStatus!.estimatedArrival)}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Jarak: ${(_currentCourierLocation!.distanceRemaining / 1000).toStringAsFixed(1)} km',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
                const SizedBox(width: 16),
                Text(
                  'Memuat status pengiriman...',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // Build courier info
  Widget _buildCourierInfo(Color primaryColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.person,
            color: Colors.orange[700],
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _currentCourierLocation!.courierName,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              Text(
                _currentCourierLocation!.courierPhone,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            // Simulate call action
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Menghubungi ${_currentCourierLocation!.courierName}...',
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: primaryColor,
              ),
            );
          },
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.phone,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  // Helper methods
  Color _getStatusColor(TrackingStatusEnum status) {
    switch (status) {
      case TrackingStatusEnum.preparing:
        return Colors.orange[600]!;
      case TrackingStatusEnum.pickedUp:
        return Colors.blue[600]!;
      case TrackingStatusEnum.onTheWay:
        return Colors.purple[600]!;
      case TrackingStatusEnum.nearDestination:
        return Colors.amber[600]!;
      case TrackingStatusEnum.delivered:
        return Colors.green[600]!;
    }
  }

  IconData _getStatusIcon(TrackingStatusEnum status) {
    switch (status) {
      case TrackingStatusEnum.preparing:
        return Icons.restaurant;
      case TrackingStatusEnum.pickedUp:
        return Icons.local_shipping;
      case TrackingStatusEnum.onTheWay:
        return Icons.motorcycle;
      case TrackingStatusEnum.nearDestination:
        return Icons.near_me;
      case TrackingStatusEnum.delivered:
        return Icons.check_circle;
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

// Custom painters for map simulation
class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 2;

    // Draw some roads/paths
    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.3),
      paint,
    );

    canvas.drawLine(
      Offset(0, size.height * 0.7),
      Offset(size.width, size.height * 0.7),
      paint,
    );

    canvas.drawLine(
      Offset(size.width * 0.3, 0),
      Offset(size.width * 0.3, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(size.width * 0.7, 0),
      Offset(size.width * 0.7, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RoutePainter extends CustomPainter {
  final Color routeColor;
  final List<Position> route;

  RoutePainter(this.routeColor, this.route);

  @override
  void paint(Canvas canvas, Size size) {
    if (route.length < 2) return;

    final paint = Paint()
      ..color = routeColor
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Draw route line (simplified for simulation)
    final path = Path();
    path.moveTo(50, 50); // Store position
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.3,
      size.width - 110,
      size.height - 120,
    ); // Customer position

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}