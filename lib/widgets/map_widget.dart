// lib/widgets/map_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/location_provider.dart';
import 'dart:async';

class MapWidget extends StatefulWidget {
  final LatLng? initialLocation;
  final bool showCurrentLocation;
  final bool enableRealTimeTracking;
  final Function(LatLng)? onLocationSelected;
  final double height;
  final List<Marker>? customMarkers;
  final bool showControls;
  final Function(MapController)? onMapReady;

  const MapWidget({
    Key? key,
    this.initialLocation,
    this.showCurrentLocation = true,
    this.enableRealTimeTracking = false,
    this.onLocationSelected,
    this.height = 300,
    this.customMarkers,
    this.showControls = true,
    this.onMapReady,
  }) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final MapController _mapController = MapController();
  StreamSubscription? _locationStreamSubscription;
  LatLng? _selectedLocation;
  bool _isFollowingUser = false;
  double _currentZoom = 15.0;

  // Default location (Jakarta)
  static const LatLng _defaultLocation = LatLng(-6.2088, 106.8456);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMap();
      // TAMBAHKAN INI: callback ke parent
      if (widget.onMapReady != null) {
        widget.onMapReady!(_mapController);
      }
    });
  }

  @override
  void dispose() {
    _locationStreamSubscription?.cancel();
    super.dispose();
  }

  void _initializeMap() async {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);

    // Move to initial location or current location
    LatLng targetLocation = widget.initialLocation ??
        locationProvider.currentLatLng ??
        _defaultLocation;

    _mapController.move(targetLocation, _currentZoom);

    // Start real-time tracking if enabled
    if (widget.enableRealTimeTracking) {
      _startRealTimeTracking();
    }
  }

  void _startRealTimeTracking() {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);

    // Cancel existing subscription
    _locationStreamSubscription?.cancel();

    // Start periodic location updates
    _locationStreamSubscription = Stream.periodic(
      const Duration(seconds: 5),
          (count) => count,
    ).asyncMap((_) async {
      if (mounted) {
        await locationProvider.getCurrentLocation();
        return locationProvider.currentLatLng;
      }
      return null;
    }).listen((latLng) {
      if (latLng != null && mounted) {
        if (_isFollowingUser) {
          _mapController.move(latLng, _currentZoom);
        }
        setState(() {});
      }
    });
  }

  void _stopRealTimeTracking() {
    _locationStreamSubscription?.cancel();
    _locationStreamSubscription = null;
  }

  void _onMapTap(TapPosition tapPosition, LatLng latLng) {
    if (widget.onLocationSelected != null) {
      setState(() {
        _selectedLocation = latLng;
      });
      widget.onLocationSelected!(latLng);
    }
  }

  void _centerOnCurrentLocation() async {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);

    if (locationProvider.currentLatLng != null) {
      _mapController.move(locationProvider.currentLatLng!, _currentZoom);
      setState(() {
        _isFollowingUser = true;
      });
    } else {
      // Try to get current location
      bool success = await locationProvider.getCurrentLocation();
      if (success && locationProvider.currentLatLng != null) {
        _mapController.move(locationProvider.currentLatLng!, _currentZoom);
        setState(() {
          _isFollowingUser = true;
        });
      } else {
        // Show error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Unable to get current location'),
              backgroundColor: Colors.red[400],
            ),
          );
        }
      }
    }
  }

  List<Marker> _buildMarkers() {
    List<Marker> markers = [];
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);

    // Add current location marker
    if (widget.showCurrentLocation && locationProvider.currentLatLng != null) {
      markers.add(
        Marker(
          point: locationProvider.currentLatLng!,
          child: _buildCurrentLocationMarker(),
        ),
      );
    }

    // Add selected location marker
    if (_selectedLocation != null) {
      markers.add(
        Marker(
          point: _selectedLocation!,
          child: _buildSelectedLocationMarker(),
        ),
      );
    }

    // Add custom markers
    if (widget.customMarkers != null) {
      markers.addAll(widget.customMarkers!);
    }

    return markers;
  }

  Widget _buildCurrentLocationMarker() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.my_location,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildSelectedLocationMarker() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.location_on,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Main Map
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: widget.initialLocation ??
                        locationProvider.currentLatLng ??
                        _defaultLocation,
                    initialZoom: _currentZoom,
                    minZoom: 3.0,
                    maxZoom: 18.0,
                    onTap: _onMapTap,
                    onPositionChanged: (camera, hasGesture) {
                      if (hasGesture) {
                        setState(() {
                          _isFollowingUser = false;
                          _currentZoom = camera.zoom;
                        });
                      }
                    },
                  ),
                  children: [
                    // Tile Layer (OpenStreetMap)
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.yourapp.project',
                      maxZoom: 18,
                    ),

                    // Markers Layer
                    MarkerLayer(
                      markers: _buildMarkers(),
                    ),
                  ],
                ),

                // Controls overlay
                if (widget.showControls) ...[
                  // Current Location Button
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: _buildControlButton(
                      icon: _isFollowingUser ? Icons.gps_fixed : Icons.gps_not_fixed,
                      color: _isFollowingUser ? Colors.blue : Colors.grey[600]!,
                      onPressed: _centerOnCurrentLocation,
                      tooltip: 'Center on current location',
                    ),
                  ),

                  // Real-time tracking toggle (if enabled)
                  if (widget.enableRealTimeTracking)
                    Positioned(
                      bottom: 80,
                      right: 20,
                      child: _buildControlButton(
                        icon: _locationStreamSubscription != null
                            ? Icons.location_searching
                            : Icons.location_disabled,
                        color: _locationStreamSubscription != null
                            ? Colors.green
                            : Colors.grey[600]!,
                        onPressed: () {
                          if (_locationStreamSubscription != null) {
                            _stopRealTimeTracking();
                          } else {
                            _startRealTimeTracking();
                          }
                          setState(() {});
                        },
                        tooltip: _locationStreamSubscription != null
                            ? 'Stop tracking'
                            : 'Start tracking',
                      ),
                    ),

                  // Zoom Controls
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Column(
                      children: [
                        _buildControlButton(
                          icon: Icons.add,
                          color: Colors.grey[700]!,
                          onPressed: () {
                            setState(() {
                              _currentZoom = (_currentZoom + 1).clamp(3.0, 18.0);
                            });
                            _mapController.move(
                              _mapController.camera.center,
                              _currentZoom,
                            );
                          },
                          tooltip: 'Zoom in',
                        ),
                        const SizedBox(height: 8),
                        _buildControlButton(
                          icon: Icons.remove,
                          color: Colors.grey[700]!,
                          onPressed: () {
                            setState(() {
                              _currentZoom = (_currentZoom - 1).clamp(3.0, 18.0);
                            });
                            _mapController.move(
                              _mapController.camera.center,
                              _currentZoom,
                            );
                          },
                          tooltip: 'Zoom out',
                        ),
                      ],
                    ),
                  ),
                ],

                // Loading overlay
                if (locationProvider.isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),

                // Error overlay
                if (locationProvider.errorMessage != null)
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 80,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red[600], size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              locationProvider.errorMessage!,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.red[600],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 16),
                            onPressed: () => locationProvider.clearError(),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(icon, color: color, size: 20),
          onPressed: onPressed,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

// Helper widget untuk preview peta kecil
class MiniMapWidget extends StatelessWidget {
  final LatLng? location;
  final double height;

  const MiniMapWidget({
    Key? key,
    this.location,
    this.height = 150,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      initialLocation: location,
      height: height,
      showCurrentLocation: false,
      showControls: false,
      customMarkers: location != null
          ? [
        Marker(
          point: location!,
          child: const Icon(
            Icons.location_on,
            color: Colors.red,
            size: 30,
          ),
        ),
      ]
          : null,
    );
  }
}