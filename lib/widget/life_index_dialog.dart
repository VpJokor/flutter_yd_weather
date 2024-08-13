import 'package:bubble_box/bubble_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/model/weather_index_data.dart';

import '../res/colours.dart';
import '../res/gaps.dart';
import '../utils/commons.dart';

class LifeIndexDialog extends StatefulWidget {
  const LifeIndexDialog({
    super.key,
    required this.data,
    this.position = Offset.zero,
    this.size = 0,
    this.column = 0,
  });

  final WeatherIndexData? data;
  final Offset position;
  final double size;
  final int column;

  @override
  State<StatefulWidget> createState() => LifeIndexDialogState();
}

class LifeIndexDialogState extends State<LifeIndexDialog> {
  double _opacity = 0;
  final _key = GlobalKey();
  double _height = 0;

  @override
  void initState() {
    super.initState();
    Commons.post((_) {
      setState(() {
        _opacity = 1;
        _height = _key.currentContext?.size?.height ?? 0;
        debugPrint("_height = $_height");
      });
    });
  }

  void exit() {
    setState(() {
      _opacity = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double marginTop = widget.position.dy - _height + 12.w;
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 200),
      child: Stack(
        children: [
          Align(
            alignment: widget.column == 0
                ? Alignment.topLeft
                : (widget.column == 1
                ? Alignment.topCenter
                : Alignment.topRight),
            child: BubbleBox(
              shape: BubbleShapeBorder(
                radius: BorderRadius.circular(12.w),
                direction: BubbleDirection.bottom,
                arrowAngle: 6.w,
                position: widget.column == 0
                    ? BubblePosition.start(
                    widget.position.dx - 16.w + widget.size * 0.5 - 6.w)
                    : (widget.column == 1
                    ? const BubblePosition.center(0)
                    : BubblePosition.end(ScreenUtil().screenWidth -
                    widget.position.dx -
                    16.w -
                    widget.size * 0.5 -
                    6.w)),
              ),
              backgroundColor: Colours.white,
              padding: EdgeInsets.zero,
              margin: EdgeInsets.only(
                left: 16.w,
                top: marginTop,
                right: 16.w,
              ),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  key: _key,
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.data?.name ?? "",
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colours.black,
                          height: 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gaps.generateGap(height: 8.w),
                      Text(
                        widget.data?.desc ?? "",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colours.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
