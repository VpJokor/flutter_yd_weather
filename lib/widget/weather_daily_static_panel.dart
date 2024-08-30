import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/model/weather_item_data.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/widget/weather_daily_temp_panel.dart';

import '../config/constants.dart';
import '../res/colours.dart';
import '../res/gaps.dart';
import '../utils/weather_icon_utils.dart';
import 'blurry_container.dart';
import 'load_asset_image.dart';

class WeatherDailyStaticPanel extends StatelessWidget {
  const WeatherDailyStaticPanel({
    super.key,
    required this.weatherItemData,
    required this.shrinkOffset,
    required this.isDark,
    this.physics,
  });

  final WeatherItemData weatherItemData;
  final double shrinkOffset;
  final bool isDark;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    final percent = ((weatherItemData.maxHeight - 12.w - shrinkOffset) /
            Constants.itemStickyHeight.w)
        .fixPercent();
    final maxTempData = weatherItemData.weatherData?.forecast15
        ?.reduce((e1, e2) => (e1.high ?? 0) > (e2.high ?? 0) ? e1 : e2);
    final minTempData = weatherItemData.weatherData?.forecast15
        ?.reduce((e1, e2) => (e1.low ?? 0) < (e2.low ?? 0) ? e1 : e2);
    final itemWidth = 68.5.w;
    return AnimatedOpacity(
      opacity: percent,
      duration: Duration.zero,
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
            color: (isDark ? Colours.white : Colours.black).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.w),
            useBlurry: false,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: -shrinkOffset,
                  right: 0,
                  bottom: 0,
                  child: ListView.builder(
                    physics: physics,
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        weatherItemData.weatherData?.forecast15?.length ?? 0,
                    itemExtent: itemWidth,
                    itemBuilder: (_, index) {
                      final preItem = weatherItemData.weatherData?.forecast15
                          .getOrNull(index - 1);
                      final item = weatherItemData.weatherData?.forecast15
                          .getOrNull(index);
                      final nextItem = weatherItemData.weatherData?.forecast15
                          .getOrNull(index + 1);
                      final date = item?.date ?? "";
                      final weatherDateTime = date.getWeatherDateTime();
                      final isBefore = date.isBefore();
                      return SizedBox(
                        width: itemWidth,
                        child: Column(
                          children: [
                            Gaps.generateGap(height: 4.w),
                            Text(
                              weatherDateTime,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: isBefore
                                    ? Colours.white.withOpacity(0.5)
                                    : Colours.white,
                                height: 1,
                              ),
                            ),
                            Gaps.generateGap(height: 12.w),
                            Text(
                              DateUtil.formatDateStr(date,
                                  format: Constants.mmdd),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: isBefore
                                    ? Colours.white.withOpacity(0.5)
                                    : Colours.white,
                                height: 1,
                              ),
                            ),
                            Gaps.generateGap(height: 12.w),
                            Text(
                              item?.day?.wthr ?? "",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: isBefore
                                    ? Colours.white.withOpacity(0.5)
                                    : Colours.white,
                                height: 1,
                              ),
                            ),
                            Gaps.generateGap(height: 12.w),
                            AnimatedOpacity(
                              opacity: isBefore ? 0.5 : 1,
                              duration: Duration.zero,
                              child: LoadAssetImage(
                                WeatherIconUtils.getWeatherIconByType(
                                  item?.day?.type ?? -1,
                                  item?.day?.weatherType ?? "",
                                  false,
                                ),
                                width: 24.w,
                                height: 24.w,
                              ),
                            ),
                            WeatherDailyTempPanel(
                              width: itemWidth,
                              height: 128.w,
                              preData: preItem,
                              data: item,
                              nextData: nextItem,
                              maxTemp: maxTempData?.high ?? 0,
                              minTemp: minTempData?.low ?? 0,
                            ),
                            AnimatedOpacity(
                              opacity: isBefore ? 0.5 : 1,
                              duration: Duration.zero,
                              child: LoadAssetImage(
                                WeatherIconUtils.getWeatherIconByType(
                                  item?.night?.type ?? -1,
                                  item?.night?.weatherType ?? "",
                                  true,
                                ),
                                width: 24.w,
                                height: 24.w,
                              ),
                            ),
                            Gaps.generateGap(height: 12.w),
                            Text(
                              item?.night?.wthr ?? "",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: isBefore
                                    ? Colours.white.withOpacity(0.5)
                                    : Colours.white,
                                height: 1,
                              ),
                            ),
                            Gaps.generateGap(height: 12.w),
                            Text(
                              item?.wd ?? "",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: isBefore
                                    ? Colours.white.withOpacity(0.5)
                                    : Colours.white,
                                height: 1,
                              ),
                            ),
                            Gaps.generateGap(height: 12.w),
                            Text(
                              item?.wp ?? "",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: isBefore
                                    ? Colours.white.withOpacity(0.5)
                                    : Colours.white,
                                height: 1,
                              ),
                            ),
                            Visibility(
                              visible: item?.aqiLevelName.isNotNullOrEmpty() ??
                                  false,
                              child: Gaps.generateGap(height: 8.w),
                            ),
                            Visibility(
                              visible: item?.aqiLevelName.isNotNullOrEmpty() ??
                                  false,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 2.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.w),
                                  color:
                                      item?.aqi.getAqiColor().withOpacity(0.48),
                                ),
                                child: Text(
                                  item?.aqiLevelName ?? "",
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: Colours.white,
                                    height: 1,
                                  ),
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
    );
  }
}
