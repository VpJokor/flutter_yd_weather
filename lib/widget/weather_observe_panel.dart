import 'package:flutter/material.dart';
import 'package:flutter_yd_weather/widget/weather_observe_static_panel.dart';
import 'package:provider/provider.dart';

import '../model/weather_item_data.dart';
import '../pages/provider/weather_provider.dart';

class WeatherObservePanel extends StatelessWidget {
  const WeatherObservePanel({
    super.key,
    required this.data,
    required this.shrinkOffset,
    this.showHideWeatherContent,
  });

  final WeatherItemData data;
  final double shrinkOffset;
  final void Function(bool show)? showHideWeatherContent;

  @override
  Widget build(BuildContext context) {
    final mainP = context.read<WeatherProvider>();
    return WeatherObserveStaticPanel(
      data: data,
      shrinkOffset: shrinkOffset,
      isDark: mainP.isDark,
      isWeatherHeaderDark: mainP.isWeatherHeaderDark,
      panelOpacity: mainP.panelOpacity,
      showHideWeatherContent: showHideWeatherContent,
    );
  }
}
