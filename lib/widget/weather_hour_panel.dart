import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/res/gaps.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/utils/weather_icon_utils.dart';
import 'package:flutter_yd_weather/widget/load_asset_image.dart';
import 'package:provider/provider.dart';

import '../config/constants.dart';
import '../model/weather_item_data.dart';
import '../pages/provider/weather_provider.dart';
import '../res/colours.dart';
import 'blurry_container.dart';

class WeatherHourPanel extends StatelessWidget {
  const WeatherHourPanel({
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
    final isDark = context.read<WeatherProvider>().isDark;
    final currentWeatherDetailData =
        weatherItemData.weatherData?.forecast15?.singleOrNull(
      (element) =>
          element.date ==
          DateUtil.formatDate(DateTime.now(), format: Constants.yyyymmdd),
    );
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
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: weatherItemData.weatherData?.hourFc?.length ?? 0,
                    itemBuilder: (_, index) {
                      final item =
                          weatherItemData.weatherData?.hourFc.getOrNull(index);
                      final time = item?.time ?? "";
                      final weatherHourTime = time.getWeatherHourTime();
                      return Column(
                        children: [
                          Gaps.generateGap(height: 4.w),
                          Text(
                            weatherHourTime,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colours.white,
                              height: 1,
                            ),
                          ),
                          Gaps.generateGap(height: 12.w),
                          LoadAssetImage(
                            WeatherIconUtils.getWeatherIconByType(
                              item?.type ?? -1,
                              item?.weatherType ?? "",
                              time.isNight(
                                sunrise: currentWeatherDetailData?.sunrise,
                                sunset: currentWeatherDetailData?.sunset,
                              ),
                            ),
                            width: 24.w,
                            height: 24.w,
                          ),
                          Gaps.generateGap(height: 12.w),
                          Text(
                            item?.temp.getTemp() ?? "",
                            style: TextStyle(
                              fontSize: 17.sp,
                              color: Colours.white,
                              height: 1,
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (_, index) {
                      return Gaps.generateGap(width: 13.w);
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
              "每小时天气预报",
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
