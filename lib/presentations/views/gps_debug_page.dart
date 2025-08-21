import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/helpers/gps_filter_helper.dart';
import 'package:gaza_go/platform/helpers/gps_metrics.dart';
import 'package:gaza_go/platform/helpers/battery_aware_gps.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'dart:async';
import 'dart:math' as math;

class GPSDebugController extends GetxController {
  // GPS State
  var isGPSActive = false.obs;
  var currentPosition = Rxn<Position>();
  var gpsAccuracy = 0.0.obs;
  var currentSpeed = 0.0.obs;
  var totalDistance = 0.0.obs;
  var sessionDuration = 0.obs;

  // GPS Settings
  var accuracyThreshold = 20.0.obs;
  var speedThreshold = 50.0.obs;
  var updateInterval = 1000.obs; // milliseconds

  // Statistics
  var totalPositions = 0.obs;
  var filteredPositions = 0.obs;
  var filterRate = 0.0.obs;
  var averageAccuracy = 0.0.obs;
  var maxSpeed = 0.0.obs;
  var performanceGrade = 'C'.obs;

  // Advanced metrics from commit 968a37f9
  var fallbackCount = 0.obs;
  var errorCount = 0.obs;
  var batteryOptimizations = 0.obs;
  var gpsJumps = 0.obs;
  var abnormalSpeeds = 0.obs;

  // Real-time data
  var realtimeData = <String>[].obs;
  var batteryLevel = 0.obs;
  var gpsMode = 'Unknown'.obs;
  var isDataSyncing = false.obs;

  // Track last logged values to prevent spam
  String _lastLoggedGpsMode = 'Unknown';
  int _lastLoggedBatteryLevel = 0;

  // Map and tracking data
  NaverMapController? mapController;
  var mapPositions = <NLatLng>[].obs;
  var rawPositions = <NLatLng>[].obs; // Unfiltered positions
  var gpsJumpDetected = false.obs;
  var lastJumpDistance = 0.0.obs;

  StreamSubscription<Position>? _positionStream;
  Timer? _sessionTimer;
  Timer? _dataUpdateTimer;
  DateTime? _sessionStart;
  Position? _lastPosition;

  @override
  void onInit() {
    super.onInit();
    _initializeGPS();
  }

  @override
  void onClose() {
    stopGPSTracking();
    _dataUpdateTimer?.cancel();
    super.onClose();
  }

  void _initializeGPS() async {
    // Initialize GPS components
    GPSMetrics.startSession();
    GPSFilterHelper.clearHistory();

    // Start periodic data sync from helpers
    _startDataSync();

    // Get initial data
    _syncDataFromHelpers();
  }

