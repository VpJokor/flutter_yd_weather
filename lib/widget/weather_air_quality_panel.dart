import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_yd_weather/pages/provider/weather_provider.dart';
import 'package:flutter_yd_weather/widget/air_quality_detail_popup.dart';
import 'package:flutter_yd_weather/widget/weather_air_quality_static_panel.dart';
import 'package:provider/provider.dart';
import '../model/weather_item_data.dart';
import '../res/colours.dart';
import '../utils/commons.dart';

class WeatherAirQualityPanel extends StatelessWidget {
  WeatherAirQualityPanel({
    super.key,
    required this.data,
    required this.shrinkOffset,
    this.showHideWeatherContent,
  });

  final WeatherItemData data;
  final double shrinkOffset;
  final void Function(bool show)? showHideWeatherContent;
  final _key = GlobalKey();
  final _airQualityDetailPopupKey = GlobalKey<AirQualityDetailPopupState>();

  @override
  Widget build(BuildContext context) {
    final mainP = context.read<WeatherProvider>();
    final isDark = mainP.isDark;
    return WeatherAirQualityStaticPanel(
      weatherItemData: data,
      shrinkOffset: shrinkOffset,
      isDark: isDark,
      panelOpacity: mainP.panelOpacity,
      stackKey: _key,
      onTap: () {
        showHideWeatherContent?.call(false);
        final contentPosition =
            (_key.currentContext?.findRenderObject() as RenderBox?)
                    ?.localToGlobal(Offset.zero) ??
                Offset.zero;
        SmartDialog.show(
          maskColor: Colours.transparent,
          animationTime: const Duration(milliseconds: 400),
          clickMaskDismiss: true,
          onDismiss: () {
            _airQualityDetailPopupKey.currentState?.exit();
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
            return AirQualityDetailPopup(
              key: _airQualityDetailPopupKey,
              initPosition: contentPosition,
              isDark: isDark,
              panelOpacity: mainP.panelOpacity,
              evn: data.weatherData?.evn,
            );
          },
        );
      },
    );
  }
}
