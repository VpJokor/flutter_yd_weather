import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/res/colours.dart';

import '../config/constants.dart';
import 'load_asset_image.dart';

class WeatherObserveCardSortItem extends StatelessWidget {
  const WeatherObserveCardSortItem({
    super.key,
    required this.itemType,
    required this.index,
  });

  final int itemType;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (ScreenUtil().screenWidth - 16.w * 2 - 12.w) / 2,
      height: 48.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.w),
        color: context.cardColor06,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          LoadAssetImage(
            "ic_menu_icon",
            width: 24.w,
            height: 24.w,
            color: Colours.color999999,
          ),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (itemType) {
      case Constants.itemTypeObserveUv:
        return "紫外线指数";
      case Constants.itemTypeObserveShiDu:
        return "湿度";
      case Constants.itemTypeObserveTiGan:
        return "体感温度";
      case Constants.itemTypeObserveWd:
        return "风向";
      case Constants.itemTypeObserveSunriseSunset:
        return "日出日落";
      case Constants.itemTypeObservePressure:
        return "气压";
      case Constants.itemTypeObserveVisibility:
        return "可见度";
      case Constants.itemTypeObserveForecast40:
        return "未来40日天气";
    }
    return "";
  }
}
