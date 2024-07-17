import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/widget/blurry_container.dart';
import 'package:flutter_yd_weather/widget/scale_layout.dart';

import '../config/constants.dart';
import '../model/weather_item_data.dart';
import '../res/colours.dart';
import '../res/gaps.dart';
import '../utils/commons.dart';
import 'load_asset_image.dart';

class WeatherForecast40Panel extends StatelessWidget {
  const WeatherForecast40Panel({
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
    final upDays = weatherItemData.weatherData?.forecast40Data?.upDays ?? 0;
    final rainDays = weatherItemData.weatherData?.forecast40Data?.rainDays ?? 0;
    final upDaysDesc = upDays > 0 ? "$upDays天升温" : "预计近期气温平稳";
    final rainDaysDesc = rainDays > 0 ? "$rainDays天有雨" : "预计近期无降雨";
    return ScaleLayout(
      scale: 1.02,
      child: Opacity(
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
                              "未来40日天气",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colours.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Gaps.generateGap(height: 10.w),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    ExtendedImage.network(
                                      weatherItemData.weatherData
                                          ?.forecast40Data?.tempIcon ??
                                          "",
                                      width: 54.w,
                                      height: 54.w,
                                      fit: BoxFit.cover,
                                      loadStateChanged:
                                      Commons.loadStateChanged(
                                          placeholder: Colours.transparent),
                                    ),
                                    Gaps.generateGap(height: 10.w),
                                    Text(
                                      "温度趋势",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colours.white.withOpacity(0.8),
                                        height: 1,
                                      ),
                                    ),
                                    Gaps.generateGap(height: 10.w),
                                    Text(
                                      upDaysDesc,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colours.white.withOpacity(0.8),
                                        fontWeight: FontWeight.bold,
                                        height: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    ExtendedImage.network(
                                      weatherItemData.weatherData
                                          ?.forecast40Data?.rainIcon ??
                                          "",
                                      width: 54.w,
                                      height: 54.w,
                                      fit: BoxFit.cover,
                                      loadStateChanged:
                                      Commons.loadStateChanged(
                                          placeholder: Colours.transparent),
                                    ),
                                    Gaps.generateGap(height: 10.w),
                                    Text(
                                      "降水趋势",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colours.white.withOpacity(0.8),
                                        height: 1,
                                      ),
                                    ),
                                    Gaps.generateGap(height: 10.w),
                                    Text(
                                      rainDaysDesc,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colours.white.withOpacity(0.8),
                                        fontWeight: FontWeight.bold,
                                        height: 1,
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
              ),
            ),
            Opacity(
              opacity: 1 - titlePercent,
              child: Container(
                height: Constants.itemStickyHeight.w,
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                padding: EdgeInsets.only(left: 16.w, right: 16.w),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "未来40日天气",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colours.white.withOpacity(0.6),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "查看详情",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colours.white.withOpacity(0.6),
                          ),
                        ),
                        LoadAssetImage(
                          "ic_arrow_right",
                          width: 11.w,
                          height: 11.w,
                          color: Colours.white.withOpacity(0.6),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
