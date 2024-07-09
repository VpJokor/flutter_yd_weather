import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/model/weather_item_data.dart';
import 'package:flutter_yd_weather/res/gaps.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';

import '../res/colours.dart';

class WeatherHeaderWidget extends StatefulWidget {
  const WeatherHeaderWidget({
    super.key,
    required this.weatherItemData,
  });

  final WeatherItemData? weatherItemData;

  @override
  State<StatefulWidget> createState() => WeatherHeaderWidgetState();
}

class WeatherHeaderWidgetState extends State<WeatherHeaderWidget> {
  double _currentHeight = 0;
  final _currentMarginTop = 44.w;
  final _minMarginTop = 22.w;

  @override
  void initState() {
    super.initState();
    _currentHeight = widget.weatherItemData?.maxHeight ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final weatherData = widget.weatherItemData?.weatherData;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Gaps.generateGap(height: ScreenUtil().statusBarHeight),
        SizedBox(
          width: double.infinity,
          height: _currentHeight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gaps.generateGap(height: _currentMarginTop),
              Text(
                weatherData?.meta?.city ?? "",
                style: TextStyle(
                  fontSize: 28.sp,
                  color: Colours.white,
                  height: 1,
                  fontFamily: "RobotoThin",
                  shadows: const [
                    BoxShadow(
                      color: Colours.black_3,
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Text(
                    weatherData?.observe?.temp?.toString() ?? "",
                    style: TextStyle(
                      fontSize: 78.sp,
                      color: Colours.white,
                      height: 1,
                      fontFamily: "RobotoThin",
                      shadows: const [
                        BoxShadow(
                          color: Colours.black_3,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
