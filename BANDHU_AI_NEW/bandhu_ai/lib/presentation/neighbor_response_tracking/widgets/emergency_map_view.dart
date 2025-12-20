import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class EmergencyMapView extends StatefulWidget {
  final LatLng userLocation;
  final List<Map<String, dynamic>> respondingNeighbors;
  final VoidCallback? onMapCreated;

  const EmergencyMapView({
    super.key,
    required this.userLocation,
    required this.respondingNeighbors,
    this.onMapCreated,
  });

  @override
  State<EmergencyMapView> createState() => _EmergencyMapViewState();
}

class _EmergencyMapViewState extends State<EmergencyMapView>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);
    _createMarkers();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EmergencyMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.respondingNeighbors != widget.respondingNeighbors) {
      _createMarkers();
    }
  }

  void _createMarkers() {
    final Set<Marker> markers = {};

    // User location marker (pulsing red)
    markers.add(
      Marker(
        markerId: const MarkerId('user_location'),
        position: widget.userLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(
          title: 'Your Location',
          snippet: 'Emergency location',
        ),
      ),
    );

    // Responding neighbors markers
    for (int i = 0; i < widget.respondingNeighbors.length; i++) {
      final neighbor = widget.respondingNeighbors[i];
      final location = neighbor["location"] as Map<String, dynamic>?;

      if (location != null) {
        final lat = (location["latitude"] as num?)?.toDouble();
        final lng = (location["longitude"] as num?)?.toDouble();

        if (lat != null && lng != null) {
          markers.add(
            Marker(
              markerId: MarkerId('neighbor_$i'),
              position: LatLng(lat, lng),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              infoWindow: InfoWindow(
                title: (neighbor["name"] as String?) ?? "Helper",
                snippet:
                    "${(neighbor["distance"] as num?)?.toStringAsFixed(1) ?? "0.0"} km away • ETA: ${(neighbor["eta"] as int?) ?? 0} min",
              ),
            ),
          );
        }
      }
    }

    if (mounted) {
      setState(() {
        _markers = markers;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    widget.onMapCreated?.call();
    _fitMarkersInView();
  }

  void _fitMarkersInView() {
    if (_mapController == null || _markers.isEmpty) return;

    final List<LatLng> positions =
        _markers.map((marker) => marker.position).toList();

    if (positions.length == 1) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: positions.first,
            zoom: 16.0,
          ),
        ),
      );
      return;
    }

    double minLat = positions.first.latitude;
    double maxLat = positions.first.latitude;
    double minLng = positions.first.longitude;
    double maxLng = positions.first.longitude;

    for (final position in positions) {
      minLat = minLat < position.latitude ? minLat : position.latitude;
      maxLat = maxLat > position.latitude ? maxLat : position.latitude;
      minLng = minLng < position.longitude ? minLng : position.longitude;
      maxLng = maxLng > position.longitude ? maxLng : position.longitude;
    }

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        100.0, // padding
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: widget.userLocation,
                zoom: 14.0,
              ),
              markers: _markers,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: true,
              trafficEnabled: false,
              buildingsEnabled: true,
              indoorViewEnabled: false,
              mapType: MapType.normal,
              onTap: (LatLng position) {
                // Handle map tap if needed
              },
            ),
            // Connection status indicator
            Positioned(
              top: 2.h,
              right: 4.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface
                      .withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: _pulseAnimation.value),
                            shape: BoxShape.circle,
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      "Live",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            // Legend
            Positioned(
              bottom: 2.h,
              left: 4.w,
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface
                      .withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          "Your Location",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          "Helpers",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
