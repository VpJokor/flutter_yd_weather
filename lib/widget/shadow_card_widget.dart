import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../res/colours.dart';
import '../utils/commons.dart';

class ShadowCardWidget extends StatefulWidget {
  ShadowCardWidget({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.alignment,
    this.bgColor = Colours.white,
    this.pressBgColor = Colours.colorF8F8F8,
    BorderRadiusGeometry? borderRadius,
    this.shadowColor = Colours.black_2,
    double? blurRadius,
    this.offset = Offset.zero,
    this.padding,
    this.margin,
    this.behavior = HitTestBehavior.translucent,
    this.enable = true,
    this.onPressed,
  })  : borderRadius = borderRadius ?? BorderRadius.circular(4.w),
        blurRadius = blurRadius ?? 4.w;

  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final Widget child;
  final Color bgColor;
  final Color pressBgColor;
  final BorderRadiusGeometry borderRadius;
  final Color shadowColor;
  final double blurRadius;
  final Offset offset;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final HitTestBehavior? behavior;
  final bool enable;
  final VoidCallback? onPressed;

  @override
  State<StatefulWidget> createState() => _ShadowCardWidgetState();
}

class _ShadowCardWidgetState extends State<ShadowCardWidget> {
  late Color _currentBgColor;

  @override
  void initState() {
    super.initState();
    _currentBgColor = widget.bgColor;
  }

  void _handleTapDown(TapDownDetails event) {
    setState(() {
      _currentBgColor = widget.pressBgColor;
    });
  }

  void _handleTapUp(TapUpDetails event) {
    Commons.postDelayed(delayMilliseconds: 50, () {
      setState(() {
        _currentBgColor = widget.bgColor;
      });
    });
  }

  void _handleTapCancel() {
    setState(() {
      _currentBgColor = widget.bgColor;
    });
  }

  @override
  void didUpdateWidget(covariant ShadowCardWidget oldWidget) {
    _currentBgColor = widget.bgColor;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enable;
    return GestureDetector(
      behavior: widget.behavior,
      onTap: widget.onPressed,
      onTapDown: enabled ? _handleTapDown : null,
      onTapUp: enabled ? _handleTapUp : null,
      onTapCancel: enabled ? _handleTapCancel : null,
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        margin: widget.margin,
        alignment: widget.alignment,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: _currentBgColor,
          borderRadius: widget.borderRadius,
          boxShadow: widget.blurRadius > 0
              ? [
                  BoxShadow(
                    color: widget.shadowColor,
                    blurRadius: widget.blurRadius,
                    offset: widget.offset,
                  )
                ]
              : null,
        ),
        child: widget.child,
      ),
    );
  }
}
