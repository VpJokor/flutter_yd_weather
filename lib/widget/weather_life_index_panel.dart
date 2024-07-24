import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/res/gaps.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/widget/scale_layout.dart';

import '../config/constants.dart';
import '../model/weather_item_data.dart';
import '../res/colours.dart';
import '../utils/commons.dart';
import 'blurry_container.dart';

class WeatherLifeIndexPanel extends StatelessWidget {
  const WeatherLifeIndexPanel({
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
            color: Colours.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.w),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: -shrinkOffset,
                  right: 0,
                  bottom: 0,
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    removeBottom: true,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        /// 每行 widget 数量
                        crossAxisCount: 3,
                        childAspectRatio: 1 / 1,
                      ),
                      itemBuilder: (_, index) {
                        final item =
                        weatherItemData.weatherData?.indexes.getOrNull(index);
                        return ScaleLayout(
                          child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ExtendedImage.network(
                                  item?.ext?.icon ?? "",
                                  width: 48.w,
                                  height: 48.w,
                                  fit: BoxFit.cover,
                                  loadStateChanged: Commons.loadStateChanged(
                                      placeholder: Colours.transparent),
                                ),
                                Gaps.generateGap(height: 8.w),
                                Text(
                                  item?.name ?? "",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colours.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount:
                      weatherItemData.weatherData?.indexes?.length ?? 0,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: Constants.itemStickyHeight.w,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.only(left: 16.w),
            alignment: Alignment.centerLeft,
            child: Text(
              "生活指数",
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
