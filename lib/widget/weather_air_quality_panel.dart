import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/res/gaps.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/widget/air_quality_bar.dart';
import 'package:flutter_yd_weather/widget/blurry_container.dart';
import 'package:flutter_yd_weather/widget/scale_layout.dart';

import '../config/constants.dart';
import '../model/weather_item_data.dart';
import '../res/colours.dart';

class WeatherAirQualityPanel extends StatelessWidget {
  const WeatherAirQualityPanel({
    super.key,
    required this.data,
    required this.shrinkOffset,
  });

  final WeatherItemData data;
  final double shrinkOffset;

  @override
  Widget build(BuildContext context) {
    final weatherItemData = data;
    final titlePercent = (1 - shrinkOffset / 12.w).fixPercent();
    final percent = ((weatherItemData.maxHeight - 12.w - shrinkOffset) /
            Constants.itemStickyHeight.w)
        .fixPercent();
    return Opacity(
      opacity: percent,
      child: Stack(
        children: [
          BlurryContainer(
            width: double.infinity,
            height: double.infinity,
            blur: 5,
            margin: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
            ),
            padding: EdgeInsets.only(
              top: min(shrinkOffset, Constants.itemStickyHeight.w),
            ),
            color: Colours.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.w),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: -shrinkOffset -
                      min(shrinkOffset, Constants.itemStickyHeight.w),
                  right: 0,
                  bottom: 0,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gaps.generateGap(height: 12.w),
                        Opacity(
                          opacity: titlePercent,
                          child: Text(
                            "${weatherItemData.weatherData?.evn?.aqi} - ${weatherItemData.weatherData?.evn?.aqiLevelName}",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colours.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Gaps.generateGap(height: 10.w),
                        AirQualityBar(
                          width: double.infinity,
                          height: 4.w,
                          aqi: weatherItemData.weatherData?.evn?.aqi ?? 0,
                        ),
                        Gaps.generateGap(height: 8.w),
                        Text(
                          "当前AQI为${weatherItemData.weatherData?.evn?.aqi}",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colours.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Opacity(
            opacity: 1 - titlePercent,
            child: Container(
              height: Constants.itemStickyHeight.w,
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.only(left: 16.w),
              alignment: Alignment.centerLeft,
              child: Text(
                "空气质量",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colours.white.withOpacity(0.6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
