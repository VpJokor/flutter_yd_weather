import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/utils/theme_utils.dart';
import 'package:flutter_yd_weather/widget/weather_air_quality_static_panel.dart';
import 'package:flutter_yd_weather/widget/weather_alarms_static_panel.dart';
import 'package:flutter_yd_weather/widget/weather_daily_static_panel.dart';
import 'package:flutter_yd_weather/widget/weather_header_static_panel.dart';
import 'package:flutter_yd_weather/widget/weather_hour_static_panel.dart';
import 'package:flutter_yd_weather/widget/weather_life_index_static_panel.dart';
import 'package:flutter_yd_weather/widget/weather_observe_static_panel.dart';

import '../config/constants.dart';
import '../model/weather_item_data.dart';
import '../res/colours.dart';
import '../res/gaps.dart';
import '../utils/weather_data_utils.dart';

class WeatherCitySnapshot extends StatelessWidget {
  const WeatherCitySnapshot({
    super.key,
    required this.data,
  });

  final List<WeatherItemData>? data;

  @override
  Widget build(BuildContext context) {
    final weatherData = data?.getOrNull(0)?.weatherData;
    final weatherBg = WeatherDataUtils.generateWeatherBg(weatherData);
    final isDark = WeatherDataUtils.isDark(weatherBg);
    double height = 0;
    final weatherContent = data?.mapIndexed(
          (item, index) {
            final itemType = item.itemType;
            if (height > ScreenUtil().screenHeight) {
              return Gaps.empty;
            }
            height += item.maxHeight;
            final marginTop = index > 1 ? 12.w : 0.w;
            if (itemType == Constants.itemTypeWeatherHeader) {
              return WeatherHeaderStaticPanel(
                isDark: isDark,
                weatherData: item.weatherData,
                marginTopContainerHeight: 44.w,
                height: item.maxHeight,
              );
            } else if (itemType == Constants.itemTypeAlarms) {
              return Container(
                height: item.maxHeight,
                margin: EdgeInsets.only(top: marginTop),
                child: WeatherAlarmsStaticPanel(
                  weatherItemData: item,
                  shrinkOffset: 0,
                  isDark: isDark,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              );
            } else if (itemType == Constants.itemTypeAirQuality) {
              return Container(
                height: item.maxHeight,
                margin: EdgeInsets.only(top: marginTop),
                child: WeatherAirQualityStaticPanel(
                  weatherItemData: item,
                  shrinkOffset: 0,
                  isDark: isDark,
                ),
              );
            } else if (itemType == Constants.itemTypeHourWeather) {
              return Container(
                height: item.maxHeight,
                margin: EdgeInsets.only(top: marginTop),
                child: WeatherHourStaticPanel(
                  weatherItemData: item,
                  shrinkOffset: 0,
                  isDark: isDark,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              );
            } else if (itemType == Constants.itemTypeDailyWeather) {
              return Container(
                height: item.maxHeight,
                margin: EdgeInsets.only(top: marginTop),
                child: WeatherDailyStaticPanel(
                  weatherItemData: item,
                  shrinkOffset: 0,
                  isDark: isDark,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              );
            } else if (itemType == Constants.itemTypeObserve) {
              return Container(
                height: item.maxHeight,
                margin: EdgeInsets.only(top: marginTop),
                child: WeatherObserveStaticPanel(
                  data: item,
                  shrinkOffset: 0,
                  isDark: isDark,
                ),
              );
            } else if (itemType == Constants.itemTypeLifeIndex) {
              return Container(
                height: item.maxHeight,
                margin: EdgeInsets.only(top: marginTop),
                child: WeatherLifeIndexStaticPanel(
                  weatherItemData: item,
                  shrinkOffset: 0,
                  isDark: isDark,
                ),
              );
            }
            return Gaps.empty;
          },
        ) ??
        [];
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().screenHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.w),
            gradient: weatherBg,
          ),
        ),
        Visibility(
          visible: context.isDark,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colours.black.withOpacity(0.2),
                  Colours.black.withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: weatherContent,
          ),
        ),
      ],
    );
  }
}