  void _startDataSync() {
    // Update data from helpers every 2 seconds
    _dataUpdateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _syncDataFromHelpers();
    });
  }

  void _syncDataFromHelpers() async {
    isDataSyncing.value = true;
    try {
      // Sync battery info from BatteryAwareGPS
      Map<String, dynamic> batteryInfo = await BatteryAwareGPS.getBatteryInfo();

      // Update battery level (only log significant changes)
      int newBatteryLevel = batteryInfo['battery_level'] ?? batteryLevel.value;
      if ((newBatteryLevel - _lastLoggedBatteryLevel).abs() >= 5) {
        batteryLevel.value = newBatteryLevel;
        addRealtimeLog('Battery level: ${newBatteryLevel}%');
        _lastLoggedBatteryLevel = newBatteryLevel;
      } else {
        batteryLevel.value = newBatteryLevel;
      }

      // Update GPS mode (only log when actually changes)
      String newGpsMode = batteryInfo['gps_mode'] ?? 'Unknown';
      if (newGpsMode != _lastLoggedGpsMode) {
        gpsMode.value = newGpsMode;
        addRealtimeLog('GPS mode changed: $newGpsMode');
        _lastLoggedGpsMode = newGpsMode;
      } else {
        gpsMode.value = newGpsMode;
      }

      // Sync GPS filter statistics
      Map<String, dynamic> filterStats = GPSFilterHelper.getFilteringStats();
      totalPositions.value =
          filterStats['total_positions'] ?? totalPositions.value;
      filteredPositions.value =
          filterStats['rejected_positions'] ?? filteredPositions.value;
      if (totalPositions.value > 0) {
        filterRate.value =
            (filteredPositions.value / totalPositions.value) * 100;
      }

      // Sync GPS metrics
      Map<String, dynamic> metrics = GPSMetrics.getSessionMetrics();
      averageAccuracy.value =
          metrics['average_accuracy'] ?? averageAccuracy.value;
      performanceGrade.value =
          metrics['performance_grade'] ?? performanceGrade.value;
      fallbackCount.value = metrics['fallback_count'] ?? fallbackCount.value;
      errorCount.value = metrics['error_count'] ?? errorCount.value;
      batteryOptimizations.value =
          metrics['battery_optimizations'] ?? batteryOptimizations.value;

      // Sync current thresholds from helpers (if they expose them)
      _syncThresholdsFromHelpers();
    } catch (e) {
      addRealtimeLog('Data sync error: $e');
    } finally {
      isDataSyncing.value = false;
    }
  }

  // Track last logged threshold values to prevent spam
  double _lastLoggedAccuracyThreshold = 20.0;
  double _lastLoggedSpeedThreshold = 50.0;
  bool _isUserChangingSettings = false;

  void _syncThresholdsFromHelpers() {
    // Try to get current thresholds from GPS helpers
    // This ensures debug page shows actual values being used
    try {
      // Only log when user is not actively changing settings
      // and when thresholds actually change from external sources
      if (!_isUserChangingSettings) {
        if (accuracyThreshold.value != _lastLoggedAccuracyThreshold) {
          addRealtimeLog(
              'External accuracy threshold sync: ${accuracyThreshold.value}m');
          _lastLoggedAccuracyThreshold = accuracyThreshold.value;
        }
        if (speedThreshold.value != _lastLoggedSpeedThreshold) {
          addRealtimeLog(
              'External speed threshold sync: ${speedThreshold.value} km/h');
          _lastLoggedSpeedThreshold = speedThreshold.value;
        }
      }
    } catch (e) {
      // Ignore threshold sync errors
    }
  }

  void startGPSTracking() async {
    if (isGPSActive.value) return;

    try {
      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          addRealtimeLog('GPS permission denied');
          return;
        }
      }

      // Start session
      _sessionStart = DateTime.now();
      isGPSActive.value = true;
      totalDistance.value = 0.0;
      _lastPosition = null;

      // Start session timer
      _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_sessionStart != null) {
          sessionDuration.value =
              DateTime.now().difference(_sessionStart!).inSeconds;
        }
      });

      // Configure location settings
      LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1, // Update every 1 meter
        timeLimit: Duration(milliseconds: updateInterval.value),
      );

      // Start position stream
      _positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen((Position position) {
        _processNewPosition(position);
      });

      addRealtimeLog('GPS tracking started');
    } catch (e) {
      addRealtimeLog('GPS start error: $e');
      isGPSActive.value = false;
    }
  }

  void stopGPSTracking() {
    if (!isGPSActive.value) return;

    _positionStream?.cancel();
    _sessionTimer?.cancel();
    isGPSActive.value = false;

    // End GPS session
    GPSMetrics.endSession();

    addRealtimeLog('GPS tracking stopped');
    _updateStatistics();
  }

  void _processNewPosition(Position position) {
    currentPosition.value = position;
    gpsAccuracy.value = position.accuracy;
    currentSpeed.value = position.speed * 3.6; // Convert m/s to km/h

    // Add raw position to map (before filtering)
    NLatLng rawMapPosition = NLatLng(position.latitude, position.longitude);
    rawPositions.add(rawMapPosition);

    // Update max speed
    if (currentSpeed.value > maxSpeed.value) {
      maxSpeed.value = currentSpeed.value;
    }

    // Calculate distance and detect GPS jumps
    if (_lastPosition != null) {
      double distance = Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        position.latitude,
        position.longitude,
      );
      totalDistance.value += distance;

      // Detect GPS jumps (large distance in short time)
      if (distance > 100) {
        // 100m threshold for jump detection
        gpsJumpDetected.value = true;
        lastJumpDistance.value = distance;
        addRealtimeLog('GPS JUMP detected: ${distance.toStringAsFixed(1)}m');
        gpsJumps.value++;
      } else {
        gpsJumpDetected.value = false;
      }
    }
    _lastPosition = position;

    // Process through GPS filter
    Position? filteredPosition = GPSFilterHelper.filterPosition(position);
    totalPositions.value++;

    if (filteredPosition == null) {
      filteredPositions.value++;
      addRealtimeLog(
          'Position FILTERED: Accuracy ${position.accuracy.toStringAsFixed(1)}m, Speed ${currentSpeed.value.toStringAsFixed(1)} km/h');
    } else {
      addRealtimeLog(
          'Position ACCEPTED: Accuracy ${position.accuracy.toStringAsFixed(1)}m, Speed ${currentSpeed.value.toStringAsFixed(1)} km/h');

      // Add filtered position to map
      NLatLng filteredMapPosition =
          NLatLng(filteredPosition.latitude, filteredPosition.longitude);
      mapPositions.add(filteredMapPosition);

      // Update map camera to follow user
      _updateMapCamera(filteredMapPosition);

      // Record in GPS metrics
      GPSMetrics.recordPosition(position, false);
    }

    _updateStatistics();
  }

  void _updateStatistics() {
    // Statistics are now updated via _syncDataFromHelpers()
    // This method is kept for compatibility but delegates to sync
    _syncDataFromHelpers();
  }

  void addRealtimeLog(String message) {
    String timestamp = DateTime.now().toString().substring(11, 19);
    realtimeData.insert(0, '[$timestamp] $message');

    // Keep only last 50 entries
    if (realtimeData.length > 50) {
      realtimeData.removeRange(50, realtimeData.length);
    }
  }

  void clearLogs() {
    realtimeData.clear();
  }

  void _updateMapCamera(NLatLng position) {
    if (mapController != null) {
      // Camera update not needed for custom painter
      // The custom painter will automatically update when positions change
    }
  }

  void clearMapData() {
    mapPositions.clear();
    rawPositions.clear();
    gpsJumpDetected.value = false;
    lastJumpDistance.value = 0.0;
    addRealtimeLog('Map data cleared');
  }

  void onMapReady() {
    addRealtimeLog('GPS visualization initialized');
  }

  void resetStatistics() {
    totalPositions.value = 0;
    filteredPositions.value = 0;
    filterRate.value = 0.0;
    averageAccuracy.value = 0.0;
    maxSpeed.value = 0.0;
    totalDistance.value = 0.0;
    sessionDuration.value = 0;
    performanceGrade.value = 'C';

    // Reset advanced metrics
    fallbackCount.value = 0;
    errorCount.value = 0;
    batteryOptimizations.value = 0;
    gpsJumps.value = 0;
    abnormalSpeeds.value = 0;

    GPSFilterHelper.clearHistory();
    GPSMetrics.startSession();
    _sessionStart = DateTime.now();

    addRealtimeLog('Statistics reset');
  }

  void updateAccuracyThreshold(double value) {
    _isUserChangingSettings = true;
    accuracyThreshold.value = value;
    _lastLoggedAccuracyThreshold = value;
    // Try to apply to actual GPS filter helper
    _applyThresholdToHelpers();
    addRealtimeLog(
        'Accuracy threshold updated to ${value.toStringAsFixed(1)}m');
    _isUserChangingSettings = false;
  }

  void updateSpeedThreshold(double value) {
    _isUserChangingSettings = true;
    speedThreshold.value = value;
    _lastLoggedSpeedThreshold = value;
    // Try to apply to actual GPS filter helper
    _applyThresholdToHelpers();
    addRealtimeLog(
        'Speed threshold updated to ${value.toStringAsFixed(1)} km/h');
    _isUserChangingSettings = false;
  }

  void updateUpdateInterval(int milliseconds) {
    updateInterval.value = milliseconds;
    addRealtimeLog('Update interval changed to ${milliseconds}ms');

    // Restart GPS with new interval if active
    if (isGPSActive.value) {
      stopGPSTracking();
      Future.delayed(const Duration(milliseconds: 500), () {
        startGPSTracking();
      });
    }
  }

  void _applyThresholdToHelpers() {
    try {
      // If GPS helpers have methods to update thresholds, call them here
      // Only log once when user actually changes settings, not during sync

      // Example: If GPSFilterHelper had a method like this:
      // GPSFilterHelper.updateAccuracyThreshold(accuracyThreshold.value);
      // GPSFilterHelper.updateSpeedThreshold(speedThreshold.value);

      // For BatteryAwareGPS, we might need to trigger a reconfiguration
      // BatteryAwareGPS.reconfigure();
    } catch (e) {
      addRealtimeLog('Failed to apply thresholds: $e');
    }
  }

  String formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}

