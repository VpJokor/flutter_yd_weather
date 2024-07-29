import 'package:flutter/material.dart';

class WeatherMainClipper extends CustomClipper<Path> {
  WeatherMainClipper({
    required this.fromRect,
    required this.toRect,
    required this.animValue,
    this.radius = 0,
  });

  final Rect? fromRect;
  final Rect? toRect;
  final double? animValue;
  final double radius;
  final _path = Path();
  final _clipPath = Path();

  @override
  Path getClip(Size size) {
    final animValue = this.animValue ?? 0;
    if (this.fromRect == null && this.toRect == null) {
      _path.reset();
      _path.addRect(Rect.fromLTRB(0, 0, size.width, size.height));
      return _path;
    }
    final fromRect =
        this.fromRect ?? Rect.fromLTRB(0, 0, size.width, size.height);
    final toRect = this.toRect ?? Rect.fromLTRB(0, 0, size.width, size.height);
    _path.reset();
    if (this.fromRect == null) {
      _path.addRect(fromRect);
    } else if (this.toRect == null) {
      _path.addRect(toRect);
    }

    _clipPath.reset();
    final clipRRect = RRect.fromRectAndRadius(
        Rect.fromLTRB(
            fromRect.left + (toRect.left - fromRect.left) * animValue,
            fromRect.top + (toRect.top - fromRect.top) * animValue,
            fromRect.right - (fromRect.right - toRect.right) * animValue,
            fromRect.bottom - (fromRect.bottom - toRect.bottom) * animValue),
        Radius.circular(radius));
    _clipPath.addRRect(clipRRect);
    return Path.combine(PathOperation.intersect, _clipPath, _path);
  }

  @override
  bool shouldReclip(covariant WeatherMainClipper oldClipper) {
    return animValue != oldClipper.animValue;
  }
}
