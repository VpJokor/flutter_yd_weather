import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/widget/weather_observe_forecast40_panel.dart';
import 'package:flutter_yd_weather/widget/weather_observe_pressure_panel.dart';
import 'package:flutter_yd_weather/widget/weather_observe_shi_du_panel.dart';
import 'package:flutter_yd_weather/widget/weather_observe_sunrise_sunset_panel.dart';
import 'package:flutter_yd_weather/widget/weather_observe_ti_gan_panel.dart';
import 'package:flutter_yd_weather/widget/weather_observe_uv_panel.dart';
import 'package:flutter_yd_weather/widget/weather_observe_visibility_panel.dart';
import 'package:flutter_yd_weather/widget/weather_observe_wd_panel.dart';

import '../config/constants.dart';
import '../model/weather_item_data.dart';

class WeatherObserveStaticPanel extends StatelessWidget {
  const WeatherObserveStaticPanel({
    super.key,
    required this.data,
    required this.shrinkOffset,
    required this.isDark,
    required this.isWeatherHeaderDark,
    required this.panelOpacity,
    this.showHideWeatherContent,
  });

  final WeatherItemData data;
  final double shrinkOffset;
  final bool isDark;
  final bool isWeatherHeaderDark;
  final double panelOpacity;
  final void Function(bool show)? showHideWeatherContent;

  @override
  Widget build(BuildContext context) {
    final crossAxisSpacing = 12.w;
    final mainAxisSpacing = 12.w;
    final leftRightSpacing = 16.w;
    final observePanelWidth =
        (ScreenUtil().screenWidth - 2 * leftRightSpacing - crossAxisSpacing) /
            2;
    final observePanels = <Widget>[];
    Widget buildPositioned(Widget child, int index) {
      final line = index ~/ 2;
      final column = index % 2;
      final left = column * (observePanelWidth + crossAxisSpacing);
      final top = line * (Constants.itemObservePanelHeight.w + mainAxisSpacing);
      return Positioned(
        left: left,
        top: top,
        child: SizedBox(
          width: observePanelWidth,
          height: Constants.itemObservePanelHeight.w,
          child: child,
        ),
      );
    }

    data.itemTypeObserves.forEachIndexed((itemTypeObserve, index) {
      final line = index ~/ 2;
      double fixedShrinkOffset = shrinkOffset -
          (Constants.itemObservePanelHeight.w + mainAxisSpacing) * line;
      if (fixedShrinkOffset < 0) fixedShrinkOffset = 0;
      switch (itemTypeObserve) {
        case Constants.itemTypeObserveUv:
          observePanels.add(
            buildPositioned(
              WeatherObserveUvPanel(
                data: data,
                shrinkOffset: fixedShrinkOffset,
                isDark: isDark,
                panelOpacity: panelOpacity,
              ),
              index,
            ),
          );
          break;
        case Constants.itemTypeObserveShiDu:
          observePanels.add(
            buildPositioned(
              WeatherObserveShiDuPanel(
                data: data,
                shrinkOffset: fixedShrinkOffset,
                isDark: isDark,
                panelOpacity: panelOpacity,
              ),
              index,
            ),
          );
          break;
        case Constants.itemTypeObserveTiGan:
          observePanels.add(
            buildPositioned(
              WeatherObserveTiGanPanel(
                data: data,
                shrinkOffset: fixedShrinkOffset,
                isDark: isDark,
                panelOpacity: panelOpacity,
              ),
              index,
            ),
          );
          break;
        case Constants.itemTypeObserveWd:
          observePanels.add(
            buildPositioned(
              WeatherObserveWdPanel(
                data: data,
                shrinkOffset: fixedShrinkOffset,
                isDark: isDark,
                panelOpacity: panelOpacity,
              ),
              index,
            ),
          );
          break;
        case Constants.itemTypeObserveSunriseSunset:
          observePanels.add(
            buildPositioned(
              WeatherObserveSunriseSunsetPanel(
                data: data,
                shrinkOffset: fixedShrinkOffset,
                isDark: isDark,
                panelOpacity: panelOpacity,
              ),
              index,
            ),
          );
          break;
        case Constants.itemTypeObservePressure:
          observePanels.add(
            buildPositioned(
              WeatherObservePressurePanel(
                data: data,
                shrinkOffset: fixedShrinkOffset,
                isDark: isDark,
                panelOpacity: panelOpacity,
              ),
              index,
            ),
          );
          break;
        case Constants.itemTypeObserveVisibility:
          observePanels.add(
            buildPositioned(
              WeatherObserveVisibilityPanel(
                data: data,
                shrinkOffset: fixedShrinkOffset,
                isDark: isDark,
                panelOpacity: panelOpacity,
              ),
              index,
            ),
          );
          break;
        case Constants.itemTypeObserveForecast40:
          observePanels.add(
            buildPositioned(
              WeatherObserveForecase40Panel(
                data: data,
                shrinkOffset: fixedShrinkOffset,
                showHideWeatherContent: showHideWeatherContent,
                isDark: isDark,
                isWeatherHeaderDark: isWeatherHeaderDark,
                panelOpacity: panelOpacity,
              ),
              index,
            ),
          );
          break;
      }
    });

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.w),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: -shrinkOffset,
            right: 0,
            bottom: 0,
            child: Stack(
              fit: StackFit.passthrough,
              children: observePanels,
            ),
          ),
        ],
      ),
    );
  }
}
