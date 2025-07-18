import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

mixin MapMixin {
  RxList<Marker> drawingMarkers = RxList<Marker>();
  RxList<Polyline> drawingPolylines = RxList<Polyline>();
  RxList<Polygon> drawingPolygons = RxList<Polygon>();
  RxList<Circle> drawingCircles = RxList<Circle>();

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
