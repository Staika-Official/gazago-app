import 'package:flutter/material.dart';

enum GaugeType {
  circular,
  linear,
}

class GaugePainter extends CustomPainter {


  final double percentage;
  final Color fillColor;
  final Color backgroundColor;
  final GaugeType gaugeType;


  GaugePainter({
    required this.percentage,
    this.fillColor = Colors.blue,
    this.backgroundColor = Colors.grey,
    this.gaugeType = GaugeType.linear,
  });


  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint;
    Paint fillPaint;

    if(gaugeType == GaugeType.linear){
      backgroundPaint = Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.fill;

      fillPaint = Paint()
        ..color = fillColor
        ..style = PaintingStyle.fill;
    } else {
      backgroundPaint = Paint()
        ..color = backgroundColor
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.butt;

      fillPaint = Paint()
        ..color = fillColor
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.butt;
    }





    switch (gaugeType) {
      case GaugeType.circular:
      // circular gauge를 그림
        drawCircularGauge(canvas, size, backgroundPaint, fillPaint);
        break;
      case GaugeType.linear:
      // linear gauge를 그림
        drawLinearGauge(canvas, size, backgroundPaint, fillPaint);
        break;
    }



  }

  // 원형 게이지 그리기
  void drawCircularGauge(Canvas canvas, Size size, Paint backgroundPaint, Paint fillPaint) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2;

    canvas.drawCircle(center, radius, backgroundPaint);

    double sweepAngle = 2 * 3.141592653589793 * (percentage / 100);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -3.141592653589793 / 2, sweepAngle, false, fillPaint);
  }

  // 선형 게이지 그리기
  void drawLinearGauge(Canvas canvas, Size size, Paint backgroundPaint, Paint fillPaint) {
    RRect backgroundRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(10),
    );
    canvas.drawRRect(backgroundRRect, backgroundPaint);

    double fillWidth = size.width * (percentage / 100);
    RRect fillRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, fillWidth, size.height),
      Radius.circular(10),
    );
    canvas.drawRRect(fillRRect, fillPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class AnimatedGauge extends StatefulWidget {
  final double percentage;
  final Color fillColor;
  final Color backgroundColor;
  final GaugeType gaugeType;

  AnimatedGauge({
    required this.percentage,
    this.fillColor = Colors.blue,
    this.backgroundColor = Colors.grey,
    this.gaugeType = GaugeType.linear,});

  @override
  _AnimatedGaugeState createState() => _AnimatedGaugeState();
}

class _AnimatedGaugeState extends State<AnimatedGauge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0, end: 100).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(200, 8),
      painter: GaugePainter(
        percentage: _animation.value,
        gaugeType: widget.gaugeType,
      ),
    );
  }
}