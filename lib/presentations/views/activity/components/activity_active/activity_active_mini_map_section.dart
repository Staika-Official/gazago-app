import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/activity_controller.dart';
import 'package:gaza_go/platform/controllers/global_controller.dart';
import 'package:gaza_go/platform/helpers/map_helper.dart';
import 'package:gaza_go/platform/helpers/segmented_polyline_helper.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/views/activity/components/activity_active/cool_down_widget.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class ActivityActiveMiniMapSection extends StatefulWidget {
  const ActivityActiveMiniMapSection({super.key});

  @override
  State<ActivityActiveMiniMapSection> createState() =>
      _ActivityActiveMiniMapSectionState();
}

class _ActivityActiveMiniMapSectionState extends State<ActivityActiveMiniMapSection> {
  final ActivityController controller = Get.find();
  final GlobalController globalController = Get.find();
  GoogleMapController? mapController;
  
  /// Debug print helper to avoid lint warnings
  void _debugPrint(String message) {
    // ignore: avoid_print
    print(message);
  }
  
  // Track segments for gap effect
  List<List<LatLng>> polylineSegments = [];
  List<LatLng> currentSegment = [];
  bool wasNetworkAvailable = true;
  int segmentCounter = 0;

  @override
  void dispose() {
    controller.challengeMapControllers.removeLast();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    
    // Listen to location updates from GPS directly for segmented polyline
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
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  width: 3,
                  color: Colors.black,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Obx(
                  () => GoogleMap(
                    markers: Set.of(controller.drawingMarkers),
                    polylines: Set.of(controller.drawingPolylines),
                    polygons: Set.of(controller.drawingPolygons),
                    circles: Set.of(controller.drawingCircles),
                    myLocationEnabled:
                        true, // Enable default user location marker (blue)
                    mapToolbarEnabled: false,
                    minMaxZoomPreference: const MinMaxZoomPreference(8, 20),
                    mapType: MapType.normal,
                    indoorViewEnabled: true,
                    myLocationButtonEnabled: false,
                    buildingsEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        controller.currentLocation.value?.latitude ?? 0.0,
                        controller.currentLocation.value?.longitude ?? 0.0,
                      ),
                      zoom: 17,
                    ),
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                      Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer(),
                      ),
                    },
                    onMapCreated: (googleMapController) {
                      mapController = googleMapController;
                      controller.challengeMapControllers
                          .add(googleMapController);
                      // mapController
                      //     .setLocationTrackingMode(NLocationTrackingMode.follow);
                      controller.addOverlayAll(
                        {
                          if (controller.selectedCourse.value != null)
                            ...renderCircleOverlays(
                                controller.selectedCourse.value),
                          if (controller.selectedCourse.value != null)
                            ...renderMarkers(controller.selectedCourse.value),
                        },
                      );

                      // Enhanced segmented path visualization
                      _addSegmentedPathVisualization();
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  controller.isLockMap.value = false;
                  controller.showExerciseMap();
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D2626).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: iconZoomOut,
                ),
              ),
            ),
            const CoolDownWidget(),

          ],
        ),
      ),
    );
  }

  /// Add segmented path visualization using SegmentedPolylineHelper
  void _addSegmentedPathVisualization() { 
    // Clear all existing segmented polylines using helper
    SegmentedPolylineHelper.clearSegmentedPolylines(
      controller.drawingPolylines.toList(),
      'mini_map',
      debugMode: true,
    );
    
    // Remove cleared polylines from controller
    controller.drawingPolylines.removeWhere((polyline) => 
      polyline.polylineId.value.startsWith('mini_map') ||
      polyline.polylineId.value.startsWith('path_segment_') ||
      polyline.polylineId.value == 'current_segment' ||
      polyline.polylineId.value.contains('segment'));
    
    // Use SegmentedPolylineHelper to render live segmented polylines
    List<Polyline> segmentedPolylines = SegmentedPolylineHelper.renderLiveSegmentedPolylines(
      completedSegments: polylineSegments,
      currentSegment: currentSegment,
      polylineIdPrefix: 'mini_map_live',
      color: Colors.blue,
      width: 4,
      debugMode: true,
    );
    
    // Add all segmented polylines to the map
    for (Polyline polyline in segmentedPolylines) {
      controller.addOverlay(polyline);
    }
  }

  /// Handle GPS location updates for segmented polyline (independent of controller.coordinates)
  void _handleGPSLocationUpdate(dynamic location) {
    if (mapController == null) {
      return;
    }
    
    // Extract LatLng from location (can be LocationModel or direct coordinates)
    LatLng newCoordinate;
    if (location is LatLng) {
      newCoordinate = location;
    } else {
      // Assume LocationModel with latitude/longitude properties
      newCoordinate = LatLng(location.latitude, location.longitude);
    }
    
    bool isNetworkAvailable = globalController.internetConnection.value;
    bool isExerciseOngoing = controller.exerciseState.value == ExerciseState.ongoing;
    
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
    // Always move camera to current location regardless of network/exercise status
    mapController!.animateCamera(
      CameraUpdate.newLatLng(newCoordinate),
    );
  }
  
  /// Handle network state changes for proper segmentation
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
  
  /// Handle network status changes - called from initState listener
  void _handleNetworkStatusChange(bool isConnected) {
    
    // Trigger network state change if different from current state
    if (isConnected != wasNetworkAvailable) {
      _handleNetworkStateChange(isConnected);
      wasNetworkAvailable = isConnected;
    }
  }
  
  /// Handle exercise state changes for pause gap effect
  void _handleExerciseStateChange(ExerciseState state) {
    
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
  
  /// Get current segment count (for debugging)
  int get totalSegments => polylineSegments.length + (currentSegment.length >= 2 ? 1 : 0);
  
  /// Get total points in all segments (for debugging)
  int get totalSegmentPoints {
    int total = currentSegment.length;
    for (var segment in polylineSegments) {
      total += segment.length;
    }
    return total;
  }
  
}
