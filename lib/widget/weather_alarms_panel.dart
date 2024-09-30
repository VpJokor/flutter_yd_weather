import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_yd_weather/model/weather_item_data.dart';
import 'package:flutter_yd_weather/res/colours.dart';
import 'package:flutter_yd_weather/utils/commons.dart';
import 'package:flutter_yd_weather/widget/weather_alarms_detail_popup.dart';
import 'package:flutter_yd_weather/widget/weather_alarms_static_panel.dart';
import 'package:provider/provider.dart';

import '../pages/provider/weather_provider.dart';

class WeatherAlarmsPanel extends StatefulWidget {
  const WeatherAlarmsPanel({
    super.key,
    required this.data,
    required this.shrinkOffset,
    this.showHideWeatherContent,
  });

  final WeatherItemData data;
  final double shrinkOffset;
  final void Function(bool show)? showHideWeatherContent;

  @override
  State<StatefulWidget> createState() => _WeatherAlarmsPanelState();
}

class _WeatherAlarmsPanelState extends State<WeatherAlarmsPanel> {
  final _key = GlobalKey();
  final _alarmsDetailPopupKey = GlobalKey<WeatherAlarmsDetailPopupState>();
  int _index = 0;
  late SwiperController _swiperController;

  @override
  void initState() {
    super.initState();
    _swiperController = SwiperController();
  }

  @override
  void dispose() {
    super.dispose();
    _swiperController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mainP = context.read<WeatherProvider>();
    final isDark = mainP.isDark;
    return WeatherAlarmsStaticPanel(
      weatherItemData: widget.data,
      shrinkOffset: widget.shrinkOffset,
      isDark: isDark,
      panelOpacity: mainP.panelOpacity,
      stackKey: _key,
      swiperController: _swiperController,
      index: _index,
      onIndexChanged: (index) {
        setState(() {
          _index = index;
        });
      },
      onTap: () {
        widget.showHideWeatherContent?.call(false);
        final contentPosition =
            (_key.currentContext?.findRenderObject() as RenderBox?)
                    ?.localToGlobal(Offset.zero) ??
                Offset.zero;
        final contentHeight = _key.currentContext?.size?.height ?? 0;
        SmartDialog.show(
          maskColor: Colours.transparent,
          animationTime: const Duration(milliseconds: 200),
          clickMaskDismiss: true,
          onDismiss: () {
            _alarmsDetailPopupKey.currentState?.exit();
            Commons.postDelayed(delayMilliseconds: 200, () {
              widget.showHideWeatherContent?.call(true);
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
            return WeatherAlarmsDetailPopup(
              key: _alarmsDetailPopupKey,
              alarms: widget.data.weatherData?.alarms ?? [],
              initPosition: contentPosition,
              initHeight: contentHeight,
              index: _index,
              isDark: isDark,
              panelOpacity: mainP.panelOpacity,
              onIndexChanged: (index) {
                _swiperController.move(index);
              },
            );
          },
        );
      },
    );
  }
}
