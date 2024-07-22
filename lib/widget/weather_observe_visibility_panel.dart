import 'dart:math';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/utils/log.dart';
import 'package:flutter_yd_weather/widget/scale_layout.dart';

import '../config/constants.dart';
import '../model/weather_item_data.dart';
import '../res/colours.dart';
import '../res/gaps.dart';
import 'blurry_container.dart';

class WeatherObserveVisibilityPanel extends StatelessWidget {
  const WeatherObserveVisibilityPanel({
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
    String visibility = weatherItemData.weatherData?.observe?.visibility ?? "";
    if (visibility.isEmpty) {
      final currentWeatherDetailData =
          weatherItemData.weatherData?.forecast15?.singleOrNull(
        (element) =>
            element.date ==
            DateUtil.formatDate(DateTime.now(), format: Constants.yyyymmdd),
      );
      visibility = currentWeatherDetailData?.visibility ?? "";
    }
    final visibilityValue = visibility.getVisibilityValue();
    final visibilityUnit = visibility.getVisibilityUnit();
    final visibilityDesc = visibility.getVisibilityDesc(visibilityValue);
    return ScaleLayout(
      scale: 1.02,
      child: Opacity(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${visibilityValue.round()}$visibilityUnit",
                              style: TextStyle(
                                fontSize: 32.sp,
                                color: Colours.white,
                                height: 1,
                              ),
                            ),
                            Gaps.generateGap(height: 33.w),
                            Text(
                              visibilityDesc,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colours.white,
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
                  "可见度",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colours.white.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}