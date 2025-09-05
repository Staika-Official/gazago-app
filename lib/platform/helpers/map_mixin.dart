import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

mixin MapMixin {
  RxList<Marker> drawingMarkers = RxList<Marker>();
  RxList<Polyline> drawingPolylines = RxList<Polyline>();
  RxList<Polygon> drawingPolygons = RxList<Polygon>();
  RxList<Circle> drawingCircles = RxList<Circle>();

  List<dynamic> getMyLocationMarker() {
    return [
      drawingMarkers
          .firstWhereOrNull((m) => m.markerId.value == 'user_location'),
      drawingCircles.firstWhereOrNull(
          (m) => m.circleId.value == 'accuracy_radius_native'),
    ]..removeWhere((element) => element == null);
  }

  void clearMarkers() => drawingMarkers.clear();

  void clearCircles() => drawingCircles.clear();

  void updateMarkerById(Marker newMarker) {
    final index = drawingMarkers.indexWhere(
      (m) => m.markerId.value == newMarker.markerId.value,
    );

    if (index != -1) {
      drawingMarkers[index] = newMarker;
      drawingMarkers.refresh();
    }
  }

  /// Update or insert a circle (replace-by-id for smooth updates)
  void updateOrInsertCircle(Circle newCircle) {
    final index = drawingCircles
        .indexWhere((c) => c.circleId.value == newCircle.circleId.value);

    if (index != -1) {
      // Update existing circle
      drawingCircles[index] = newCircle;
      drawingCircles.refresh();
    } else {
      // Insert new circle
      drawingCircles.add(newCircle);
      drawingCircles.refresh();
    }
  }

  void removeMarkerById(int id) {
    final index = drawingMarkers.indexWhere(
      (m) => m.markerId.value == id.toString(),
    );
    drawingMarkers.removeAt(index);
  }

  void clearOverlays() {
    drawingMarkers.clear();
    drawingPolylines.clear();
    drawingPolygons.clear();
  }

  void addOverlayAll(Iterable<dynamic> mapsObjects) {
    for (dynamic mapObject in mapsObjects) {
      addOverlay(mapObject);
    }
  }

  void addOverlay(dynamic mapObject) {
    if (mapObject is Marker) {
      drawingMarkers.value = [...drawingMarkers, mapObject];
    } else if (mapObject is Polyline) {
      drawingPolylines.value = [...drawingPolylines, mapObject];
    } else if (mapObject is Polygon) {
      drawingPolygons.value = [...drawingPolygons, mapObject];
    } else if (mapObject is Circle) {
      drawingCircles.value = [...drawingCircles, mapObject];
    }
  }
}
