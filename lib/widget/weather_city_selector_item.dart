import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/model/weather_item_data.dart';
import 'package:flutter_yd_weather/res/gaps.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/utils/pair.dart';
import 'package:flutter_yd_weather/utils/theme_utils.dart';
import 'package:flutter_yd_weather/utils/weather_data_utils.dart';
import 'package:flutter_yd_weather/widget/weather_air_quality_static_panel.dart';
import 'package:flutter_yd_weather/widget/weather_alarms_static_panel.dart';
import 'package:flutter_yd_weather/widget/weather_daily_static_panel.dart';
import 'package:flutter_yd_weather/widget/weather_header_static_panel.dart';
import 'package:flutter_yd_weather/widget/weather_hour_static_panel.dart';
import 'package:flutter_yd_weather/widget/weather_life_index_static_panel.dart';
import 'package:flutter_yd_weather/widget/weather_observe_static_panel.dart';

import '../model/city_data.dart';
import '../res/colours.dart';

class WeatherCitySelectorItem extends StatelessWidget {
  const WeatherCitySelectorItem({
    super.key,
    required this.pair,
  });

  final Pair<CityData?, List<WeatherItemData>>? pair;

  @override
  Widget build(BuildContext context) {
    final weatherData = pair?.second
        ?.getOrNull(0)
        ?.weatherData;
    final weatherBg = WeatherDataUtils.generateWeatherBg(weatherData);
    final isDark = WeatherDataUtils.isDark(weatherBg);
    double height = 0;
    final weatherContent = pair?.second.mapIndexed(
          (item, index) {
        final itemType = item.itemType;
        if (height > ScreenUtil().screenHeight) {
          return Gaps.empty;
        }
        height += item.maxHeight;
        if (itemType == Constants.itemTypeWeatherHeader) {
          return WeatherHeaderStaticPanel(
            isDark: isDark,
            weatherData: item.weatherData,
            marginTopContainerHeight: 44.w,
            height: item.maxHeight,
          );
        } else if (itemType == Constants.itemTypeAlarms) {
          return SizedBox(
            height: item.maxHeight,
            child: WeatherAlarmsStaticPanel(
              weatherItemData: item,
              shrinkOffset: 0,
              isDark: isDark,
            ),
          );
        } else if (itemType == Constants.itemTypeAirQuality) {
          return SizedBox(
            height: item.maxHeight,
            child: WeatherAirQualityStaticPanel(
              weatherItemData: item,
              shrinkOffset: 0,
              isDark: isDark,
            ),
          );
        } else if (itemType == Constants.itemTypeHourWeather) {
          return SizedBox(
            height: item.maxHeight,
            child: WeatherHourStaticPanel(
              weatherItemData: item,
              shrinkOffset: 0,
              isDark: isDark,
              physics: const NeverScrollableScrollPhysics(),
            ),
          );
        } else if (itemType == Constants.itemTypeDailyWeather) {
          return SizedBox(
            height: item.maxHeight,
            child: WeatherDailyStaticPanel(
              weatherItemData: item,
              shrinkOffset: 0,
              isDark: isDark,
              physics: const NeverScrollableScrollPhysics(),
            ),
          );
        } else if (itemType == Constants.itemTypeObserve) {
          return SizedBox(
            height: item.maxHeight,
            child: WeatherObserveStaticPanel(
              data: item,
              shrinkOffset: 0,
              isDark: isDark,
            ),
          );
        } else if (itemType == Constants.itemTypeLifeIndex) {
          return SizedBox(
            height: item.maxHeight,
            child: WeatherLifeIndexStaticPanel(
              weatherItemData: item,
              shrinkOffset: 0,
              isDark: isDark,
            ),
          );
        }
        return Gaps.empty;
      },
    ) ?? [];
    final content = Stack(
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
    return SizedBox(
      width: ScreenUtil().screenWidth * 0.6,
      height: ScreenUtil().screenHeight * 0.6,
      child: OverflowBox(
        alignment: Alignment.topLeft,
        maxWidth: ScreenUtil().screenWidth,
        maxHeight: ScreenUtil().screenHeight,
        child: Transform.scale(
          alignment: Alignment.topLeft,
          scale: 0.6,
          child: content,
        ),
      ),
    );
  }
}
