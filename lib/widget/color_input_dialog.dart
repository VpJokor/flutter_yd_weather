import 'package:animated_visibility/animated_visibility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_yd_weather/res/colours.dart';
import 'package:flutter_yd_weather/res/gaps.dart';
import 'package:flutter_yd_weather/utils/color_utils.dart';
import 'package:flutter_yd_weather/utils/commons.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/utils/theme_utils.dart';
import 'package:flutter_yd_weather/widget/opacity_layout.dart';

class ColorInputDialog extends StatefulWidget {
  const ColorInputDialog({
    super.key,
    this.completed,
  });

  final void Function(Color? color)? completed;

  @override
  State<StatefulWidget> createState() => ColorInputDialogState();
}

class ColorInputDialogState extends State<ColorInputDialog> {
  final List<String> _currentInputList = List.generate(6, (_) => "");
  final List<String> _inputList = List.generate(10 + 6 + 1 + 1, (index) {
    if (index < 9) {
      return (index + 1).toString();
    } else if (index == 9) {
      return "A";
    } else if (index == 10) {
      return "B";
    } else if (index == 11) {
      return "C";
    } else if (index == 12) {
      return "D";
    } else if (index == 13) {
      return "E";
    } else if (index == 14) {
      return "F";
    } else if (index == 15) {
      return "space";
    } else if (index == 17) {
      return "del";
    } else {
      return "0";
    }
  });
  int _currentIndex = 0;
  bool _contentVisible = false;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _contentVisible = false;
    _visible = false;
    Commons.post((_) {
      setState(() {
        _contentVisible = true;
      });
      Commons.postDelayed(delayMilliseconds: 200, () {
        setState(() {
          _visible = true;
        });
      });
    });
  }

  void exit() {
    Commons.post((_) {
      setState(() {
        _visible = false;
      });
      Commons.postDelayed(delayMilliseconds: 200, () {
        setState(() {
          _contentVisible = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: AnimatedVisibility(
        visible: _contentVisible,
        enter: slideInVertically(),
        exit: slideOutVertically(),
        enterDuration: const Duration(milliseconds: 200),
        exitDuration: const Duration(milliseconds: 200),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.w),
              topRight: Radius.circular(12.w),
            ),
            color: context.backgroundColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gaps.generateGap(height: 24.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInputResultItem("#"),
                  Gaps.generateGap(width: 4.w),
                  _buildInputResultItem(_currentInputList[0]),
                  Gaps.generateGap(width: 4.w),
                  _buildInputResultItem(_currentInputList[1]),
                  Gaps.generateGap(width: 4.w),
                  _buildInputResultItem(_currentInputList[2]),
                  Gaps.generateGap(width: 4.w),
                  _buildInputResultItem(_currentInputList[3]),
                  Gaps.generateGap(width: 4.w),
                  _buildInputResultItem(_currentInputList[4]),
                  Gaps.generateGap(width: 4.w),
                  _buildInputResultItem(_currentInputList[5]),
                ],
              ),
              Gaps.generateGap(height: 32.w),
              SizedBox(
                height: 54.w * 6 + 0.5.w,
                child: AnimatedVisibility(
                  visible: _visible,
                  enter: slideInVertically(),
                  exit: slideOutVertically(),
                  enterDuration: const Duration(milliseconds: 200),
                  exitDuration: const Duration(milliseconds: 200),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 0.5.w,
                        color: context.cardColor06,
                      ),
                      Wrap(
                        children: _inputList.mapIndexed((e, index) {
                          return _buildInputItem(e);
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputResultItem(String input) {
    return Container(
      width: 42.w,
      height: 42.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.w),
        color: context.cardColor06,
      ),
      child: AnimatedVisibility(
        visible: input.isNotEmpty,
        enter: fadeIn(),
        exit: fadeOut(),
        enterDuration: const Duration(milliseconds: 200),
        exitDuration: const Duration(milliseconds: 200),
        child: Text(
          input,
          style: TextStyle(
            fontSize: 22.sp,
            color: context.textColor01,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInputItem(
    String input,
  ) {
    final width = ScreenUtil().screenWidth / 3;
    final height = 54.w;
    return OpacityLayout(
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: context.cardColor06,
            width: 0.5.w,
          ),
        ),
        child: input == "space"
            ? null
            : Text(
                input == "del" ? "删除" : input,
                style: TextStyle(
                  fontSize: input == "del" ? 20.w : 26.w,
                  color: context.textColor01,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
      onPressed: () {
        if (input == "del") {
          HapticFeedback.lightImpact();
          if (_currentIndex >= 0) {
            setState(() {
              _currentIndex--;
              if (_currentIndex < 0) _currentIndex = 0;
              _currentInputList[_currentIndex] = "";
            });
          }
        } else if (input != "space") {
          HapticFeedback.lightImpact();
          if (_currentIndex <= _currentInputList.length - 1) {
            setState(() {
              _currentInputList[_currentIndex] = input;
              _currentIndex++;
            });
          }
          if (_currentInputList.singleOrNull((e) => e.isEmpty) == null) {
            final color = ColorUtils.getColorFromHex(_currentInputList.join());
            Commons.post((_) {
              setState(() {
                _visible = false;
                Commons.postDelayed(delayMilliseconds: 200, () {
                  SmartDialog.dismiss(tag: "ColorInputDialog").then((_) {
                    widget.completed?.call(color);
                  });
                });
              });
            });
          }
        }
      },
    );
  }
}
