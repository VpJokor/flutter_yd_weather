import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/model/weather_item_data.dart';
import 'package:flutter_yd_weather/res/colours.dart';
import 'package:flutter_yd_weather/utils/log.dart';

class WeatherPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  WeatherPersistentHeaderDelegate(
    this.weatherItemData,
  );

  final WeatherItemData weatherItemData;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final maxHeight = weatherItemData.maxHeight;
    final minHeight = weatherItemData.minHeight;
    final percent = 1 - shrinkOffset / maxHeight;
    final height = maxHeight - shrinkOffset < minHeight
        ? minHeight
        : maxHeight - shrinkOffset;
    Log.e(
        "shrinkOffset = $shrinkOffset overlapsContent = $overlapsContent percent = $percent height = $height");
    return Opacity(
      opacity: percent,
      child: Container(
        height: 48.w,
        color: weatherItemData.itemType == Constants.itemTypeWeatherHeader
            ? Colours.white
            : Colours.black,
        margin: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        child: Text(
          "${weatherItemData.itemType}",
          style: TextStyle(
            fontSize: 12.sp,
            color: weatherItemData.itemType == Constants.itemTypeWeatherHeader
                ? Colours.black
                : Colours.white,
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 48.w;

  @override
  double get minExtent => 48.w;

  @override
  bool shouldRebuild(covariant WeatherPersistentHeaderDelegate oldDelegate) {
    final rebuild = weatherItemData != oldDelegate.weatherItemData;
    Log.e("rebuild = $rebuild");
    return true;
  }
}
