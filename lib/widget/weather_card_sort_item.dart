import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/res/colours.dart';
import 'package:flutter_yd_weather/widget/yd_reorderable_list.dart';

import 'load_asset_image.dart';

class WeatherCardSortItem extends StatefulWidget {
  const WeatherCardSortItem({
    super.key,
    required this.weatherCardItemType,
  });

  final int weatherCardItemType;

  @override
  State<StatefulWidget> createState() => _WeatherCardSortItemState();
}

class _WeatherCardSortItemState extends State<WeatherCardSortItem> {
  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.w),
        color: context.cardColor06,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                _getTitle(),
                style: TextStyle(
                  fontSize: 16.sp,
                  color: context.black,
                  height: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Visibility(
                visible:
                    widget.weatherCardItemType == Constants.itemTypeObserve,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: LoadAssetImage(
                    "ic_sort_icon",
                    width: 18.w,
                    height: 18.w,
                    color: Colours.color999999,
                  ),
                ),
              ),
            ],
          ),
          LoadAssetImage(
            "ic_menu_icon",
            width: 24.w,
            height: 24.w,
            color: Colours.color999999,
          ),
        ],
      ),
    );
    return YdReorderableItem(
      key: ValueKey(widget.weatherCardItemType),
      childBuilder: (_, state) {
        return AnimatedOpacity(
          opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
          duration: Duration.zero,
          child: DelayedReorderableListener(
            child: content,
          ),
        );
      },
    );
  }

  String _getTitle() {
    switch (widget.weatherCardItemType) {
      case Constants.itemTypeAlarms:
        return "极端天气";
      case Constants.itemTypeAirQuality:
        return "空气质量";
      case Constants.itemTypeHourWeather:
        return "每小时天气预报";
      case Constants.itemTypeDailyWeather:
        return "15日天气预报";
      case Constants.itemTypeObserve:
        return "天气指数";
      case Constants.itemTypeLifeIndex:
        return "生活指数";
    }
    return "";
  }
}
