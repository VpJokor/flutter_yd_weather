import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/model/weather_item_data.dart';
import 'package:flutter_yd_weather/provider/main_provider.dart';
import 'package:flutter_yd_weather/utils/commons.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/widget/weather_header_static_panel.dart';
import 'package:provider/provider.dart';
import '../pages/provider/weather_provider.dart';
import '../utils/log.dart';

class WeatherHeaderWidget extends StatefulWidget {
  const WeatherHeaderWidget({
    super.key,
    required this.weatherItemData,
    this.onRefresh,
  });

  final WeatherItemData? weatherItemData;
  final void Function()? onRefresh;

  @override
  State<StatefulWidget> createState() => WeatherHeaderWidgetState();
}

class WeatherHeaderWidgetState extends State<WeatherHeaderWidget> {
  double _currentHeight = 0;
  double _marginTop = 0;
  final _currentMarginTop = 44.w;
  final _minMarginTop = 22.w;
  final _refreshTriggerOffset = 128.w;
  Duration _refreshDuration = Duration.zero;
  double _opacity1 = 1;
  double _opacity2 = 1;
  double _opacity3 = 1;
  double _opacity4 = 0;
  double _refreshOpacity = 0;
  int _refreshStatus = Constants.refreshNone;

  @override
  void initState() {
    super.initState();
    _currentHeight = widget.weatherItemData?.maxHeight ?? 0;
    Log.e("_currentHeight = $_currentHeight");
    _marginTop = _currentMarginTop;
  }

  @override
  void didUpdateWidget(covariant WeatherHeaderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_currentHeight <= 0) {
      setState(() {
        _currentHeight = widget.weatherItemData?.maxHeight ?? 0;
      });
    }
  }

  void change(double offset, double percent) {
    // Log.e("offset = $offset percent = $percent");
    final newPercent = percent.fixPercent();
    setState(() {
      final marginTop =
          _minMarginTop + (_currentMarginTop - _minMarginTop) * (1 - percent);
      _marginTop = marginTop < _minMarginTop ? _minMarginTop : marginTop;
      final currentHeight = (widget.weatherItemData?.maxHeight ?? 0) - offset;
      _currentHeight = currentHeight < (widget.weatherItemData?.minHeight ?? 0)
          ? (widget.weatherItemData?.minHeight ?? 0)
          : currentHeight;
      final opacity1 = 1 - (newPercent - 0.2) / (0.3 - 0.2);
      _opacity1 = opacity1 > 1 ? 1 : (opacity1 < 0 ? 0 : opacity1);
      final opacity2 = 1 - (newPercent - 0.4) / (0.5 - 0.4);
      _opacity2 = opacity2 > 1 ? 1 : (opacity2 < 0 ? 0 : opacity2);
      final opacity3 = 1 - (newPercent - 0.7) / (0.8 - 0.7);
      _opacity3 = opacity3 > 1 ? 1 : (opacity3 < 0 ? 0 : opacity3);
      final opacity4 = 1 - (newPercent - 0.9) / (0.9 - 1.0);
      _opacity4 = opacity4 > 1 ? 1 : (opacity4 < 0 ? 0 : opacity4);
      _refreshOpacity = (_refreshStatus == Constants.refreshing ||
              _refreshStatus == Constants.refreshComplete)
          ? 1
          : offset < 0
              ? (offset / _refreshTriggerOffset).abs().fixPercent()
              : 0;
    });
  }

  void onRelease() {
    if (_refreshStatus == Constants.refreshing) return;
    if (_refreshOpacity >= 1) {
      widget.onRefresh?.call();
      setState(() {
        _refreshStatus = Constants.refreshing;
      });
    }
  }

  void refreshComplete() {
    if (_refreshStatus == Constants.refreshing) {
      setState(() {
        _refreshStatus = Constants.refreshComplete;
        Commons.postDelayed(delayMilliseconds: 400, () {
          setState(() {
            _refreshDuration = const Duration(milliseconds: 300);
            _refreshOpacity = 0;
            _refreshStatus = Constants.refreshed;
            Commons.postDelayed(delayMilliseconds: 300, () {
              setState(() {
                _refreshStatus = Constants.refreshNone;
                _refreshDuration = Duration.zero;
              });
            });
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherData = widget.weatherItemData?.weatherData;
    String refreshDesc = "释放刷新";
    if (_refreshStatus == Constants.refreshing) {
      refreshDesc = "正在刷新";
    } else if (_refreshStatus == Constants.refreshComplete ||
        _refreshStatus == Constants.refreshed) {
      refreshDesc = "刷新完成";
    }
    final isDark = context.read<WeatherProvider>().isWeatherHeaderDark;
    return WeatherHeaderStaticPanel(
      isDark: isDark,
      weatherData: weatherData,
      cityData: context.read<MainProvider>().currentCityData,
      height: _currentHeight,
      marginTopContainerHeight: _marginTop,
      refreshOpacity: _refreshOpacity,
      refreshDuration: _refreshDuration,
      refreshDesc: refreshDesc,
      opacity1: _opacity1,
      opacity2: _opacity2,
      opacity3: _opacity3,
      opacity4: _opacity4,
    );
  }
}
