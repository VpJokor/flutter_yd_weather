import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/widget/scale_layout.dart';

import '../config/constants.dart';
import '../model/weather_item_data.dart';
import '../res/colours.dart';
import '../res/gaps.dart';
import '../utils/weather_icon_utils.dart';
import 'blurry_container.dart';
import 'load_asset_image.dart';

class WeatherDailyPanel extends StatelessWidget {
  const WeatherDailyPanel({
    super.key,
    required this.data,
    required this.shrinkOffset,
  });

  final WeatherItemData data;
  final double shrinkOffset;

  @override
  Widget build(BuildContext context) {
    final weatherItemData = data;
    final percent = ((weatherItemData.maxHeight - 12.w - shrinkOffset) /
            Constants.itemStickyHeight.w)
        .fixPercent();
    return ScaleLayout(
      scale: 1.025,
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
                top: Constants.itemStickyHeight.w,
              ),
              color: Colours.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.w),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: -shrinkOffset,
                    right: 0,
                    bottom: 0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      // padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount:
                          weatherItemData.weatherData?.forecast15?.length ?? 0,
                      itemExtent: 60.w,
                      itemBuilder: (_, index) {
                        final item = weatherItemData.weatherData?.forecast15
                            .getOrNull(index);
                        return SizedBox(
                          width: 60.w,
                          child: Column(
                            children: [
                              Text(
                                "今天",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colours.white,
                                ),
                              ),
                              Gaps.generateGap(height: 8.w),
                              Text(
                                "07/13",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colours.white.withOpacity(0.6),
                                ),
                              ),
                              Gaps.generateGap(height: 8.w),
                              Text(
                                item?.day?.wthr ?? "",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colours.white,
                                ),
                              ),
                              Gaps.generateGap(height: 8.w),
                              LoadAssetImage(
                                WeatherIconUtils.getWeatherIconByType(
                                  item?.type ?? -1,
                                  false,
                                ),
                                width: 24.w,
                                height: 24.w,
                              ),
                              Container(
                                width: 60.w,
                                height: 88.w,
                                color: Colours.black_2,
                              ),
                              LoadAssetImage(
                                WeatherIconUtils.getWeatherIconByType(
                                  item?.type ?? -1,
                                  true,
                                ),
                                width: 24.w,
                                height: 24.w,
                              ),
                              Gaps.generateGap(height: 8.w),
                              Text(
                                item?.night?.wthr ?? "",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colours.white,
                                ),
                              ),
                              Gaps.generateGap(height: 8.w),
                              Text(
                                item?.wd ?? "",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colours.white,
                                ),
                              ),
                              Gaps.generateGap(height: 8.w),
                              Text(
                                item?.wp ?? "",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colours.white,
                                ),
                              ),
                              Gaps.generateGap(height: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.w),
                                  color: Colours.color00E301,
                                ),
                                child: Text(
                                  item?.aqiLevelName ?? "",
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colours.white,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: Constants.itemStickyHeight.w,
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.only(left: 16.w),
              alignment: Alignment.centerLeft,
              child: Text(
                "15日天气预报",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colours.white.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
