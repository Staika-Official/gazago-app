import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/views/activity/components/activity_active/cool_down_widget_map.dart';
import 'package:gaza_go/presentations/widgets/custom_user_location_layer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/global_controller.dart';
import 'package:gaza_go/platform/helpers/map_helper.dart';
import 'package:gaza_go/platform/helpers/segmented_polyline_helper.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:get/get.dart';

class ActivityMap extends StatefulWidget {
  const ActivityMap({super.key});

  @override
  State<ActivityMap> createState() => _ActivityMapState();
}

class _ActivityMapState extends State<ActivityMap> {
  ActivityController controller = Get.find();
  GlobalController globalController = Get.find();

  /// Debug print helper to avoid lint warnings
  void _debugPrint(String message) {
    // ignore: avoid_print
    print(message);
  }

  // Track segments for gap effect - SAME LOGIC AS MINI MAP
  List<List<LatLng>> polylineSegments = [];
  List<LatLng> currentSegment = [];
  bool wasNetworkAvailable = true;
  int segmentCounter = 0;

  // Track segmented polylines for fullscreen map
  List<Polyline> segmentedPolylines = [];

  @override
  void initState() {
    super.initState();

    // SAME LOGIC AS MINI MAP - Listen to location updates from GPS directly for segmented polyline
    ever(controller.currentLocation, (location) {
      if (location != null) {
        _handleGPSLocationUpdate(location);
      }
    });

    // Listen to network status changes
    ever(globalController.internetConnection, (bool isConnected) {
      _handleNetworkStatusChange(isConnected);
    });

    // Listen to exercise state changes for pause gap effect
    ever(controller.exerciseState, (ExerciseState state) {
      _handleExerciseStateChange(state);
    });

    // Initialize states
    wasNetworkAvailable = globalController.internetConnection.value;
  }

  @override
  void dispose() {
    controller.challengeMapControllers.removeLast();
    super.dispose();
  }

  /// Add segmented path visualization using SegmentedPolylineHelper - SAME LOGIC AS MINI MAP
  void _addSegmentedPathVisualization() {
    // Clear all existing segmented polylines using helper
    SegmentedPolylineHelper.clearSegmentedPolylines(
      controller.drawingPolylines.toList(),
      'fullscreen_map',
      debugMode: true,
    );

    // Remove cleared polylines from controller
    controller.drawingPolylines.removeWhere((polyline) =>
        polyline.polylineId.value.startsWith('fullscreen_map') ||
        polyline.polylineId.value.startsWith('path_segment_') ||
        polyline.polylineId.value == 'current_segment' ||
        polyline.polylineId.value.contains('segment'));

    // Use SegmentedPolylineHelper to render live segmented polylines
    List<Polyline> segmentedPolylines =
        SegmentedPolylineHelper.renderLiveSegmentedPolylines(
      completedSegments: polylineSegments,
      currentSegment: currentSegment,
      polylineIdPrefix: 'fullscreen_map_live',
      color: Colors.blue,
      width: 4,
      debugMode: true,
    );

    // Add all segmented polylines to the map
    for (Polyline polyline in segmentedPolylines) {
      controller.addOverlay(polyline);
    }
  }

  /// Handle GPS location updates for segmented polyline (independent of controller.coordinates) - SAME LOGIC AS MINI MAP
  void _handleGPSLocationUpdate(dynamic location) {
    // Extract LatLng from location (can be LocationModel or direct coordinates)
    LatLng newCoordinate;
    if (location is LatLng) {
      newCoordinate = location;
    } else {
      // Assume LocationModel with latitude/longitude properties
      newCoordinate = LatLng(location.latitude, location.longitude);
    }

    bool isNetworkAvailable = globalController.internetConnection.value;
    bool isExerciseOngoing =
        controller.exerciseState.value == ExerciseState.ongoing;

    // Handle network state changes
    if (isNetworkAvailable != wasNetworkAvailable) {
      _handleNetworkStateChange(isNetworkAvailable);
      wasNetworkAvailable = isNetworkAvailable;
    }

    // Only add coordinates to segments when BOTH network is available AND exercise is ongoing
    // This creates gap effect for both network loss and pause
    if (isNetworkAvailable && isExerciseOngoing) {
      // Check if this is actually a new coordinate
      if (currentSegment.isEmpty ||
          (currentSegment.last.latitude != newCoordinate.latitude ||
              currentSegment.last.longitude != newCoordinate.longitude)) {
        currentSegment.add(newCoordinate);

        // Update visualization
        _addSegmentedPathVisualization();
      }
    }
  }

