import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gaza_go/platform/controllers/gps_debug_controller.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'dart:math' as math;

import 'package:google_maps_flutter/google_maps_flutter.dart';

class GPSDebugPage extends StatelessWidget {
  const GPSDebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GPSDebugController());

    return Scaffold(
      backgroundColor: AppColorData.regular().colorBgPrimary,
      appBar: AppBar(
        backgroundColor: AppColorData.regular().colorBgPrimary,
        title: Row(
          children: [
            Expanded(
              child: Text(
                'GPS Debug & Config',
                overflow: TextOverflow.ellipsis,
                style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                      color: AppColorData.regular().colorTextPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColorData.regular().colorTextPrimary,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          // Permission check button
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () async {
              controller.addLog('🔍 Manual permission check requested...');
              await controller.checkLocationPermission();
            },
            tooltip: 'Check Permissions',
          ),
          // Debug info button
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showDebugInfo(context, controller),
            tooltip: 'Debug Info',
          ),
        ],
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

            // GPS Visualization
            _buildGPSVisualization(controller),
            SizedBox(height: 16.sp),

            // Statistics
            _buildStatistics(controller),
            SizedBox(height: 16.sp),

            // Helper Status
            _buildHelperStatus(controller),
            SizedBox(height: 16.sp),

            // Real-time Logs
            _buildRealtimeLogs(controller),

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
              Icon(Icons.control_camera, size: 20.sp, color: Colors.blue),
              SizedBox(width: 8.sp),
              Expanded(
                child: Text(
                  'GPS Control Panel',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                        color: AppColorData.regular().colorTextPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.sp),

          // Main Controls
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Obx(() => ElevatedButton.icon(
                      onPressed: () async {
                        if (controller.isGPSActive.value) {
                          await controller.stopGPSTracking();
                        } else {
                          await controller.startGPSTracking();
                        }
                      },
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
                        minimumSize: Size(double.infinity, 48.sp),
                      ),
                    )),
              ),
              SizedBox(width: 8.sp),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: controller.resetStatistics,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 48.sp),
                  ),
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
              Icon(Icons.sensors, size: 20.sp, color: Colors.green),
              SizedBox(width: 8.sp),
              Expanded(
                child: Text(
                  'Real-time Status',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                        color: AppColorData.regular().colorTextPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.sp),
          Obx(() => Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: _buildStatusCard(
                              'GPS Status',
                              controller.isGPSActive.value
                                  ? 'ACTIVE'
                                  : 'INACTIVE',
                              controller.isGPSActive.value
                                  ? Colors.green
                                  : Colors.red,
                              Icons.gps_fixed)),
                      SizedBox(width: 8.sp),
                      Expanded(
                          child: _buildStatusCard(
                              'Current Speed',
                              '${controller.currentSpeed.value.toStringAsFixed(1)} km/h',
                              _getSpeedColor(controller.currentSpeed.value),
                              Icons.speed)),
                    ],
                  ),
                  SizedBox(height: 8.sp),
                  Row(
                    children: [
                      Expanded(
                          child: _buildStatusCard(
                              'GPS Accuracy',
                              controller.currentPosition.value != null
                                  ? '${controller.currentPosition.value!.accuracy.toStringAsFixed(1)}m'
                                  : 'N/A',
                              controller.currentPosition.value != null
                                  ? _getAccuracyColor(controller
                                      .currentPosition.value!.accuracy)
                                  : Colors.grey,
                              Icons.my_location)),
                      SizedBox(width: 8.sp),
                      Expanded(
                          child: _buildStatusCard(
                              'Session Time',
                              controller.formatDuration(
                                  controller.sessionDuration.value),
                              Colors.purple,
                              Icons.timer)),
                    ],
                  ),
                  SizedBox(height: 8.sp),
                  Row(
                    children: [
                      Expanded(
                          child: _buildStatusCard(
                              'Battery Level',
                              '${controller.batteryLevel.value}%',
                              _getBatteryColor(controller.batteryLevel.value),
                              Icons.battery_std)),
                      SizedBox(width: 8.sp),
                      Expanded(
                          child: _buildStatusCard(
                              'GPS Mode',
                              controller.gpsMode.value,
                              Colors.cyan,
                              Icons.settings)),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
      String label, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.sp),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20.sp),
          SizedBox(height: 4.sp),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.sp),
          Text(
            label,
            style: TextStyle(
              color: AppColorData.regular().colorTextSecondary,
              fontSize: 10.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGPSVisualization(GPSDebugController controller) {
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
              Icon(Icons.map, size: 20.sp, color: Colors.indigo),
              SizedBox(width: 8.sp),
              Expanded(
                child: Text(
                  'GPS Visualization',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                        color: AppColorData.regular().colorTextPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const Spacer(),
              Obx(() => Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
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
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
            ],
          ),
          SizedBox(height: 16.sp),

          // GPS Map
          Container(
            height: 200.sp,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.sp),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.sp),
              child: Stack(
                children: [
                  // Background
                  Container(
                    color: Colors.grey[100],
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: GridPainter(),
                    ),
                  ),
                  // GPS paths
                  Obx(() => CustomPaint(
                        size: Size.infinite,
                        painter: GPSPathPainter(
                          rawPositions: controller.rawPositions.toList(),
                          filteredPositions:
                              controller.filteredPositions.toList(),
                          currentPosition:
                              null, // TODO: Convert LocationModel to LocationDto when needed
                        ),
                      )),
                  // GPS info overlay
                  Positioned(
                    top: 8.sp,
                    right: 8.sp,
                    child: Container(
                      padding: EdgeInsets.all(8.sp),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8.sp),
                      ),
                      child: Obx(() => Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '📍 Live GPS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (controller.currentPosition.value != null) ...[
                                SizedBox(height: 4.sp),
                                Text(
                                  'Lat: ${controller.currentPosition.value!.latitude.toStringAsFixed(6)}',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 8.sp,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                Text(
                                  'Lng: ${controller.currentPosition.value!.longitude.toStringAsFixed(6)}',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 8.sp,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                Text(
                                  'Acc: ${controller.currentPosition.value!.accuracy.toStringAsFixed(1)}m',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 8.sp,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 12.sp),

          // Legend and Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem('Raw Path', Colors.red.withOpacity(0.7)),
              _buildLegendItem('Filtered Path', Colors.green),
              _buildLegendItem('Current Pos', Colors.blue),
            ],
          ),

          SizedBox(height: 8.sp),

          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMapStat(
                      'Raw', '${controller.rawPositions.length}', Colors.red),
                  _buildMapStat('Filtered',
                      '${controller.filteredPositions.length}', Colors.green),
                  _buildMapStat(
                      'Jumps', '${controller.gpsJumps.value}', Colors.orange),
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
              Icon(Icons.analytics, size: 20.sp, color: Colors.teal),
              SizedBox(width: 8.sp),
              Expanded(
                child: Text(
                  'GPS Statistics',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                        color: AppColorData.regular().colorTextPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.sp),
          Obx(() => Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: _buildStatCard(
                              'Total Positions',
                              '${controller.totalPositions.value}',
                              Colors.blue,
                              Icons.gps_fixed)),
                      SizedBox(width: 8.sp),
                      Expanded(
                          child: _buildStatCard(
                              'Filtered',
                              '${controller.rejectedPositions.value}',
                              Colors.red,
                              Icons.filter_alt)),
                    ],
                  ),
                  SizedBox(height: 8.sp),
                  Row(
                    children: [
                      Expanded(
                          child: _buildStatCard(
                              'Filter Rate',
                              '${controller.filterRate.value.toStringAsFixed(1)}%',
                              _getFilterRateColor(controller.filterRate.value),
                              Icons.percent)),
                      SizedBox(width: 8.sp),
                      Expanded(
                          child: _buildStatCard(
                              'Avg Accuracy',
                              '${controller.averageAccuracy.value.toStringAsFixed(1)}m',
                              _getAccuracyColor(
                                  controller.averageAccuracy.value),
                              Icons.air)),
                    ],
                  ),
                  SizedBox(height: 8.sp),
                  Row(
                    children: [
                      Expanded(
                          child: _buildStatCard(
                              'Max Speed',
                              '${controller.maxSpeed.value.toStringAsFixed(1)} km/h',
                              _getSpeedColor(controller.maxSpeed.value),
                              Icons.speed)),
                      SizedBox(width: 8.sp),
                      Expanded(
                          child: _buildStatCard(
                              'Grade',
                              controller.performanceGrade.value,
                              _getGradeColor(controller.performanceGrade.value),
                              Icons.grade)),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.sp),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18.sp),
          SizedBox(height: 4.sp),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.sp),
          Text(
            label,
            style: TextStyle(
              color: AppColorData.regular().colorTextSecondary,
              fontSize: 10.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHelperStatus(GPSDebugController controller) {
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
              Icon(Icons.extension, size: 20.sp, color: Colors.deepOrange),
              SizedBox(width: 8.sp),
              Expanded(
                child: Text(
                  'Helper Status',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                        color: AppColorData.regular().colorTextPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.sp),
          Obx(() => Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: _buildHelperCard(
                              'Fallbacks',
                              '${controller.fallbackCount.value}',
                              Colors.orange,
                              Icons.warning)),
                      SizedBox(width: 8.sp),
                      Expanded(
                          child: _buildHelperCard(
                              'Errors',
                              '${controller.errorCount.value}',
                              Colors.red,
                              Icons.error)),
                    ],
                  ),
                  SizedBox(height: 8.sp),
                  Row(
                    children: [
                      Expanded(
                          child: _buildHelperCard(
                              'Battery Opts',
                              '${controller.batteryOptimizations.value}',
                              Colors.purple,
                              Icons.battery_saver)),
                      SizedBox(width: 8.sp),
                      Expanded(
                          child: _buildHelperCard(
                              'Total Distance',
                              '${controller.totalDistance.value.toStringAsFixed(1)}m',
                              Colors.blue,
                              Icons.straighten)),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildHelperCard(
      String label, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.sp),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16.sp),
          SizedBox(width: 8.sp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 14.sp,
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
            ),
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
            children: [
              Icon(Icons.terminal, size: 20.sp, color: Colors.green),
              SizedBox(width: 8.sp),
              Text(
                'Real-time Logs',
                style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                      color: AppColorData.regular().colorTextPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: controller.clearLogs,
                icon: const Icon(Icons.clear_all, size: 16),
                label: const Text('Clear'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ),
          SizedBox(height: 16.sp),
          Container(
            height: 200.sp,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8.sp),
            ),
            child: Obx(() => ListView.builder(
                  padding: EdgeInsets.all(8.sp),
                  itemCount: controller.realtimeLogs.length,
                  itemBuilder: (context, index) {
                    final log = controller.realtimeLogs[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.sp),
                      child: Text(
                        log,
                        style: TextStyle(
                          color: _getLogColor(log),
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

  Color _getLogColor(String log) {
    if (log.contains('❌') || log.contains('ERROR')) return Colors.red;
    if (log.contains('⚠️') || log.contains('WARNING')) return Colors.orange;
    if (log.contains('✅') || log.contains('SUCCESS')) return Colors.green;
    if (log.contains('🔍') || log.contains('FILTERED')) return Colors.yellow;
    if (log.contains('🚀') || log.contains('🔄')) return Colors.blue;
    if (log.contains('👤')) return Colors.cyan;
    if (log.contains('📍') || log.contains('📋')) return Colors.purple;
    return Colors.green; // Default terminal green
  }

  // Color helper methods
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
    switch (grade.toUpperCase()) {
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

  // Debug info dialog
  void _showDebugInfo(BuildContext context, GPSDebugController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Debug Information'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: FutureBuilder<Map<String, dynamic>>(
            future: controller.getDebugInfo(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Text(
                    _formatDebugInfo(snapshot.data!),
                    style:
                        const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatDebugInfo(Map<String, dynamic> info) {
    final buffer = StringBuffer();

    void writeMap(Map<String, dynamic> map, [int indent = 0]) {
      final prefix = '  ' * indent;
      for (final entry in map.entries) {
        if (entry.value is Map<String, dynamic>) {
          buffer.writeln('$prefix${entry.key}:');
          writeMap(entry.value, indent + 1);
        } else {
          buffer.writeln('$prefix${entry.key}: ${entry.value}');
        }
      }
    }

    writeMap(info);
    return buffer.toString();
  }
}

// Custom painters
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1.0;

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

class GPSPathPainter extends CustomPainter {
  final List<LatLng> rawPositions;
  final List<LatLng> filteredPositions;
  final dynamic currentPosition; // Accept Position, LocationModel or map

  // Cache for bounds calculation
  static double? _cachedMinLat;
  static double? _cachedMaxLat;
  static double? _cachedMinLng;
  static double? _cachedMaxLng;
  static int _lastPositionCount = 0;

  GPSPathPainter({
    required this.rawPositions,
    required this.filteredPositions,
    this.currentPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (rawPositions.isEmpty && filteredPositions.isEmpty) return;

    // Optimize bounds calculation - only recalculate when positions change significantly
    final totalPositions = rawPositions.length + filteredPositions.length;
    bool shouldRecalculateBounds = _cachedMinLat == null ||
        (totalPositions - _lastPositionCount).abs() >
            5; // Recalculate every 5 new points

    double minLat, maxLat, minLng, maxLng;

    if (shouldRecalculateBounds) {
      minLat = double.infinity;
      maxLat = -double.infinity;
      minLng = double.infinity;
      maxLng = -double.infinity;

      // Use a more efficient approach - check last 50 positions for bounds
      final recentRaw = rawPositions.length > 50
          ? rawPositions.sublist(rawPositions.length - 50)
          : rawPositions;
      final recentFiltered = filteredPositions.length > 50
          ? filteredPositions.sublist(filteredPositions.length - 50)
          : filteredPositions;

      for (final pos in [...recentRaw, ...recentFiltered]) {
        minLat = math.min(minLat, pos.latitude);
        maxLat = math.max(maxLat, pos.latitude);
        minLng = math.min(minLng, pos.longitude);
        maxLng = math.max(maxLng, pos.longitude);
      }

      // Include current position in bounds
      if (currentPosition != null) {
        minLat = math.min(minLat, currentPosition!.latitude);
        maxLat = math.max(maxLat, currentPosition!.latitude);
        minLng = math.min(minLng, currentPosition!.longitude);
        maxLng = math.max(maxLng, currentPosition!.longitude);
      }

      // Add padding
      final latRange = (maxLat - minLat).clamp(0.001, double.infinity);
      final lngRange = (maxLng - minLng).clamp(0.001, double.infinity);
      minLat -= latRange * 0.15; // Increased padding for better visibility
      maxLat += latRange * 0.15;
      minLng -= lngRange * 0.15;
      maxLng += lngRange * 0.15;

      // Cache the bounds
      _cachedMinLat = minLat;
      _cachedMaxLat = maxLat;
      _cachedMinLng = minLng;
      _cachedMaxLng = maxLng;
      _lastPositionCount = totalPositions;
    } else {
      // Use cached bounds
      minLat = _cachedMinLat!;
      maxLat = _cachedMaxLat!;
      minLng = _cachedMinLng!;
      maxLng = _cachedMaxLng!;
    }

    // Optimized coordinate transformation
    Offset toScreen(double lat, double lng) {
      final x = (lng - minLng) / (maxLng - minLng) * size.width;
      final y = (maxLat - lat) / (maxLat - minLat) * size.height;
      return Offset(x.clamp(0.0, size.width), y.clamp(0.0, size.height));
    }

    // Draw filtered path first (main track) - only recent points for performance
    if (filteredPositions.length > 1) {
      final filteredPaint = Paint()
        ..color = Colors.green
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      // Optimize path drawing - use only recent points or subsample for performance
      final pointsToUse = filteredPositions.length > 100
          ? _subsamplePoints(filteredPositions, 100)
          : filteredPositions;

      if (pointsToUse.length > 1) {
        final filteredPath = Path();
        final startPoint =
            toScreen(pointsToUse[0].latitude, pointsToUse[0].longitude);
        filteredPath.moveTo(startPoint.dx, startPoint.dy);

        for (int i = 1; i < pointsToUse.length; i++) {
          final point =
              toScreen(pointsToUse[i].latitude, pointsToUse[i].longitude);
          filteredPath.lineTo(point.dx, point.dy);
        }
        canvas.drawPath(filteredPath, filteredPaint);
      }
    }

    // Draw raw path (less prominent) - subsample more aggressively
    if (rawPositions.length > 1) {
      final rawPaint = Paint()
        ..color = Colors.red.withOpacity(0.4) // More transparent
        ..strokeWidth = 1.5 // Thinner
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      // More aggressive subsampling for raw data
      final pointsToUse = rawPositions.length > 50
          ? _subsamplePoints(rawPositions, 50)
          : rawPositions;

      if (pointsToUse.length > 1) {
        final rawPath = Path();
        final startPoint =
            toScreen(pointsToUse[0].latitude, pointsToUse[0].longitude);
        rawPath.moveTo(startPoint.dx, startPoint.dy);

        for (int i = 1; i < pointsToUse.length; i++) {
          final point =
              toScreen(pointsToUse[i].latitude, pointsToUse[i].longitude);
          rawPath.lineTo(point.dx, point.dy);
        }
        canvas.drawPath(rawPath, rawPaint);
      }
    }

    // Draw current position with enhanced visibility
    if (currentPosition != null) {
      final currentPoint =
          toScreen(currentPosition!.latitude, currentPosition!.longitude);

      // Accuracy circle (simplified)
      // Ensure we pass a concrete double to math.min to avoid generic inference issues
      final double _accuracyVal =
          ((currentPosition?.accuracy ?? 0) as num).toDouble();
      final accuracyRadius = math.min(_accuracyVal * 0.5, 25.0);
      if (accuracyRadius > 3.0) {
        final accuracyPaint = Paint()
          ..color = Colors.blue.withOpacity(0.15)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(currentPoint, accuracyRadius, accuracyPaint);

        // Accuracy circle border
        final accuracyBorderPaint = Paint()
          ..color = Colors.blue.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;
        canvas.drawCircle(currentPoint, accuracyRadius, accuracyBorderPaint);
      }

      // Current position dot (enhanced)
      final currentPaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill;
      canvas.drawCircle(currentPoint, 8.0, currentPaint);

      // White border (enhanced)
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      canvas.drawCircle(currentPoint, 8.0, borderPaint);

      // Direction indicator (if available)
      if (currentPosition!.heading > 0) {
        final headingRadians = currentPosition!.heading * math.pi / 180;
        final arrowLength = 15.0;
        final arrowEnd = Offset(
          currentPoint.dx + math.sin(headingRadians) * arrowLength,
          currentPoint.dy - math.cos(headingRadians) * arrowLength,
        );

        final arrowPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0
          ..strokeCap = StrokeCap.round;

        canvas.drawLine(currentPoint, arrowEnd, arrowPaint);

        // Arrow head
        final arrowHeadLength = 6.0;
        final leftArrow = Offset(
          arrowEnd.dx - math.sin(headingRadians + 0.5) * arrowHeadLength,
          arrowEnd.dy + math.cos(headingRadians + 0.5) * arrowHeadLength,
        );
        final rightArrow = Offset(
          arrowEnd.dx - math.sin(headingRadians - 0.5) * arrowHeadLength,
          arrowEnd.dy + math.cos(headingRadians - 0.5) * arrowHeadLength,
        );

        canvas.drawLine(arrowEnd, leftArrow, arrowPaint);
        canvas.drawLine(arrowEnd, rightArrow, arrowPaint);
      }
    }
  }

  /// Subsample points to reduce rendering complexity
  List<LatLng> _subsamplePoints(List<LatLng> points, int maxPoints) {
    if (points.length <= maxPoints) return points;

    final step = points.length / maxPoints;
    final result = <LatLng>[];

    for (int i = 0; i < points.length; i += step.ceil()) {
      if (i < points.length) {
        result.add(points[i]);
      }
    }

    // Always include the last point
    if (result.last != points.last) {
      result.add(points.last);
    }

    return result;
  }

  @override
  bool shouldRepaint(covariant GPSPathPainter oldDelegate) {
    // More intelligent repaint logic
    return rawPositions.length != oldDelegate.rawPositions.length ||
        filteredPositions.length != oldDelegate.filteredPositions.length ||
        currentPosition != oldDelegate.currentPosition;
  }
}
