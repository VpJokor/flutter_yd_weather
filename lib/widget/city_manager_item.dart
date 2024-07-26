import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/main.dart';
import 'package:flutter_yd_weather/provider/main_provider.dart';
import 'package:flutter_yd_weather/res/gaps.dart';
import 'package:flutter_yd_weather/routers/fluro_navigator.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/widget/scale_layout.dart';
import 'package:provider/provider.dart';

import '../res/colours.dart';
import '../routers/routers.dart';
import 'load_asset_image.dart';

class CityManagerItem extends StatefulWidget {
  const CityManagerItem({
    super.key,
    required this.index,
    this.generateKey,
  });

  final int index;
  final void Function(String cityId, GlobalKey<CityManagerItemState> key)? generateKey;

  @override
  State<StatefulWidget> createState() => CityManagerItemState();
}

class CityManagerItemState extends State<CityManagerItem> {
  final _key = GlobalKey<CityManagerItemState>();

  @override
  Widget build(BuildContext context) {
    final mainP = context.read<MainProvider>();
    final cityData = mainP.cityDataBox.getAt(widget.index);
    final weatherData = cityData?.weatherData;
    widget.generateKey?.call(cityData?.cityId??"", _key);
    return ScaleLayout(
      scale: 0.95,
      onPressed: () {
        if (cityData?.cityId != mainP.currentCityData?.cityId) {
          mainP.currentCityData = cityData;
          eventBus.fire(RefreshWeatherDataEvent());
        }
        NavigatorUtils.goBackUntil(context, Routes.main);
      },
      child: Container(
        key: _key,
        width: double.infinity,
        height: 98.w,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.w),
          gradient: const LinearGradient(
            colors: [
              Colours.color464E96,
              Colours.color547EA9,
              Colours.color409AAF,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      weatherData?.city ?? "",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colours.white,
                        height: 1,
                        fontFamily: "RobotoLight",
                      ),
                    ),
                    Visibility(
                      visible: cityData?.isLocationCity == true,
                      child: LoadAssetImage(
                        "writing_icon_location1",
                        width: 22.w,
                        height: 22.w,
                        color: Colours.white,
                      ),
                    ),
                  ],
                ),
                Gaps.generateGap(height: 4.w),
                Text(
                  "${weatherData?.weatherDesc} ${weatherData?.tempHigh
                      .getTemp()} / ${weatherData?.tempLow.getTemp()}",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colours.white,
                    fontFamily: "RobotoLight",
                    height: 1,
                  ),
                ),
              ],
            ),
            Text(
              weatherData?.temp.getTemp() ?? "",
              style: TextStyle(
                fontSize: 38.sp,
                color: Colours.white,
                height: 1,
                fontFamily: "RobotoLight",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
