import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/model/weather_item_data.dart';
import 'package:flutter_yd_weather/utils/pair.dart';
import 'package:flutter_yd_weather/widget/weather_city_snapshot.dart';

import '../model/city_data.dart';

class WeatherCitySelectorItem extends StatelessWidget {
  const WeatherCitySelectorItem({
    super.key,
    required this.pair,
  });

  final Pair<CityData?, List<WeatherItemData>>? pair;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenUtil().screenWidth * 0.6,
      height: ScreenUtil().screenHeight * 0.6,
      child: OverflowBox(
        alignment: Alignment.topLeft,
        maxWidth: ScreenUtil().screenWidth,
        maxHeight: ScreenUtil().screenHeight,
        child: Transform.scale(
          alignment: Alignment.topLeft,
          scale: 0.6,
          child: WeatherCitySnapshot(
            cityData: pair?.first,
            data: pair?.second,
          ),
        ),
      ),
    );
  }
}
