import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/helpers/image_helper.dart';
import 'package:gaza_go/platform/models/location_model.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Custom user location layer that renders both dot and pickup radius circle
/// This provides perfect synchronization as both elements update together
class CustomUserLocationLayer extends StatefulWidget {
  final GoogleMapController mapController;
  final double accuracyRadius;

  const CustomUserLocationLayer({
    super.key,
    required this.mapController,
    required this.accuracyRadius,
  });

  @override
  State<CustomUserLocationLayer> createState() =>
      _CustomUserLocationLayerState();
}

class _CustomUserLocationLayerState extends State<CustomUserLocationLayer> {
  final ActivityController controller = Get.find<ActivityController>();

  // Current location marker
  BitmapDescriptor? _userLocationIcon;
  final MarkerId _userMarkerId = const MarkerId('user_location');
  final CircleId _accuracyCircleId = const CircleId('accuracy_radius_native');

  // Stream subscription
  StreamSubscription<LocationModel?>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    // Load custom marker icon
    _loadMarkerIcon().whenComplete(
      () {
        // Listen to location updates
        _startLocationUpdates();
      },
    );
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadMarkerIcon() async {
    // Create a custom icon that looks like the native blue dot
    final customIcon = await _createCustomLocationIcon();
    setState(() {
      _userLocationIcon = customIcon;
    });
  }

  Future<BitmapDescriptor> _createCustomLocationIcon() async {
    // Use blue marker to mimic native location dot
    return ImageHelper.bitmapDescriptorFromSvgAsset(
      "assets/images/activity/ico_map_my_dot.svg",
      const Size.square(5),
      -1,
    );
  }

  void _startLocationUpdates() {
    // Listen to location stream
    _locationSubscription =
        controller.currentLocation.stream.listen((location) {
      if (location != null && mounted) {
        _updateLocationOverlays(location);
      }
    });

    // Initial update if location is available
    if (controller.currentLocation.value != null) {
      _updateLocationOverlays(controller.currentLocation.value!);
    }
  }

  void _updateLocationOverlays(LocationModel location) {
    final position = LatLng(location.latitude, location.longitude);

    // Debug print to ensure this is being called
    if (kDebugMode) {
      print(
          '🎯 CustomUserLocationLayer: Updating location overlays at $position');
    }

    // Create marker set
    final Set<Marker> markers = {
      Marker(
        markerId: _userMarkerId,
        position: position,
        icon: _userLocationIcon ?? BitmapDescriptor.defaultMarker,
        anchor: const Offset(0.5, 0.5),
        zIndex: 999,
        // Always on top
        flat: false,
        // Make it 3D so it's more visible
        rotation: 0,
      ),
    };

    final Set<Circle> circles = {
      // Pickup radius circle
      Circle(
        circleId: _accuracyCircleId,
        center: position,
        radius: widget.accuracyRadius,
        fillColor: const Color(0xff0E79F3).withOpacity(0.15),
        strokeColor: const Color(0xff0E79F3).withOpacity(0.3),
        strokeWidth: 1,
        zIndex: 1,
      ),
    };

    // Update overlays in batch
    _updateOverlays(markers, circles);

    // Optionally animate camera to follow user
    if (controller.isLockMap.value) {
      widget.mapController.animateCamera(
        CameraUpdate.newLatLng(position),
      );
    }
  }

  void _updateOverlays(Set<Marker> markers, Set<Circle> circles) {
    // Schedule update for after current build cycle to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (kDebugMode) {
        print(
            '📍 CustomUserLocationLayer: Updating overlays - ${markers.length} markers, ${circles.length} circles');
        print('📍 Total markers before: ${controller.drawingMarkers.length}');
        print('📍 Total circles before: ${controller.drawingCircles.length}');
      }

      // Remove old user location marker and circles
      controller.drawingMarkers.removeWhere((m) => m.markerId == _userMarkerId);
      controller.drawingCircles
          .removeWhere((c) => c.circleId == _accuracyCircleId);

      // Add new ones
      controller.drawingMarkers.addAll(markers);
      controller.drawingCircles.addAll(circles);

