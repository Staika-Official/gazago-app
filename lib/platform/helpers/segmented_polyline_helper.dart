import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Shared helper for rendering segmented polylines with gap effects
/// Used across ActivityMap, ArchiveDetail, and other map displays
class SegmentedPolylineHelper {
  
  /// Render segmented polylines from coordinates with network/pause gap detection
  /// 
  /// This analyzes the coordinates list and creates separate blue polyline segments
  /// based on timestamps and estimated gap periods
  static List<Polyline> renderSegmentedPolylines({
    required List<LatLng> coordinates,
    List<DateTime>? timestamps,
    int? exerciseId,
    String polylineIdPrefix = 'segment',
    Color color = Colors.blue,
    int width = 4,
    bool debugMode = false,
  }) {
    
    if (coordinates.length < 2) {
      return [];
    }
    
    List<Polyline> segmentedPolylines = [];
    List<List<LatLng>> segments = [];
    
    // If no timestamps provided, create segments by analyzing coordinate gaps
    if (timestamps == null) {
      segments = _createSegmentsFromCoordinateGaps(coordinates, debugMode);
    } else {
      // Use timestamps to detect network/pause gaps more accurately
      segments = _createSegmentsFromTimestamps(coordinates, timestamps, debugMode);
    }
    
    // Create polyline for each segment
    for (int i = 0; i < segments.length; i++) {
      if (segments[i].length >= 2) {
        segmentedPolylines.add(Polyline(
          polylineId: PolylineId('${polylineIdPrefix}_$i'),
          width: width,
          color: color,
          points: segments[i],
          patterns: const [], // Solid line
        ));
      }
    }
    
    return segmentedPolylines;
  }
  
  /// Create segments by analyzing coordinate distance gaps
  /// This is used when we don't have precise timestamp data
  static List<List<LatLng>> _createSegmentsFromCoordinateGaps(
    List<LatLng> coordinates, 
    bool debugMode
  ) { 
    List<List<LatLng>> segments = [];
    List<LatLng> currentSegment = [];
    
    const double maxGapDistance = 100.0; // meters - if gap > 100m, likely network/pause gap
    
    for (int i = 0; i < coordinates.length; i++) {
      LatLng currentCoord = coordinates[i];
      
      if (currentSegment.isEmpty) {
        // Start new segment
        currentSegment.add(currentCoord);
      } else {
        // Check distance from last coordinate
        LatLng lastCoord = currentSegment.last;
        double distance = _calculateDistance(lastCoord, currentCoord);
        
        if (distance > maxGapDistance) {
          // Large gap detected - finalize current segment and start new one
          if (currentSegment.length >= 2) {
            segments.add(List.from(currentSegment));
          }
          currentSegment = [currentCoord];
        } else {
          // Continue current segment
          currentSegment.add(currentCoord);
        }
      }
    }
    
    // Add final segment
    if (currentSegment.length >= 2) {
      segments.add(currentSegment);
    }
    
    // Fallback: if no gaps detected but route is long, create artificial segments for visual effect
    if (segments.length <= 1 && coordinates.length >= 20) {
      segments = _createArtificialSegments(coordinates, debugMode);
    }
    
    if (debugMode) {
      for (int i = 0; i < segments.length; i++) {
      }
    }
    
    return segments;
  }
  
  /// Create segments using timestamp analysis for more accurate gap detection
  static List<List<LatLng>> _createSegmentsFromTimestamps(
    List<LatLng> coordinates,
    List<DateTime> timestamps,
    bool debugMode
  ) {
    if (coordinates.length != timestamps.length) {
      return _createSegmentsFromCoordinateGaps(coordinates, debugMode);
    }
    
    List<List<LatLng>> segments = [];
    List<LatLng> currentSegment = [];
    
    const int maxGapSeconds = 300; // 5 minutes gap indicates network/pause issue
    
    for (int i = 0; i < coordinates.length; i++) {
      if (currentSegment.isEmpty) {
        currentSegment.add(coordinates[i]);
      } else {
        // Check time gap from last coordinate
        Duration timeDiff = timestamps[i].difference(timestamps[i - 1]);
        
        if (timeDiff.inSeconds > maxGapSeconds) {
          // Time gap detected - finalize current segment
          if (currentSegment.length >= 2) {
            segments.add(List.from(currentSegment));
          }
          currentSegment = [coordinates[i]];
        } else {
          currentSegment.add(coordinates[i]);
        }
      }
    }
    
    // Add final segment
    if (currentSegment.length >= 2) {
      segments.add(currentSegment);
    }
    
    return segments;
  }
  
