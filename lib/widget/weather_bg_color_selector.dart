import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/res/colours.dart';
import 'package:flutter_yd_weather/utils/commons.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';

class WeatherBgColorSelector extends StatefulWidget {
  const WeatherBgColorSelector({
    super.key,
    this.width,
    this.height = 0,
    required this.colors,
    required this.max,
    this.stops,
    this.onValueChanged,
  });

  final double? width;
  final double height;
  final List<Color> colors;
  final List<double>? stops;
  final double max;
  final ValueChanged<double>? onValueChanged;

  @override
  State<StatefulWidget> createState() => WeatherBgColorSelectorState();
}

class WeatherBgColorSelectorState extends State<WeatherBgColorSelector> {
  double _currentValue = 0;

  double _fixedValue() {
    if (_currentValue < 0) {
      return 0;
    } else if (_currentValue > widget.max) {
      return widget.max;
    }
    return _currentValue;
  }

  void changeValue(double value) {
    setState(() {
      _currentValue = value;
      _currentValue = _fixedValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final percent = _currentValue / widget.max;
        double marginLeft = (constraints.maxWidth - widget.height) * percent;
        return GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dx.abs() > 0.2) {
              HapticFeedback.lightImpact();
            }
            final position = details.localPosition;
            final movePercent =
                (position.dx / constraints.maxWidth).fixPercent();
            debugPrint("movePercent = $movePercent");
            setState(() {
              _currentValue = widget.max * movePercent;
              Commons.post((_) {
                widget.onValueChanged?.call(_currentValue);
              });
            });
          },
          child: Stack(
            children: [
              Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.w),
                  gradient: LinearGradient(
                    colors: widget.colors,
                    stops: widget.stops,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              Container(
                width: widget.height,
                height: widget.height,
                margin: EdgeInsets.only(left: marginLeft),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.w),
                  color: Colours.white,
                  border: Border.all(
                    width: 2.w,
                    color: Colours.colorCCCCCC,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