  /// Handle network state changes for proper segmentation - SAME LOGIC AS MINI MAP
  void _handleNetworkStateChange(bool isNetworkAvailable) {
    if (!isNetworkAvailable && wasNetworkAvailable) {
      // Network just disconnected - finalize current segment to create gap
      if (currentSegment.length >= 2) {
        polylineSegments.add(List.from(currentSegment));
        segmentCounter++;
        currentSegment.clear();

        // Update visualization to show completed segments
        _addSegmentedPathVisualization();
      } else {
        currentSegment.clear();
      }
    } else if (isNetworkAvailable && !wasNetworkAvailable) {
      // Network reconnected - prepare for new segment (gap will be created)
      currentSegment.clear(); // Ensure clean start
    }
  }

  /// Handle network status changes - called from initState listener - SAME LOGIC AS MINI MAP
  void _handleNetworkStatusChange(bool isConnected) {
    // Trigger network state change if different from current state
    if (isConnected != wasNetworkAvailable) {
      _handleNetworkStateChange(isConnected);
      wasNetworkAvailable = isConnected;
    }
  }

  /// Handle exercise state changes for pause gap effect - SAME LOGIC AS MINI MAP
  void _handleExerciseStateChange(ExerciseState state) {
    _debugPrint('🏋️ Exercise state changed: ${state.toString()}');

    if (state == ExerciseState.paused) {
      // Exercise paused - finalize current segment (similar to network loss)
      if (currentSegment.length >= 2) {
        polylineSegments.add(List.from(currentSegment));
        segmentCounter++;
        currentSegment.clear();

        // Update visualization to show completed segments
        _addSegmentedPathVisualization();
      } else {
        currentSegment.clear();
      }
    } else if (state == ExerciseState.ongoing) {
      // Exercise resumed - prepare for new segment (gap will be created)
      currentSegment.clear(); // Ensure clean start for new segment
    } else if (state == ExerciseState.ready) {
      // Exercise ended - clear all segments
      polylineSegments.clear();
      currentSegment.clear();
      segmentCounter = 0;
      _addSegmentedPathVisualization(); // Clear polylines from map
    }
  }

  /// Get current segment count (for debugging) - SAME AS MINI MAP
  int get totalSegments =>
      polylineSegments.length + (currentSegment.length >= 2 ? 1 : 0);

  /// Get total points in all segments (for debugging) - SAME AS MINI MAP
  int get totalSegmentPoints {
    int total = currentSegment.length;
    for (var segment in polylineSegments) {
      total += segment.length;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() {
          return EnhancedGoogleMap(
            markers: Set.of(controller.drawingMarkers),
            polylines: Set.of(controller.drawingPolylines),
            polygons: Set.of(controller.drawingPolygons),
            circles: Set.of(controller.drawingCircles),
            useCustomLocationLayer: true,
            // Enable custom location layer
            padding: EdgeInsets.only(top: 100.sp),
            minMaxZoomPreference: const MinMaxZoomPreference(8, 20),
            mapType: MapType.normal,
            indoorViewEnabled: true,
            mapToolbarEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(controller.currentLocation.value?.latitude ?? 31.5,
                  controller.currentLocation.value?.longitude ?? 34.4),
              zoom: 17,
            ),
            zoomGesturesEnabled: controller.isLockMap.isFalse,
            tiltGesturesEnabled: controller.isLockMap.isFalse,
            rotateGesturesEnabled: controller.isLockMap.isFalse,
            scrollGesturesEnabled: controller.isLockMap.isFalse,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
            onMapCreated: (mapController) {
              controller.challengeMapControllers.add(mapController);
              controller.addOverlayAll(
                {
                  if (controller.selectedCourse.value != null)
                    ...renderCircleOverlays(controller.selectedCourse.value),
                  if (controller.selectedCourse.value != null)
                    ...renderMarkers(controller.selectedCourse.value),
                },
              );

              // Enhanced segmented path visualization
              _addSegmentedPathVisualization();
            },
          );
        }),
        if (controller.selectedExerciseType.value ==
            ExerciseType.treasureHunting)
          Positioned(
            top: 65.sp,
            left: 0,
            right: 0,
            child: const CoolDownWidgetMap(),
          ),
        Positioned(
          top: 60.sp,
          left: 20.sp,
          child: GestureDetector(
            onTap: Get.back,
            child: Container(
              padding: EdgeInsets.all(6.sp),
              decoration: BoxDecoration(
                color: popupBgColor,
                border: Border.all(
                  width: 2.sp,
                  style: BorderStyle.solid,
                  color: Colors.black,
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(1.sp, 3.sp),
                    color: Colors.black,
                  ),
                ],
                borderRadius: BorderRadius.circular(14.sp),
              ),
              child: Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 30.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
