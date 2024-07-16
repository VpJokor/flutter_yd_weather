import 'dart:math';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/model/weather_item_data.dart';
import 'package:flutter_yd_weather/res/colours.dart';
import 'package:flutter_yd_weather/res/gaps.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/utils/log.dart';
import 'package:flutter_yd_weather/widget/blurry_container.dart';
import 'package:flutter_yd_weather/widget/scale_layout.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WeatherAlarmsPanel extends StatefulWidget {
  const WeatherAlarmsPanel({
    super.key,
    required this.data,
    required this.shrinkOffset,
  });

  final WeatherItemData data;
  final double shrinkOffset;

  @override
  State<StatefulWidget> createState() => _WeatherAlarmsPanelState();
}

class _WeatherAlarmsPanelState extends State<WeatherAlarmsPanel> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final weatherItemData = widget.data;
    final titlePercent = (1 - widget.shrinkOffset / 12.w).fixPercent();
    final timePercent = (1 - widget.shrinkOffset / 28.w).fixPercent();
    final percent = ((weatherItemData.maxHeight - 12.w - widget.shrinkOffset) /
            Constants.itemStickyHeight.w)
        .fixPercent();
    Log.e(
        "titlePercent = $titlePercent timePercent = $timePercent percent = $percent");
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
                top: min(widget.shrinkOffset, Constants.itemStickyHeight.w),
              ),
              color: Colours.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.w),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: -widget.shrinkOffset -
                        min(widget.shrinkOffset, Constants.itemStickyHeight.w),
                    right: 0,
                    bottom: 0,
                    child: Visibility(
                      visible: weatherItemData.weatherData?.alarms
                              .isNotNullOrEmpty() ??
                          false,
                      child: Swiper(
                        key: const Key('alarms_swiper'),
                        loop: false,
                        itemCount:
                            weatherItemData.weatherData?.alarms?.length ?? 0,
                        onIndexChanged: (index) {
                          setState(() {
                            _index = index;
                          });
                        },
                        itemBuilder: (_, index) {
                          final item = weatherItemData.weatherData?.alarms
                              ?.getOrNull(index);
                          return SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Gaps.generateGap(height: 12.w),
                                Opacity(
                                  opacity: titlePercent,
                                  child: Text(
                                    item?.title ?? "",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colours.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Gaps.generateGap(height: 4.w),
                                Opacity(
                                  opacity: timePercent,
                                  child: Text(
                                    "17小时前更新",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colours.white,
                                    ),
                                  ),
                                ),
                                Gaps.generateGap(height: 8.w),
                                Text(
                                  item?.desc ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colours.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Visibility(
                      visible: (weatherItemData.weatherData?.alarms?.length ?? 0) > 1,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12.w),
                        alignment: Alignment.center,
                        child: AnimatedSmoothIndicator(
                          activeIndex: _index,
                          count:
                              weatherItemData.weatherData?.alarms?.length ?? 0,
                          effect: ExpandingDotsEffect(
                            expansionFactor: 1.5,
                            spacing: 3.w,
                            dotWidth: 6.w,
                            dotHeight: 2.w,
                            activeDotColor: Colours.white,
                            dotColor: Colours.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Opacity(
              opacity: 1 - timePercent,
              child: Container(
                height: Constants.itemStickyHeight.w,
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                padding: EdgeInsets.only(left: 16.w),
                alignment: Alignment.centerLeft,
                child: Text(
                  "极端天气",
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
      onPressed: () {},
    );
  }
}
