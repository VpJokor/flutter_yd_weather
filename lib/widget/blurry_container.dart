import 'dart:ui';

import 'package:flutter/material.dart';

class BlurryContainer extends StatelessWidget {
  /// This widget will be shown over blurry container.
  final Widget child;

  /// [height] of blurry container.
  final double? height;

  /// [width] of blurry container.
  final double? width;

  /// [elevation] of blurry container.
  ///
  /// Defaults to `0`.
  final double elevation;

  /// Shadow color of container.
  final Color? shadowColor;

  /// The [blur] will control the amount of sigmaX and sigmaY.
  ///
  /// Defaults to `5`.
  final double blur;

  /// [padding] adds the [EdgeInsetsGeometry] to given [child].
  ///
  /// Defaults to `const EdgeInsets.all(8)`.
  final EdgeInsetsGeometry? padding;

  final EdgeInsetsGeometry? margin;

  /// Background color of container.
  final Color? color;

  /// [borderRadius] of blurry container.
  final BorderRadius borderRadius;

  const BlurryContainer({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.blur = 5,
    this.elevation = 0,
    this.padding,
    this.margin,
    this.color,
    this.shadowColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  /// Creates a blurry container whose [width] and [height] are equal.
  const BlurryContainer.square({
    super.key,
    required this.child,
    double? dimension,
    this.blur = 5,
    this.elevation = 0,
    this.padding,
    this.margin,
    this.color,
    this.shadowColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  })  : width = dimension,
        height = dimension;

  /// Creates a blurry container whose [width] and [height] are equal.
  const BlurryContainer.expand({
    super.key,
    required this.child,
    this.blur = 5,
    this.elevation = 0,
    this.padding,
    this.margin,
    this.color,
    this.shadowColor,
    this.borderRadius = BorderRadius.zero,
  })  : width = double.infinity,
        height = double.infinity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        elevation: elevation,
        shadowColor: shadowColor,
        color: Colors.transparent,
        borderRadius: borderRadius,
        clipBehavior: Clip.hardEdge,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            height: height,
            width: width,
            padding: padding,
            color: color,
            child: child,
          ),
        ),
      ),
    );
  }
}
