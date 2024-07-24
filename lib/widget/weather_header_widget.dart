import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/model/weather_item_data.dart';
import 'package:flutter_yd_weather/res/gaps.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';

import '../res/colours.dart';
import '../utils/log.dart';

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
  double _marginTop = 0;
  final _currentMarginTop = 44.w;
  final _minMarginTop = 22.w;
  double _opacity1 = 1;
  double _opacity2 = 1;
  double _opacity3 = 1;
  double _opacity4 = 0;

  @override
  void initState() {
    super.initState();
    _currentHeight = widget.weatherItemData?.maxHeight ?? 0;
    Log.e("_currentHeight = $_currentHeight");
    _marginTop = _currentMarginTop;
  }

  @override
  void didUpdateWidget(covariant WeatherHeaderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_currentHeight <= 0) {
      setState(() {
        _currentHeight = widget.weatherItemData?.maxHeight ?? 0;
      });
    }
  }

  void change(double offset, double percent) {
    // Log.e("offset = $offset percent = $percent");
    double newPercent = percent;
    if (newPercent > 1) newPercent = 1;
    if (newPercent < 0) newPercent = 0;
    setState(() {
      final marginTop =
          _minMarginTop + (_currentMarginTop - _minMarginTop) * (1 - percent);
      _marginTop = marginTop < _minMarginTop ? _minMarginTop : marginTop;
      final currentHeight = (widget.weatherItemData?.maxHeight ?? 0) - offset;
      _currentHeight = currentHeight < (widget.weatherItemData?.minHeight ?? 0)
          ? (widget.weatherItemData?.minHeight ?? 0)
          : currentHeight;
      final opacity1 = 1 - (newPercent - 0.2) / (0.3 - 0.2);
      _opacity1 = opacity1 > 1 ? 1 : (opacity1 < 0 ? 0 : opacity1);
      final opacity2 = 1 - (newPercent - 0.4) / (0.5 - 0.4);
      _opacity2 = opacity2 > 1 ? 1 : (opacity2 < 0 ? 0 : opacity2);
      final opacity3 = 1 - (newPercent - 0.7) / (0.8 - 0.7);
      _opacity3 = opacity3 > 1 ? 1 : (opacity3 < 0 ? 0 : opacity3);
      final opacity4 = 1 - (newPercent - 0.9) / (0.9 - 1.0);
      _opacity4 = opacity4 > 1 ? 1 : (opacity4 < 0 ? 0 : opacity4);
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherData = widget.weatherItemData?.weatherData;
    final currentWeatherDetailData = weatherData?.forecast15?.singleOrNull(
      (element) =>
          element.date ==
          DateUtil.formatDate(DateTime.now(), format: Constants.yyyymmdd),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Gaps.generateGap(height: ScreenUtil().statusBarHeight),
        SizedBox(
          width: double.infinity,
          height: _currentHeight,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Gaps.generateGap(height: _marginTop),
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
                Gaps.generateGap(height: 5.w),
                Stack(
                  children: [
                    Column(
                      children: [
                        AnimatedOpacity(
                          opacity: _opacity3,
                          duration: Duration.zero,
                          child: Row(
                            children: [
                              Expanded(child: Gaps.generateGap()),
                              Text(
                                weatherData?.observe?.temp?.toString() ?? "",
                                style: TextStyle(
                                  fontSize: 92.sp,
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
                              Expanded(
                                child: Text(
                                  "°",
                                  style: TextStyle(
                                    fontSize: 86.sp,
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
                              ),
                            ],
                          ),
                        ),
                        Gaps.generateGap(height: 5.w),
                        AnimatedOpacity(
                          opacity: _opacity2,
                          duration: Duration.zero,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "最\n高",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colours.white,
                                  height: 1,
                                  fontFamily: "RobotoLight",
                                  shadows: const [
                                    BoxShadow(
                                      color: Colours.black_3,
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              Gaps.generateGap(width: 3.w),
                              Text(
                                currentWeatherDetailData?.high.getTemp() ?? "",
                                style: TextStyle(
                                  fontSize: 34.sp,
                                  color: Colours.white,
                                  height: 1,
                                  fontFamily: "RobotoLight",
                                  shadows: const [
                                    BoxShadow(
                                      color: Colours.black_3,
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              Gaps.generateGap(width: 12.w),
                              Text(
                                "最\n低",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colours.white,
                                  height: 1,
                                  fontFamily: "RobotoLight",
                                  shadows: const [
                                    BoxShadow(
                                      color: Colours.black_3,
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              Gaps.generateGap(width: 3.w),
                              Text(
                                currentWeatherDetailData?.low.getTemp() ?? "",
                                style: TextStyle(
                                  fontSize: 34.sp,
                                  color: Colours.white,
                                  height: 1,
                                  fontFamily: "RobotoLight",
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
                        ),
                        Gaps.generateGap(height: 5.w),
                        AnimatedOpacity(
                          opacity: _opacity1,
                          duration: Duration.zero,
                          child: Text(
                            currentWeatherDetailData?.wthr ?? "",
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: Colours.white,
                              height: 1,
                              fontFamily: "RobotoLight",
                              shadows: const [
                                BoxShadow(
                                  color: Colours.black_3,
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    AnimatedOpacity(
                      opacity: _opacity4,
                      duration: Duration.zero,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${weatherData?.observe?.temp.getTemp()} | ${currentWeatherDetailData?.wthr}",
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: Colours.white,
                              height: 1,
                              fontFamily: "RobotoLight",
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