      if (kDebugMode) {
        print('📍 Total markers after: ${controller.drawingMarkers.length}');
        print('📍 Total circles after: ${controller.drawingCircles.length}');
      }

      // Refresh to trigger rebuild
      controller.drawingMarkers.refresh();
      controller.drawingCircles.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    // This widget doesn't render UI directly, it updates map overlays
    return const SizedBox.shrink();
  }
}

/// Helper widget to integrate custom location layer into existing map
class EnhancedGoogleMap extends StatefulWidget {
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final Set<Polygon> polygons;
  final Set<Circle> circles;
  final bool useCustomLocationLayer;
  final double accuracyRadius;
  final Function(GoogleMapController) onMapCreated;
  final CameraPosition initialCameraPosition;
  final MinMaxZoomPreference? minMaxZoomPreference;
  final MapType mapType;
  final bool indoorViewEnabled;
  final bool mapToolbarEnabled;
  final bool myLocationButtonEnabled;
  final bool zoomControlsEnabled;
  final bool zoomGesturesEnabled;
  final bool tiltGesturesEnabled;
  final bool rotateGesturesEnabled;
  final bool scrollGesturesEnabled;
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;
  final EdgeInsets? padding;

  const EnhancedGoogleMap({
    super.key,
    required this.markers,
    required this.polylines,
    required this.polygons,
    required this.circles,
    required this.onMapCreated,
    required this.initialCameraPosition,
    this.useCustomLocationLayer = false,
    this.accuracyRadius = 5,
    this.minMaxZoomPreference,
    this.mapType = MapType.normal,
    this.indoorViewEnabled = true,
    this.mapToolbarEnabled = false,
    this.myLocationButtonEnabled = false,
    this.zoomControlsEnabled = false,
    this.zoomGesturesEnabled = true,
    this.tiltGesturesEnabled = true,
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.gestureRecognizers,
    this.padding,
  });

  @override
  State<EnhancedGoogleMap> createState() => _EnhancedGoogleMapState();
}

class _EnhancedGoogleMapState extends State<EnhancedGoogleMap> {
  GoogleMapController? mapController;

  void _onMapCreated(GoogleMapController controller) {
    if (kDebugMode) {
      print(
          '🗺 EnhancedGoogleMap: Map created, useCustomLocationLayer=${widget.useCustomLocationLayer}');
    }

    // Schedule the setState for after the current build cycle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          mapController = controller;
        });
      }
    });

    // Call the original callback immediately
    widget.onMapCreated(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          markers: widget.markers,
          polylines: widget.polylines,
          polygons: widget.polygons,
          circles: widget.circles,
          // Disable native location if using custom layer
          myLocationEnabled: !widget.useCustomLocationLayer,
          padding: widget.padding ?? EdgeInsets.zero,
          minMaxZoomPreference:
              widget.minMaxZoomPreference ?? const MinMaxZoomPreference(8, 20),
          mapType: widget.mapType,
          indoorViewEnabled: widget.indoorViewEnabled,
          mapToolbarEnabled: widget.mapToolbarEnabled,
          myLocationButtonEnabled: widget.myLocationButtonEnabled,
          zoomControlsEnabled: widget.zoomControlsEnabled,
          initialCameraPosition: widget.initialCameraPosition,
          zoomGesturesEnabled: widget.zoomGesturesEnabled,
          tiltGesturesEnabled: widget.tiltGesturesEnabled,
          rotateGesturesEnabled: widget.rotateGesturesEnabled,
          scrollGesturesEnabled: widget.scrollGesturesEnabled,
          gestureRecognizers: widget.gestureRecognizers ??
              const <Factory<OneSequenceGestureRecognizer>>{},
          onMapCreated: _onMapCreated,
        ),
        // Add custom location layer if enabled and map is ready
        if (widget.useCustomLocationLayer && mapController != null)
          CustomUserLocationLayer(
            mapController: mapController!,
            accuracyRadius: widget.accuracyRadius,
          ),
      ],
    );
  }
}
