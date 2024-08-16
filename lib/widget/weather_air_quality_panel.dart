import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_yd_weather/pages/provider/weather_provider.dart';
import 'package:flutter_yd_weather/res/gaps.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/widget/air_quality_bar.dart';
import 'package:flutter_yd_weather/widget/air_quality_detail_popup.dart';
import 'package:flutter_yd_weather/widget/air_quality_query_dialog.dart';
import 'package:flutter_yd_weather/widget/blurry_container.dart';
import 'package:flutter_yd_weather/widget/load_asset_image.dart';
import 'package:flutter_yd_weather/widget/opacity_layout.dart';
import 'package:provider/provider.dart';

import '../config/constants.dart';
import '../model/weather_item_data.dart';
import '../res/colours.dart';
import '../utils/commons.dart';

class WeatherAirQualityPanel extends StatelessWidget {
  WeatherAirQualityPanel({
    super.key,
    required this.data,
    required this.shrinkOffset,
    this.showHideWeatherContent,
  });

  final WeatherItemData data;
  final double shrinkOffset;
  final void Function(bool show)? showHideWeatherContent;
  final _key = GlobalKey();
  final _airQualityDetailPopupKey = GlobalKey<AirQualityDetailPopupState>();

  @override
  Widget build(BuildContext context) {
    final weatherItemData = data;
    final titlePercent = (1 - shrinkOffset / 12.w).fixPercent();
    final percent = ((weatherItemData.maxHeight - 12.w - shrinkOffset) /
            Constants.itemStickyHeight.w)
        .fixPercent();
    final isDark = context.read<WeatherProvider>().isDark;
    return AnimatedOpacity(
      opacity: percent,
      duration: Duration.zero,
      child: GestureDetector(
        onTap: () {
          showHideWeatherContent?.call(false);
          final contentPosition =
              (_key.currentContext?.findRenderObject() as RenderBox?)
                  ?.localToGlobal(Offset.zero) ??
                  Offset.zero;
          SmartDialog.show(
            maskColor: Colours.transparent,
            animationTime: const Duration(milliseconds: 400),
            clickMaskDismiss: true,
            onDismiss: () {
              _airQualityDetailPopupKey.currentState?.exit();
              Commons.postDelayed(delayMilliseconds: 400, () {
                showHideWeatherContent?.call(true);
              });
            },
            animationBuilder: (
                controller,
                child,
                animationParam,
                ) {
              return child;
            },
            builder: (_) {
              return AirQualityDetailPopup(
                key: _airQualityDetailPopupKey,
                initPosition: contentPosition,
                isDark: isDark,
                evn: weatherItemData.weatherData?.evn,
              );
            },
          );
        },
        child: Stack(
          key: _key,
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
              color: (isDark ? Colours.white : Colours.black).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.w),
              useBlurry: false,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: -shrinkOffset -
                        min(shrinkOffset, Constants.itemStickyHeight.w),
                    right: 0,
                    bottom: 0,
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gaps.generateGap(height: 12.w),
                          AnimatedOpacity(
                            opacity: titlePercent,
                            duration: Duration.zero,
                            child: Row(
                              children: [
                                Text(
                                  "${weatherItemData.weatherData?.evn?.aqi} - ${weatherItemData.weatherData?.evn?.aqiLevelName}",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colours.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                OpacityLayout(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 4.w,
                                    ),
                                    child: LoadAssetImage(
                                      "ic_query_icon",
                                      width: 14.w,
                                      height: 14.w,
                                      color: Colours.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    SmartDialog.show(
                                      tag: "AirQualityQueryDialog",
                                      alignment: Alignment.bottomCenter,
                                      builder: (_) {
                                        return const AirQualityQueryDialog();
                                      },
                                    );
                                  },
                                ),
                              ],
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
            AnimatedOpacity(
              opacity: 1 - titlePercent,
              duration: Duration.zero,
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
      ),
    );
  }
}
