import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/widget/weather_forecase40_detail_page.dart';

import '../config/constants.dart';
import '../model/weather_item_data.dart';
import '../res/colours.dart';
import '../res/gaps.dart';
import '../utils/commons.dart';
import 'blurry_container.dart';

class WeatherObserveForecase40Panel extends StatelessWidget {
  WeatherObserveForecase40Panel({
    super.key,
    required this.data,
    required this.shrinkOffset,
    required this.isDark,
    this.showHideWeatherContent,
  });

  final WeatherItemData data;
  final double shrinkOffset;
  final void Function(bool show)? showHideWeatherContent;
  final _key = GlobalKey();
  final _forecase40DetailPageKey =
      GlobalKey<WeatherForecase40DetailPageState>();
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final weatherItemData = data;
    final percent =
        ((Constants.itemObservePanelHeight.w - 12.w - shrinkOffset) /
                Constants.itemStickyHeight.w)
            .fixPercent();
    final upDays = weatherItemData.weatherData?.forecast40Data?.upDays ?? 0;
    final rainDays = weatherItemData.weatherData?.forecast40Data?.rainDays ?? 0;
    final upDaysDesc = upDays > 0 ? "$upDays天升温" : "预计近期气温平稳";
    final rainDaysDesc = rainDays > 0 ? "$rainDays天有雨" : "预计近期无降雨";
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
          final size = _key.currentContext?.size ?? Size.zero;
          SmartDialog.show(
            tag: "WeatherForecase40DetailPage",
            maskColor: Colours.transparent,
            animationTime: const Duration(milliseconds: 400),
            clickMaskDismiss: false,
            onDismiss: () {
              _forecase40DetailPageKey.currentState?.exit();
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
              return WeatherForecase40DetailPage(
                key: _forecase40DetailPageKey,
                initPosition: contentPosition,
                size: size,
                isDark: isDark,
                forecast40Data: weatherItemData.weatherData?.forecast40Data,
                forecast40: weatherItemData.weatherData?.forecast40,
                meta: weatherItemData.weatherData?.meta,
              );
            },
          );
        },
        child: Stack(
          key: _key,
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
                color:
                    (isDark ? Colours.white : Colours.black).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.w),
                padding: EdgeInsets.only(
                  top: Constants.itemStickyHeight.w,
                ),
                useBlurry: false,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: -shrinkOffset,
                      right: 0,
                      bottom: 0,
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "温度趋势",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colours.white.withOpacity(0.6),
                                height: 1,
                              ),
                            ),
                            Gaps.generateGap(height: 8.w),
                            Text(
                              upDaysDesc,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colours.white,
                                height: 1,
                              ),
                            ),
                            Gaps.generateGap(height: 16.w),
                            Text(
                              "降水趋势",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colours.white.withOpacity(0.6),
                                height: 1,
                              ),
                            ),
                            Gaps.generateGap(height: 8.w),
                            Text(
                              rainDaysDesc,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colours.white,
                                height: 1,
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
                        Constants.itemObservePanelHeight.w - shrinkOffset)
                    .positiveNumber(),
                padding: EdgeInsets.only(left: 16.w),
                alignment: Alignment.centerLeft,
                child: Text(
                  "未来40日天气",
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
