import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/main.dart';
import 'package:flutter_yd_weather/provider/main_provider.dart';
import 'package:flutter_yd_weather/res/gaps.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/widget/scale_layout.dart';
import 'package:provider/provider.dart';

import '../res/colours.dart';
import '../utils/commons.dart';
import 'load_asset_image.dart';

class CityManagerItem extends StatefulWidget {
  const CityManagerItem({
    super.key,
    required this.index,
    this.onTap,
  });

  final int index;
  final VoidCallback? onTap;

  @override
  State<StatefulWidget> createState() => CityManagerItemState();
}

class CityManagerItemState extends State<CityManagerItem> {
  @override
  Widget build(BuildContext context) {
    final mainP = context.read<MainProvider>();
    final cityData = mainP.cityDataBox.getAt(widget.index);
    final weatherData = cityData?.weatherData;
    final isNight = Commons.isNight(DateTime.now());
    return ScaleLayout(
      scale: 0.95,
      onPressed: () {
        if (cityData?.cityId != mainP.currentCityData?.cityId) {
          mainP.currentCityData = cityData;
          eventBus.fire(RefreshWeatherDataEvent());
        }
        widget.onTap?.call();
      },
      child: Container(
        width: double.infinity,
        height: 98.w,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.w),
        ),
        child: Stack(
          children: [
            ExtendedImage.network(
              (isNight
                      ? weatherData?.nightWeatherCardBg
                      : weatherData?.dayWeatherCardBg) ??
                  "",
              width: double.infinity,
              fit: BoxFit.cover,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16.w),
              loadStateChanged:
                  Commons.loadStateChanged(placeholder: Colours.transparent),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
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
                        "${weatherData?.weatherDesc} ${weatherData?.tempHigh.getTemp()} / ${weatherData?.tempLow.getTemp()}",
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
          ],
        ),
      ),
    );
  }
}
