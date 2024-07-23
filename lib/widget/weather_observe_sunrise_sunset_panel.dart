import 'dart:math';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/widget/weather_observe_sunrise_sunset_chart.dart';

import '../config/constants.dart';
import '../model/weather_item_data.dart';
import '../res/colours.dart';
import '../res/gaps.dart';
import 'blurry_container.dart';

class WeatherObserveSunriseSunsetPanel extends StatelessWidget {
  const WeatherObserveSunriseSunsetPanel({
    super.key,
    required this.data,
    required this.shrinkOffset,
  });

  final WeatherItemData data;
  final double shrinkOffset;

  @override
  Widget build(BuildContext context) {
    final weatherItemData = data;
    final percent =
        ((Constants.itemObservePanelHeight.w - 12.w - shrinkOffset) /
                Constants.itemStickyHeight.w)
            .fixPercent();
    final currentWeatherDetailData =
        weatherItemData.weatherData?.forecast15?.singleOrNull(
      (element) =>
          element.date ==
          DateUtil.formatDate(DateTime.now(), format: Constants.yyyymmdd),
    );
    final currentMill = DateTime.now().millisecondsSinceEpoch;
    final sunriseDateTime =
        "${currentWeatherDetailData?.date}${currentWeatherDetailData?.sunrise}"
            .replaceAll(":", "")
            .getDartDateTimeFormattedString();
    final sunsetDateTime =
        "${currentWeatherDetailData?.date}${currentWeatherDetailData?.sunset}"
            .replaceAll(":", "")
            .getDartDateTimeFormattedString();
    final sunriseMill =
        DateTime.tryParse(sunriseDateTime)?.millisecondsSinceEpoch ?? 0;
    final sunsetMill =
        DateTime.tryParse(sunsetDateTime)?.millisecondsSinceEpoch ?? 0;
    String sunriseSunsetDesc, sunriseSunset;
    if (currentMill < sunriseMill || currentMill > sunsetMill) {
      sunriseSunsetDesc = "日出";
      sunriseSunset = currentWeatherDetailData?.sunrise ?? "";
    } else {
      sunriseSunsetDesc = "日落";
      sunriseSunset = currentWeatherDetailData?.sunset ?? "";
    }
    return Opacity(
      opacity: percent,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: shrinkOffset,
            right: 0,
            bottom: 0,
            child: BlurryContainer(
              width: double.infinity,
              height: double.infinity,
              blur: 5,
              color: Colours.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.w),
              padding: EdgeInsets.only(
                top: Constants.itemStickyHeight.w,
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: -shrinkOffset,
                    right: 0,
                    bottom: 0,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sunriseSunsetDesc,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colours.white,
                                  height: 1,
                                ),
                              ),
                              Gaps.generateGap(height: 8.w),
                              Text(
                                sunriseSunset,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colours.white,
                                  height: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 72.w,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                WeatherObserveSunriseSunsetChart(
                                  width: 72.w,
                                  height: 42.w,
                                  date: currentWeatherDetailData?.date ?? "",
                                  sunrise:
                                      currentWeatherDetailData?.sunrise ?? "",
                                  sunset:
                                      currentWeatherDetailData?.sunset ?? "",
                                ),
                                Gaps.generateGap(height: 4.w),
                                SizedBox(
                                  width: 72.w,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        currentWeatherDetailData?.sunrise ?? "",
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          color: Colours.white,
                                          height: 1,
                                        ),
                                      ),
                                      Text(
                                        currentWeatherDetailData?.sunset ?? "",
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          color: Colours.white,
                                          height: 1,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: shrinkOffset,
            child: Container(
              height: min(Constants.itemStickyHeight.w,
                  Constants.itemObservePanelHeight.w - shrinkOffset),
              padding: EdgeInsets.only(left: 16.w),
              alignment: Alignment.centerLeft,
              child: Text(
                "日出日落",
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
