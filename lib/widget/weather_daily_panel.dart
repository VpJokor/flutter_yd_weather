import 'package:flutter/material.dart';
import 'package:flutter_yd_weather/widget/weather_daily_static_panel.dart';
import 'package:provider/provider.dart';
import '../model/weather_item_data.dart';
import '../pages/provider/weather_provider.dart';

class WeatherDailyPanel extends StatelessWidget {
  const WeatherDailyPanel({
    super.key,
    required this.data,
    required this.shrinkOffset,
  });

  final WeatherItemData data;
  final double shrinkOffset;

  @override
  Widget build(BuildContext context) {
    final mainP = context.read<WeatherProvider>();
    return WeatherDailyStaticPanel(
      weatherItemData: data,
      shrinkOffset: shrinkOffset,
      isDark: mainP.isDark,
      panelOpacity: mainP.panelOpacity,
    );
  }
}
