import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/model/weather_item_data.dart';
import 'package:flutter_yd_weather/res/colours.dart';
import 'package:flutter_yd_weather/utils/log.dart';
import 'package:flutter_yd_weather/widget/weather_air_quality_panel.dart';
import 'package:flutter_yd_weather/widget/weather_alarms_panel.dart';
import 'package:flutter_yd_weather/widget/weather_daily_panel.dart';
import 'package:flutter_yd_weather/widget/weather_hour_panel.dart';

import '../widget/blurry_container.dart';

class WeatherPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  WeatherPersistentHeaderDelegate(
    this.weatherItemData,
  );

  final WeatherItemData weatherItemData;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final maxHeight = weatherItemData.maxHeight;
    final minHeight = weatherItemData.minHeight;
    final percent = 1 - shrinkOffset / maxHeight;
    /*Log.e(
        "shrinkOffset = $shrinkOffset overlapsContent = $overlapsContent percent = $percent height = $height");*/
    if (weatherItemData.itemType == Constants.itemTypeAlarms) {
      return WeatherAlarmsPanel(
        data: weatherItemData,
        shrinkOffset: shrinkOffset,
      );
    } else if (weatherItemData.itemType == Constants.itemTypeAirQuality) {
      return WeatherAirQualityPanel(
        data: weatherItemData,
        shrinkOffset: shrinkOffset,
      );
    } else if (weatherItemData.itemType == Constants.itemTypeHourWeather) {
      return WeatherHourPanel(
        data: weatherItemData,
        shrinkOffset: shrinkOffset,
      );
    } else if (weatherItemData.itemType == Constants.itemTypeDailyWeather) {
      return WeatherDailyPanel(
        data: weatherItemData,
        shrinkOffset: shrinkOffset,
      );
    }
    return Opacity(
      opacity: percent,
      child: BlurryContainer(
        width: double.infinity,
        height: double.infinity,
        color: Colours.white.withOpacity(0.1),
        blur: 5,
        margin: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
        ),
        borderRadius: BorderRadius.circular(12.w),
        child: Text(
          "",
          style: TextStyle(
            fontSize: 12.sp,
            color: weatherItemData.itemType == Constants.itemTypeWeatherHeader
                ? Colours.black
                : Colours.white,
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => weatherItemData.maxHeight;

  @override
  double get minExtent => weatherItemData.minHeight;

  @override
  bool shouldRebuild(covariant WeatherPersistentHeaderDelegate oldDelegate) {
    final rebuild = weatherItemData != oldDelegate.weatherItemData;
    Log.e("rebuild = $rebuild");
    return true;
  }
}