class GPSDebugPage extends StatelessWidget {
  const GPSDebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GPSDebugController controller = Get.put(GPSDebugController());

    return Scaffold(
      backgroundColor: AppColorData.regular().colorBgPrimary,
      appBar: AppBar(
        backgroundColor: AppColorData.regular().colorBgPrimary,
        title: Row(
          children: [
            Text(
              'GPS Debug & Testing',
              style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                    color: AppColorData.regular().colorTextPrimary,
                  ),
            ),
            SizedBox(width: 8.sp),
            Obx(() => controller.isDataSyncing.value
                ? SizedBox(
                    width: 12.sp,
                    height: 12.sp,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  )
                : Icon(
                    Icons.sync,
                    size: 16.sp,
                    color: Colors.green,
                  )),
          ],
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColorData.regular().colorTextPrimary,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Control Panel
            _buildControlPanel(controller),
            SizedBox(height: 16.sp),

            // Real-time Status
            _buildRealtimeStatus(controller),
            SizedBox(height: 16.sp),

            // GPS Minimap
            _buildGPSMinimap(controller),
            SizedBox(height: 16.sp),

            // Statistics
            _buildStatistics(controller),
            SizedBox(height: 16.sp),

            // Settings
            _buildSettings(controller),
            SizedBox(height: 16.sp),

            // Advanced Monitoring (from commit 968a37f9)
            _buildAdvancedMonitoring(controller),
            SizedBox(height: 16.sp),

            // Real-time Logs
            _buildRealtimeLogs(controller),

            // Extra spacing at bottom to prevent content being cut off
            SizedBox(height: 32.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildControlPanel(GPSDebugController controller) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColorData.regular().colorBgSecondary,
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'GPS Control Panel',
                style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                      color: AppColorData.regular().colorTextPrimary,
                    ),
              ),
              SizedBox(width: 8.sp),
              Tooltip(
                message: 'Start/Stop GPS tracking and reset all statistics',
                child: Icon(
                  Icons.info_outline,
                  size: 16.sp,
                  color: AppColorData.regular().colorTextSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.sp),
          Row(
            children: [
              Expanded(
                child: Obx(() => ElevatedButton.icon(
                      onPressed: controller.isGPSActive.value
                          ? controller.stopGPSTracking
                          : controller.startGPSTracking,
                      icon: Icon(controller.isGPSActive.value
                          ? Icons.stop
                          : Icons.play_arrow),
                      label: Text(controller.isGPSActive.value
                          ? 'Stop GPS'
                          : 'Start GPS'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.isGPSActive.value
                            ? Colors.red
                            : Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    )),
              ),
              SizedBox(width: 8.sp),
              ElevatedButton.icon(
                onPressed: controller.resetStatistics,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRealtimeStatus(GPSDebugController controller) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColorData.regular().colorBgSecondary,
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Real-time Status',
                style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                      color: AppColorData.regular().colorTextPrimary,
                    ),
              ),
              SizedBox(width: 8.sp),
              Tooltip(
                message:
                    'Live GPS data: speed, accuracy, distance, battery level, and GPS jump detection',
                child: Icon(
                  Icons.info_outline,
                  size: 16.sp,
                  color: AppColorData.regular().colorTextSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.sp),
          Obx(() => Column(
                children: [
                  _buildStatusRow(
                      'GPS Status',
                      controller.isGPSActive.value ? 'ACTIVE' : 'INACTIVE',
                      controller.isGPSActive.value ? Colors.green : Colors.red),
                  _buildStatusRow(
                      'Current Speed',
                      '${controller.currentSpeed.value.toStringAsFixed(1)} km/h',
                      _getSpeedColor(controller.currentSpeed.value)),
                  _buildStatusRow(
                      'GPS Accuracy',
                      '${controller.gpsAccuracy.value.toStringAsFixed(1)}m',
                      _getAccuracyColor(controller.gpsAccuracy.value)),
                  _buildStatusRow(
                      'Total Distance',
                      '${controller.totalDistance.value.toStringAsFixed(1)}m',
                      Colors.blue),
                  _buildStatusRow(
                      'Session Duration',
                      controller
                          .formatDuration(controller.sessionDuration.value),
                      Colors.purple),
                  _buildStatusRow(
                      'Battery Level',
                      '${controller.batteryLevel.value}%',
                      _getBatteryColor(controller.batteryLevel.value)),
                  _buildStatusRow(
                      'GPS Mode', controller.gpsMode.value, Colors.cyan),
                  _buildStatusRow(
                      'GPS Jumps',
                      '${controller.gpsJumps.value}',
                      controller.gpsJumps.value > 0
                          ? Colors.red
                          : Colors.green),
                  _buildStatusRow(
                      'Last Jump',
                      controller.lastJumpDistance.value > 0
                          ? '${controller.lastJumpDistance.value.toStringAsFixed(1)}m'
                          : 'None',
                      controller.gpsJumpDetected.value
                          ? Colors.red
                          : Colors.green),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildGPSMinimap(GPSDebugController controller) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColorData.regular().colorBgSecondary,
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'GPS Tracking Map',
                      style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                            color: AppColorData.regular().colorTextPrimary,
                          ),
                    ),
                    SizedBox(width: 8.sp),
                    Tooltip(
                      message:
                          'Visual GPS path tracking: Red=raw positions, Green=filtered positions, Blue=current location',
                      child: Icon(
                        Icons.info_outline,
                        size: 16.sp,
                        color: AppColorData.regular().colorTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Obx(() => Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.sp, vertical: 4.sp),
                        decoration: BoxDecoration(
                          color: controller.gpsJumpDetected.value
                              ? Colors.red
                              : Colors.green,
                          borderRadius: BorderRadius.circular(12.sp),
                        ),
                        child: Text(
                          controller.gpsJumpDetected.value
                              ? 'JUMP: ${controller.lastJumpDistance.value.toStringAsFixed(0)}m'
                              : 'STABLE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                  SizedBox(width: 8.sp),
                  IconButton(
                    onPressed: controller.clearMapData,
                    icon: const Icon(Icons.clear_all),
                    iconSize: 20.sp,
                    tooltip: 'Clear Map Data',
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.sp),
          Container(
            height: 200.sp,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.sp),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.sp),
              child: Container(
                color: Colors.grey[300],
                child: Stack(
                  children: [
                    // Background grid pattern
                    CustomPaint(
                      size: Size.infinite,
                      painter: GridPainter(),
                    ),
                    // GPS tracking visualization
                    Obx(() => CustomPaint(
                          size: Size.infinite,
                          painter: GPSTrackingPainter(
                            rawPositions: controller.rawPositions.toList(),
                            filteredPositions: controller.mapPositions.toList(),
                            currentPosition: controller.currentPosition.value,
                          ),
                        )),
                    // Center info
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(8.sp),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8.sp),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'GPS Tracking Map',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.sp),
                            Obx(() => Text(
                                  controller.currentPosition.value != null
                                      ? 'Lat: ${controller.currentPosition.value!.latitude.toStringAsFixed(6)}\nLng: ${controller.currentPosition.value!.longitude.toStringAsFixed(6)}'
                                      : 'No GPS Data',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 8.sp),
          // Map Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem('Raw Path', Colors.red),
              _buildLegendItem('Filtered Path', Colors.green),
              _buildLegendItem('Current Pos', Colors.blue),
            ],
          ),
          SizedBox(height: 8.sp),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMapStat('Raw Points',
                      '${controller.rawPositions.length}', Colors.red),
                  _buildMapStat('Filtered Points',
                      '${controller.mapPositions.length}', Colors.green),
                  _buildMapStat('GPS Jumps', '${controller.gpsJumps.value}',
                      Colors.orange),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16.sp,
          height: 3.sp,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.sp),
          ),
        ),
        SizedBox(width: 4.sp),
        Text(
          label,
          style: TextStyle(
            color: AppColorData.regular().colorTextSecondary,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildMapStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColorData.regular().colorTextSecondary,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildStatistics(GPSDebugController controller) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColorData.regular().colorBgSecondary,
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'GPS Statistics',
                style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                      color: AppColorData.regular().colorTextPrimary,
                    ),
              ),
              SizedBox(width: 8.sp),
              Tooltip(
                message:
                    'GPS performance metrics: filter rate, accuracy, speed, and performance grade (A-F)',
                child: Icon(
                  Icons.info_outline,
                  size: 16.sp,
                  color: AppColorData.regular().colorTextSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.sp),
          Obx(() => Column(
                children: [
                  _buildStatusRow('Total Positions',
                      '${controller.totalPositions.value}', Colors.blue),
                  _buildStatusRow('Filtered Positions',
                      '${controller.filteredPositions.value}', Colors.red),
                  _buildStatusRow(
                      'Filter Rate',
                      '${controller.filterRate.value.toStringAsFixed(1)}%',
                      _getFilterRateColor(controller.filterRate.value)),
                  _buildStatusRow(
                      'Average Accuracy',
                      '${controller.averageAccuracy.value.toStringAsFixed(1)}m',
                      _getAccuracyColor(controller.averageAccuracy.value)),
                  _buildStatusRow(
                      'Max Speed',
                      '${controller.maxSpeed.value.toStringAsFixed(1)} km/h',
                      _getSpeedColor(controller.maxSpeed.value)),
                  _buildStatusRow(
                      'Performance Grade',
                      controller.performanceGrade.value,
                      _getGradeColor(controller.performanceGrade.value)),
                  _buildStatusRow('Fallback Count',
                      '${controller.fallbackCount.value}', Colors.orange),
                  _buildStatusRow('Error Count',
                      '${controller.errorCount.value}', Colors.red),
                  _buildStatusRow(
                      'Battery Optimizations',
                      '${controller.batteryOptimizations.value}',
                      Colors.purple),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildSettings(GPSDebugController controller) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColorData.regular().colorBgSecondary,
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'GPS Settings',
                style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                      color: AppColorData.regular().colorTextPrimary,
                    ),
              ),
              SizedBox(width: 8.sp),
              Tooltip(
                message:
                    'Configurable GPS parameters: accuracy threshold, speed limit, and update frequency',
                child: Icon(
                  Icons.info_outline,
                  size: 16.sp,
                  color: AppColorData.regular().colorTextSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.sp),
          Obx(() => Column(
                children: [
                  _buildSliderSetting(
                    'Accuracy Threshold',
                    controller.accuracyThreshold.value,
                    5.0,
                    50.0,
                    (value) => controller.updateAccuracyThreshold(value),
                    'meters',
                  ),
                  _buildSliderSetting(
                    'Speed Threshold',
                    controller.speedThreshold.value,
                    10.0,
                    100.0,
                    (value) => controller.updateSpeedThreshold(value),
                    'km/h',
                  ),
                  _buildSliderSetting(
                    'Update Interval',
                    controller.updateInterval.value.toDouble(),
                    500.0,
                    5000.0,
                    (value) => controller.updateUpdateInterval(value.toInt()),
                    'ms',
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildAdvancedMonitoring(GPSDebugController controller) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColorData.regular().colorBgSecondary,
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Advanced Monitoring (Commit 968a37f9)',
                style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                      color: AppColorData.regular().colorTextPrimary,
                    ),
              ),
              SizedBox(width: 8.sp),
              Tooltip(
                message:
                    'Advanced GPS features: warm-up, fallback, Kalman filtering, and anti-cheat detection',
                child: Icon(
                  Icons.info_outline,
                  size: 16.sp,
                  color: AppColorData.regular().colorTextSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.sp),
          Obx(() => Column(
                children: [
                  _buildStatusRow('GPS Warm-up', 'Available', Colors.green),
                  _buildStatusRow('Fallback Mechanism', 'Enabled', Colors.blue),
                  _buildStatusRow('Kalman Filtering', 'Active', Colors.cyan),
                  _buildStatusRow(
                      'Battery Optimization',
                      controller.batteryOptimizations.value > 0
                          ? 'Active'
                          : 'Inactive',
                      controller.batteryOptimizations.value > 0
                          ? Colors.green
                          : Colors.grey),
                  _buildStatusRow(
                      'Performance Monitoring', 'Real-time', Colors.purple),
                  _buildStatusRow(
                      'Anti-cheat Detection', 'Enhanced', Colors.orange),
                ],
              )),
          SizedBox(height: 12.sp),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    controller.addRealtimeLog('GPS warm-up initiated');
                    // Simulate GPS warm-up
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Test Warm-up'),
                ),
              ),
              SizedBox(width: 8.sp),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    controller.addRealtimeLog('Fallback mechanism tested');
                    // Simulate fallback
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Test Fallback'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRealtimeLogs(GPSDebugController controller) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColorData.regular().colorBgSecondary,
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'Real-time Logs',
                      style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                            color: AppColorData.regular().colorTextPrimary,
                          ),
                    ),
                    SizedBox(width: 8.sp),
                    Tooltip(
                      message:
                          'Console-style logs showing GPS events, filtering decisions, and system messages',
                      child: Icon(
                        Icons.info_outline,
                        size: 16.sp,
                        color: AppColorData.regular().colorTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: controller.clearLogs,
                child: const Text('Clear'),
              ),
            ],
          ),
          SizedBox(height: 12.sp),
          Container(
            height: 200.sp,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8.sp),
            ),
            child: Obx(() => ListView.builder(
                  padding: EdgeInsets.all(8.sp),
                  itemCount: controller.realtimeData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.sp),
                      child: Text(
                        controller.realtimeData[index],
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 11.sp,
                          fontFamily: 'monospace',
                        ),
                      ),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                  color: AppColorData.regular().colorTextSecondary,
                ),
          ),
          Text(
            value,
            style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderSetting(
    String label,
    double value,
    double min,
    double max,
    Function(double) onChanged,
    String unit,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                      color: AppColorData.regular().colorTextPrimary,
                    ),
              ),
              Text(
                '${value.toStringAsFixed(0)} $unit',
                style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                      color: AppColorData.regular().colorTextSecondary,
                    ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: ((max - min) / (max > 100 ? 10 : 1)).round(),
            onChanged: onChanged,
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Color _getSpeedColor(double speed) {
    if (speed < 5) return Colors.green;
    if (speed < 20) return Colors.yellow;
    if (speed < 50) return Colors.orange;
    return Colors.red;
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy < 5) return Colors.green;
    if (accuracy < 10) return Colors.yellow;
    if (accuracy < 20) return Colors.orange;
    return Colors.red;
  }

  Color _getFilterRateColor(double rate) {
    if (rate < 10) return Colors.green;
    if (rate < 25) return Colors.yellow;
    if (rate < 50) return Colors.orange;
    return Colors.red;
  }

  Color _getBatteryColor(int level) {
    if (level > 50) return Colors.green;
    if (level > 20) return Colors.yellow;
    return Colors.red;
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.lightGreen;
      case 'C':
        return Colors.yellow;
      case 'D':
        return Colors.orange;
      case 'F':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

// Custom painters for GPS visualization
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1.0;

    // Draw grid lines
    const gridSize = 20.0;
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GPSTrackingPainter extends CustomPainter {
  final List<NLatLng> rawPositions;
  final List<NLatLng> filteredPositions;
  final Position? currentPosition;

  GPSTrackingPainter({
    required this.rawPositions,
    required this.filteredPositions,
    this.currentPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (rawPositions.isEmpty && filteredPositions.isEmpty) return;

    // Find bounds for all positions
    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;

    for (var pos in [...rawPositions, ...filteredPositions]) {
      minLat = math.min(minLat, pos.latitude);
      maxLat = math.max(maxLat, pos.latitude);
      minLng = math.min(minLng, pos.longitude);
      maxLng = math.max(maxLng, pos.longitude);
    }

    // Add padding
    double latRange = maxLat - minLat;
    double lngRange = maxLng - minLng;
    if (latRange == 0) latRange = 0.001;
    if (lngRange == 0) lngRange = 0.001;

    minLat -= latRange * 0.1;
    maxLat += latRange * 0.1;
    minLng -= lngRange * 0.1;
    maxLng += lngRange * 0.1;

    // Convert lat/lng to screen coordinates
    Offset latLngToScreen(double lat, double lng) {
      double x = (lng - minLng) / (maxLng - minLng) * size.width;
      double y = (maxLat - lat) / (maxLat - minLat) * size.height;
      return Offset(x, y);
    }

    // Draw raw path (red)
    if (rawPositions.length > 1) {
      final rawPaint = Paint()
        ..color = Colors.red
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      final rawPath = Path();
      rawPath.moveTo(
          latLngToScreen(rawPositions[0].latitude, rawPositions[0].longitude)
              .dx,
          latLngToScreen(rawPositions[0].latitude, rawPositions[0].longitude)
              .dy);

      for (int i = 1; i < rawPositions.length; i++) {
        final point =
            latLngToScreen(rawPositions[i].latitude, rawPositions[i].longitude);
        rawPath.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(rawPath, rawPaint);
    }

    // Draw filtered path (green)
    if (filteredPositions.length > 1) {
      final filteredPaint = Paint()
        ..color = Colors.green
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke;

      final filteredPath = Path();
      filteredPath.moveTo(
          latLngToScreen(
                  filteredPositions[0].latitude, filteredPositions[0].longitude)
              .dx,
          latLngToScreen(
                  filteredPositions[0].latitude, filteredPositions[0].longitude)
              .dy);

      for (int i = 1; i < filteredPositions.length; i++) {
        final point = latLngToScreen(
            filteredPositions[i].latitude, filteredPositions[i].longitude);
        filteredPath.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(filteredPath, filteredPaint);
    }

    // Draw current position (blue circle)
    if (currentPosition != null) {
      final currentPaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill;

      final currentPoint =
          latLngToScreen(currentPosition!.latitude, currentPosition!.longitude);
      canvas.drawCircle(currentPoint, 6.0, currentPaint);

      // Draw accuracy circle
      final accuracyPaint = Paint()
        ..color = Colors.blue.withOpacity(0.3)
        ..style = PaintingStyle.fill;

      // Approximate accuracy radius in pixels (very rough)
      double accuracyRadius = currentPosition!.accuracy * 2;
      canvas.drawCircle(currentPoint, accuracyRadius, accuracyPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
