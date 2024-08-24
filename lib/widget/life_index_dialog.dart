import 'dart:math';

import 'package:bubble_box/bubble_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_yd_weather/model/weather_index_data.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';

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
    this.update,
  });

  final WeatherIndexData? data;
  final Offset position;
  final double size;
  final int column;
  final void Function(Offset position)? update;

  @override
  State<StatefulWidget> createState() => LifeIndexDialogState();
}

class LifeIndexDialogState extends State<LifeIndexDialog> {
  WeatherIndexData? _data;
  Offset _position = Offset.zero;
  int _column = 0;

  final _nameTextStyle = TextStyle(
    fontSize: 18.sp,
    color: Colours.black,
    height: 1,
    fontWeight: FontWeight.bold,
  );
  final _descTextStyle = TextStyle(
    fontSize: 15.sp,
    color: Colours.black,
  );

  double _opacity = 0;
  double _contentOpacity = 0;
  double _contentWidth = 0;
  double _contentHeight = 0;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
    _position = widget.position;
    _column = widget.column;
    _opacity = 0;
    Commons.post((_) {
      setState(() {
        _opacity = 1;
        _calContentSize();
      });
    });
  }

  void update(WeatherIndexData? data, Offset position, int column) {
    if (_data == data) return;
    setState(() {
      _data = data;
      _position = position;
      _column = column;
      Commons.post((_) {
        setState(() {
          _calContentSize();
        });
      });
    });
  }

  void exit() {
    setState(() {
      _opacity = 0;
    });
  }

  void _calContentSize() {
    _contentOpacity = 0;
    final name = _data?.name ?? "";
    final desc = _data?.desc ?? "";
    final maxWidth = ScreenUtil().screenWidth - 2 * 16.w;
    final nameTextWidth =
        name.getTextContextSizeWidth(_nameTextStyle, maxWidth: maxWidth);
    final descTextWidth =
        desc.getTextContextSizeWidth(_descTextStyle, maxWidth: maxWidth);
    final nameTextHeight =
        name.getTextContextSizeHeight(_nameTextStyle, maxWidth: maxWidth);
    final descTextHeight =
        desc.getTextContextSizeHeight(_descTextStyle, maxWidth: maxWidth);
    _contentWidth = 2 * 8.w + max(nameTextWidth, descTextWidth);
    _contentHeight = 3 * 8.w + nameTextHeight + descTextHeight;
  }

  @override
  Widget build(BuildContext context) {
    final marginTop = _position.dy - _contentHeight + 12.w;
    final content = Stack(
      children: [
        AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: _column == 0
              ? Alignment.topLeft
              : (_column == 1 ? Alignment.topCenter : Alignment.topRight),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.only(top: marginTop),
            child: BubbleBox(
              shape: BubbleShapeBorder(
                radius: BorderRadius.circular(12.w),
                direction: BubbleDirection.bottom,
                arrowAngle: 6.w,
                position: _column == 0
                    ? BubblePosition.start(
                        _position.dx - 16.w + widget.size * 0.5 - 6.w)
                    : (_column == 1
                        ? const BubblePosition.center(0)
                        : BubblePosition.end(ScreenUtil().screenWidth -
                            _position.dx -
                            16.w -
                            widget.size * 0.5 -
                            6.w)),
              ),
              backgroundColor: Colours.white,
              padding: EdgeInsets.zero,
              margin: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _contentWidth,
                height: _contentHeight,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                onEnd: () {
                  setState(() {
                    _contentOpacity = 1;
                  });
                },
                child: AnimatedOpacity(
                  opacity: _contentOpacity,
                  duration: const Duration(milliseconds: 200),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _data?.name ?? "",
                          style: _nameTextStyle,
                        ),
                        Gaps.generateGap(height: 8.w),
                        Text(
                          _data?.desc ?? "",
                          textAlign: TextAlign.justify,
                          style: _descTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 200),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              SmartDialog.dismiss(tag: "LifeIndexDialog");
            },
            onLongPressStart: (details) {
              widget.update?.call(details.globalPosition);
            },
            onLongPressMoveUpdate: (details) {
              widget.update?.call(details.globalPosition);
            },
            child: Container(
              color: Colours.transparent,
            ),
          ),
          content,
        ],
      ),
    );
  }
}
