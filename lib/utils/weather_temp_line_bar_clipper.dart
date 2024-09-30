import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeatherTempLineBarClipper extends CustomClipper<Path> {
  WeatherTempLineBarClipper({
    this.rect,
  });

  final Rect? rect;
  final _path = Path();
  final _clipPath = Path();

  @override
  Path getClip(Size size) {
    _path.reset();
    _path.addRect(Rect.fromLTRB(0, 0, size.width, size.height));
    final rect = this.rect;
    if (rect == null) {
      return _path;
    }
    _clipPath.reset();
    _clipPath.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(rect.left, rect.top, rect.right, rect.bottom),
        Radius.circular(100.w),
      ),
    );
    return Path.combine(PathOperation.intersect, _clipPath, _path);
  }

  @override
  bool shouldReclip(covariant WeatherTempLineBarClipper oldClipper) {
    return rect != oldClipper.rect;
  }
}
