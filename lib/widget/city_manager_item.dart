import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_yd_weather/main.dart';
import 'package:flutter_yd_weather/model/city_manager_data.dart';
import 'package:flutter_yd_weather/provider/main_provider.dart';
import 'package:flutter_yd_weather/res/gaps.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/utils/weather_bg_utils.dart';
import 'package:flutter_yd_weather/widget/scale_layout.dart';
import 'package:flutter_yd_weather/widget/yd_reorderable_list.dart';
import 'package:provider/provider.dart';

import '../res/colours.dart';
import '../utils/commons.dart';
import 'city_manager_slidable_action.dart';
import 'load_asset_image.dart';

class CityManagerItem extends StatefulWidget {
  const CityManagerItem({
    super.key,
    required this.cityManagerData,
    required this.slidableController,
    this.onTap,
  });

  final CityManagerData cityManagerData;
  final VoidCallback? onTap;
  final SlidableController slidableController;

  @override
  State<StatefulWidget> createState() => CityManagerItemState();
}

class CityManagerItemState extends State<CityManagerItem> {
  @override
  Widget build(BuildContext context) {
    final mainP = context.read<MainProvider>();
    final cityData = widget.cityManagerData.cityData;
    final weatherData = cityData?.weatherData;
    final content = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Slidable(
        controller: widget.slidableController,
        key: widget.cityManagerData.key,
        enabled: !(cityData?.isLocationCity ?? false),
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: 0.2,
          children: [
            AnimatedBuilder(
              animation: widget.slidableController.animation,
              builder: (_, __) {
                return CityManagerSlidableAction(
                  percent: (widget.slidableController.animation.value / 0.2)
                      .fixPercent(),
                  onTap: () {},
                );
              },
            ),
          ],
        ),
        child: ScaleLayout(
          scale: 0.95,
          onPressed: () {
            if (cityData?.cityId != mainP.currentCityData?.cityId) {
              mainP.currentCityData = cityData;
              eventBus.fire(RefreshWeatherDataEvent());
            }
            widget.onTap?.call();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            height: 98.w,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.w),
              gradient: WeatherBgUtils.getWeatherBg(
                  weatherData?.weatherType ?? "",
                  Commons.isNight(DateTime.now())),
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
        ),
      ),
    );
    return (cityData?.isLocationCity ?? false)
        ? content
        : YdReorderableItem(
            key: widget.cityManagerData.key, //
            childBuilder: (_, state) {
              return DelayedReorderableListener(
                child: AnimatedOpacity(
                  opacity:
                      state == ReorderableItemState.placeholder ? 0.0 : 1.0,
                  duration: Duration.zero,
                  child: content,
                ),
              );
            },
          );
  }
}
