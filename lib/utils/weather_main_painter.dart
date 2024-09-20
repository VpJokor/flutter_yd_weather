import 'package:flutter/material.dart';
import '../widget/weather_main_clipper.dart';

class WeatherMainPainter extends CustomPainter {
  WeatherMainPainter({
    required this.weatherMainClipper,
    required this.borderWidth,
    required this.borderColor,
  });

  final WeatherMainClipper weatherMainClipper;
  final double borderWidth;
  final Color borderColor;

  final _paint = Paint()..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final path = weatherMainClipper.getClip(size);
    canvas.drawPath(
      path,
      _paint
        ..color = borderColor
        ..strokeWidth = borderWidth,
    );
  }

  @override
  bool shouldRepaint(covariant WeatherMainPainter oldDelegate) {
    return weatherMainClipper.animValue !=
        oldDelegate.weatherMainClipper.animValue;
  }
}