  /// Create artificial segments for visual gap effect when no natural gaps exist
  static List<List<LatLng>> _createArtificialSegments(
    List<LatLng> coordinates,
    bool debugMode
  ) {
    List<List<LatLng>> artificialSegments = [];
    
    // Calculate total distance to determine segment strategy
    double totalDistance = 0;
    for (int i = 1; i < coordinates.length; i++) {
      totalDistance += _calculateDistance(coordinates[i-1], coordinates[i]);
    }
    
    
    // Strategy 1: For very long routes (>2km), create segments every ~500-800m
    if (totalDistance > 2000) {
      artificialSegments = _createDistanceBasedSegments(coordinates, 600, debugMode);
    }
    // Strategy 2: For medium routes (500m-2km), create 2-3 segments
    else if (totalDistance > 500) {
      int segmentCount = (totalDistance / 400).ceil().clamp(2, 3);
      artificialSegments = _createEqualSegments(coordinates, segmentCount, debugMode);
    }
    // Strategy 3: For short routes, create 2 segments
    else {
      artificialSegments = _createEqualSegments(coordinates, 2, debugMode);
    }
    
    return artificialSegments;
  }
  
  /// Create segments based on distance intervals
  static List<List<LatLng>> _createDistanceBasedSegments(
    List<LatLng> coordinates,
    double segmentDistance,
    bool debugMode
  ) {
    List<List<LatLng>> segments = [];
    List<LatLng> currentSegment = [coordinates[0]];
    double currentDistance = 0;
    
    for (int i = 1; i < coordinates.length; i++) {
      double stepDistance = _calculateDistance(coordinates[i-1], coordinates[i]);
      currentDistance += stepDistance;
      currentSegment.add(coordinates[i]);
      
      // Create new segment every segmentDistance meters
      if (currentDistance >= segmentDistance) {
        segments.add(List.from(currentSegment));
        currentSegment = [coordinates[i]]; // Start new segment with current point
        currentDistance = 0;
      }
    }
    
    // Add final segment if it has points
    if (currentSegment.length > 1) {
      segments.add(currentSegment);
    }
    
    return segments;
  }
  
  /// Create equal-sized segments
  static List<List<LatLng>> _createEqualSegments(
    List<LatLng> coordinates,
    int segmentCount,
    bool debugMode
  ) {
    List<List<LatLng>> segments = [];
    int pointsPerSegment = (coordinates.length / segmentCount).floor();
    
    for (int i = 0; i < segmentCount; i++) {
      int startIdx = i * pointsPerSegment;
      int endIdx = (i == segmentCount - 1) 
          ? coordinates.length 
          : (i + 1) * pointsPerSegment + 1; // +1 for overlap
          
      if (startIdx < coordinates.length) {
        List<LatLng> segment = coordinates.sublist(startIdx, endIdx.clamp(0, coordinates.length));
        if (segment.length >= 2) {
          segments.add(segment);
        }
      }
    }
    
    return segments;
  }

  /// Calculate distance between two LatLng points in meters using Haversine formula
  static double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000; // meters
    
    double lat1Rad = point1.latitude * pi / 180;
    double lat2Rad = point2.latitude * pi / 180;
    double deltaLatRad = (point2.latitude - point1.latitude) * pi / 180;
    double deltaLngRad = (point2.longitude - point1.longitude) * pi / 180;
    
    double a = sin(deltaLatRad / 2) * sin(deltaLatRad / 2) +
        cos(lat1Rad) * cos(lat2Rad) *
        sin(deltaLngRad / 2) * sin(deltaLngRad / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadius * c;
  }
  
  /// Render live segmented polylines for ongoing exercise
  /// This version gets segments from ActivityController's current segmented state
  static List<Polyline> renderLiveSegmentedPolylines({
    required List<List<LatLng>> completedSegments,
    required List<LatLng> currentSegment,
    String polylineIdPrefix = 'live_segment',
    Color color = Colors.blue,
    int width = 4,
    bool debugMode = false,
  }) {
    
    List<Polyline> polylines = [];
    
    // Add completed segments
    for (int i = 0; i < completedSegments.length; i++) {
      if (completedSegments[i].length >= 2) {
        polylines.add(Polyline(
          polylineId: PolylineId('${polylineIdPrefix}_completed_$i'),
          width: width,
          color: color,
          points: completedSegments[i],
          patterns: const [],
        ));
      }
    }
    
    // Add current active segment
    if (currentSegment.length >= 2) {
      polylines.add(Polyline(
        polylineId: PolylineId('${polylineIdPrefix}_current'),
        width: width,
        color: color,
        points: currentSegment,
        patterns: const [],
      ));
    }
    return polylines;
  }
  
  /// Utility method to clear segmented polylines from a list
  static void clearSegmentedPolylines(
    List<Polyline> drawingPolylines, 
    String polylineIdPrefix,
    {bool debugMode = false}
  ) {
    int removedCount = 0;
    drawingPolylines.removeWhere((polyline) {
      bool shouldRemove = polyline.polylineId.value.startsWith(polylineIdPrefix) ||
                          polyline.polylineId.value.contains('segment') ||
                          polyline.polylineId.value == 'path' ||
                          polyline.polylineId.value == 'detail_path' ||
                          polyline.polylineId.value == 'detail path';
      if (shouldRemove) removedCount++;
      return shouldRemove;
    });
    
    if (removedCount > 0) {}
  }
  
  /// Helper method to add all segments to a polyline list
  static void addSegmentedPolylinesTo(
    List<Polyline> targetList,
    List<Polyline> segmentedPolylines,
    {bool debugMode = false}
  ) {
    targetList.addAll(segmentedPolylines);
  }
}
