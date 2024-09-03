import 'package:bubble_box/bubble_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_yd_weather/config/app_runtime_data.dart';
import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/provider/main_provider.dart';
import 'package:flutter_yd_weather/res/colours.dart';
import 'package:flutter_yd_weather/res/gaps.dart';
import 'package:flutter_yd_weather/utils/commons.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/widget/blurry_container.dart';
import 'package:flutter_yd_weather/widget/opacity_layout.dart';
import 'package:flutter_yd_weather/widget/scale_layout.dart';
import 'package:flutter_yd_weather/widget/weather_bg_color_selector.dart';
import 'package:flutter_yd_weather/widget/weather_city_snapshot.dart';
import 'package:provider/provider.dart';

import '../model/weather_bg_model.dart';
import '../utils/color_utils.dart';
import '../utils/toast_utils.dart';
import '../utils/weather_data_utils.dart';

class WeatherBgEditDialog extends StatefulWidget {
  const WeatherBgEditDialog({
    super.key,
    required this.weatherBgModel,
    this.onConfirm,
  });

  final WeatherBgModel? weatherBgModel;
  final void Function(List<Color> colors)? onConfirm;

  @override
  State<StatefulWidget> createState() => WeatherBgEditDialogState();
}

class WeatherBgEditDialogState extends State<WeatherBgEditDialog>
    with SingleTickerProviderStateMixin {
  bool _isNight = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final _hColorSelectorKey = GlobalKey<WeatherBgColorSelectorState>();
  final _sColorSelectorKey = GlobalKey<WeatherBgColorSelectorState>();
  final _vColorSelectorKey = GlobalKey<WeatherBgColorSelectorState>();
  List<Color> _originColors = [];
  List<Color> _originNightColors = [];
  List<Color> _colors = [];
  List<Color> _nightColors = [];
  List<HSVColor> _hsvColors = [];
  List<HSVColor> _hsvNightColors = [];
  bool _isStartSelected = true;

  @override
  void initState() {
    super.initState();
    _colors =
        widget.weatherBgModel?.colors?.map((e) => Color(e)).toList() ?? [];
    _nightColors =
        (widget.weatherBgModel?.nightColors ?? widget.weatherBgModel?.colors)
                ?.map((e) => Color(e))
                .toList() ??
            [];
    _originColors = [..._colors];
    _originNightColors = [..._nightColors];
    _hsvColors = _colors.map((e) => HSVColor.fromColor(e)).toList();
    _hsvNightColors = _nightColors.map((e) => HSVColor.fromColor(e)).toList();
    _animationController = AnimationController(vsync: this)
      ..duration = const Duration(milliseconds: 200);
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
    Commons.post((_) {
      _changeColorSelectorValue();
    });
  }

  void exit() {
    _animationController.reverse();
  }

  void _dismiss() {
    SmartDialog.dismiss(tag: "WeatherBgEditDialog");
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mainP = context.read<MainProvider>();
    final key = (mainP.currentCityData?.isLocationCity ?? false)
        ? Constants.locationCityId
        : mainP.currentCityData?.cityId;
    final weatherData = AppRuntimeData.instance.getWeatherData(key ?? "");
    final data = WeatherDataUtils.generateWeatherItems(
      mainP.currentWeatherCardSort,
      mainP.currentWeatherObservesCardSort,
      weatherData,
    );
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, __) {
        final animValue = _animation.value;
        return BlurryContainer(
          width: double.infinity,
          height: double.infinity,
          color:
              ColorUtils.adjustAlpha(Colours.black.withOpacity(0.2), animValue),
          blur: 18 * animValue,
          borderRadius: BorderRadius.zero,
          child: AnimatedOpacity(
            opacity: animValue,
            duration: Duration.zero,
            child: Column(
              children: [
                Gaps.generateGap(height: ScreenUtil().statusBarHeight),
                Container(
                  width: double.infinity,
                  height: 64.w,
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: OpacityLayout(
                          onPressed: () {
                            if (_isNight) {
                              setState(() {
                                _isStartSelected = true;
                                _isNight = false;
                                _changeColorSelectorValue();
                              });
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            margin: EdgeInsets.symmetric(vertical: 12.w),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.w),
                              color: Colours.white.withOpacity(
                                _isNight ? 0 : 0.25,
                              ),
                            ),
                            child: Text(
                              "日间",
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colours.white,
                                fontWeight: _isNight ? null : FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: OpacityLayout(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            margin: EdgeInsets.symmetric(vertical: 12.w),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.w),
                              color: Colours.white.withOpacity(
                                _isNight ? 0.25 : 0,
                              ),
                            ),
                            child: Text(
                              "夜间",
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colours.white,
                                fontWeight: _isNight ? FontWeight.bold : null,
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (!_isNight) {
                              setState(() {
                                _isStartSelected = true;
                                _isNight = true;
                                _changeColorSelectorValue();
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (_, constraints) {
                      final scale = (constraints.maxHeight - 16.w) /
                          ScreenUtil().screenHeight;
                      return Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: OverflowBox(
                              alignment: Alignment.topLeft,
                              maxWidth: ScreenUtil().screenWidth,
                              maxHeight: ScreenUtil().screenHeight,
                              child: Transform.scale(
                                alignment: Alignment.topCenter,
                                scale: scale,
                                child: WeatherCitySnapshot(
                                  data: data,
                                  needMask: false,
                                  colors: (_isNight ? _nightColors : _colors)
                                          .isNullOrEmpty()
                                      ? null
                                      : (_isNight ? _nightColors : _colors),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: ScreenUtil().screenWidth * scale,
                              padding: EdgeInsets.only(
                                top: 138.w,
                                bottom: 132.w,
                              ),
                              margin: EdgeInsets.only(bottom: 16.w),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildBubbleBox(
                                    ColorUtils.color2HEX(
                                        (_isNight ? _nightColors : _colors)
                                            .getOrNull(0),
                                        toUpperCase: true),
                                    () {
                                      if (!_isStartSelected) {
                                        _isStartSelected = true;
                                        _changeColorSelectorValue();
                                        setState(() {});
                                      }
                                    },
                                    direction: BubbleDirection.bottom,
                                    isSelected: _isStartSelected,
                                  ),
                                  _buildBubbleBox(
                                    ColorUtils.color2HEX(
                                        (_isNight ? _nightColors : _colors)
                                            .getOrNull(1),
                                        toUpperCase: true),
                                    () {
                                      if (_isStartSelected) {
                                        _isStartSelected = false;
                                        _changeColorSelectorValue();
                                        setState(() {});
                                      }
                                    },
                                    direction: BubbleDirection.top,
                                    isSelected: !_isStartSelected,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 32.w,
                    right: 32.w,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "色相：",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colours.white,
                          height: 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gaps.generateGap(height: 4.w),
                      WeatherBgColorSelector(
                        key: _hColorSelectorKey,
                        width: double.infinity,
                        height: 20.w,
                        max: 360,
                        onValueChanged: (hue) {
                          setState(() {
                            final hsvColor = _isNight
                                ? _hsvNightColors[_isStartSelected ? 0 : 1]
                                : _hsvColors[_isStartSelected ? 0 : 1];
                            final newHsvColor = HSVColor.fromAHSV(
                                1, hue, hsvColor.saturation, hsvColor.value);
                            _isNight
                                ? _hsvNightColors[_isStartSelected ? 0 : 1] =
                                    newHsvColor
                                : _hsvColors[_isStartSelected ? 0 : 1] =
                                    newHsvColor;
                            _isNight
                                ? _nightColors[_isStartSelected ? 0 : 1] =
                                    newHsvColor.toColor()
                                : _colors[_isStartSelected ? 0 : 1] =
                                    newHsvColor.toColor();
                          });
                        },
                        colors: [
                          0xFFFF0000,
                          0xFFFF00FF,
                          0xFF0000FF,
                          0xFF00FFFF,
                          0xFF00FF00,
                          0xFFFFFF00,
                          0xFFFF0000
                        ].reversed.map((e) => Color(e)).toList(),
                        stops: const [0, 1 / 6, 1 / 3, 1 / 2, 2 / 3, 5 / 6, 1],
                      ),
                      Gaps.generateGap(height: 16.w),
                      Text(
                        "饱和度：",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colours.white,
                          height: 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gaps.generateGap(height: 4.w),
                      WeatherBgColorSelector(
                        key: _sColorSelectorKey,
                        width: double.infinity,
                        height: 20.w,
                        max: 1,
                        onValueChanged: (saturation) {
                          setState(() {
                            final hsvColor = _isNight
                                ? _hsvNightColors[_isStartSelected ? 0 : 1]
                                : _hsvColors[_isStartSelected ? 0 : 1];
                            final newHsvColor = HSVColor.fromAHSV(
                                1, hsvColor.hue, saturation, hsvColor.value);
                            _isNight
                                ? _hsvNightColors[_isStartSelected ? 0 : 1] =
                                    newHsvColor
                                : _hsvColors[_isStartSelected ? 0 : 1] =
                                    newHsvColor;
                            _isNight
                                ? _nightColors[_isStartSelected ? 0 : 1] =
                                    newHsvColor.toColor()
                                : _colors[_isStartSelected ? 0 : 1] =
                                    newHsvColor.toColor();
                          });
                        },
                        colors: [
                          Colours.white,
                          ((_isNight
                                  ? _hsvNightColors[_isStartSelected ? 0 : 1]
                                  : _hsvColors[_isStartSelected ? 0 : 1])
                                ..withSaturation(1)
                                ..withValue(1))
                              .toColor(),
                        ],
                      ),
                      Gaps.generateGap(height: 16.w),
                      Text(
                        "亮度：",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colours.white,
                          height: 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gaps.generateGap(height: 4.w),
                      WeatherBgColorSelector(
                        key: _vColorSelectorKey,
                        width: double.infinity,
                        height: 20.w,
                        max: 1,
                        onValueChanged: (value) {
                          setState(() {
                            final hsvColor = _isNight
                                ? _hsvNightColors[_isStartSelected ? 0 : 1]
                                : _hsvColors[_isStartSelected ? 0 : 1];
                            final newHsvColor = HSVColor.fromAHSV(
                                1, hsvColor.hue, hsvColor.saturation, value);
                            _isNight
                                ? _hsvNightColors[_isStartSelected ? 0 : 1] =
                                    newHsvColor
                                : _hsvColors[_isStartSelected ? 0 : 1] =
                                    newHsvColor;
                            _isNight
                                ? _nightColors[_isStartSelected ? 0 : 1] =
                                    newHsvColor.toColor()
                                : _colors[_isStartSelected ? 0 : 1] =
                                    newHsvColor.toColor();
                          });
                        },
                        colors: const [
                          Colours.black,
                          Colours.white,
                        ],
                      ),
                    ],
                  ),
                ),
                Gaps.generateGap(height: 12.w),
                SizedBox(
                  width: double.infinity,
                  height: 64.w,
                  child: Row(
                    children: [
                      Expanded(
                        child: OpacityLayout(
                          onPressed: _dismiss,
                          child: Center(
                            child: Text(
                              "取消",
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colours.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: OpacityLayout(
                          child: Center(
                            child: Text(
                              "确定",
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colours.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onPressed: () {
                            final color1 = _colors.getOrNull(0);
                            final color2 = _colors.getOrNull(1);
                            final originColor1 = _originColors.getOrNull(0);
                            final originColor2 = _originColors.getOrNull(1);
                            if (color1 == null ||
                                color2 == null ||
                                originColor1 == null ||
                                originColor2 == null) {
                              _dismiss();
                              return;
                            }
                            final similarity1 =
                                ColorUtils.calSimilarity(color1, originColor1);
                            final similarity2 =
                                ColorUtils.calSimilarity(color2, originColor2);
                            if (similarity1 > 0.9 && similarity2 > 0.9) {
                              Toast.show("天气背景相似度过高，请重新编辑！");
                            } else {
                              final color1 = _nightColors.getOrNull(0);
                              final color2 = _nightColors.getOrNull(1);
                              final originColor1 =
                                  _originNightColors.getOrNull(0);
                              final originColor2 =
                                  _originNightColors.getOrNull(1);
                              if (color1 == null ||
                                  color2 == null ||
                                  originColor1 == null ||
                                  originColor2 == null) {
                                _dismiss();
                                return;
                              }
                              final similarity1 = ColorUtils.calSimilarity(
                                  color1, originColor1);
                              final similarity2 = ColorUtils.calSimilarity(
                                  color2, originColor2);
                              if (similarity1 > 0.9 && similarity2 > 0.9) {
                                Toast.show("天气背景相似度过高，请重新编辑！");
                              } else {

                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBubbleBox(
    String content,
    VoidCallback onPressed, {
    BubbleDirection direction = BubbleDirection.bottom,
    bool isSelected = true,
  }) {
    return ScaleLayout(
      onPressed: onPressed,
      child: BubbleBox(
        shape: BubbleShapeBorder(
          radius: BorderRadius.circular(12.w),
          direction: direction,
          arrowAngle: 6.w,
          position: const BubblePosition.center(0),
        ),
        backgroundColor: isSelected ? Colours.colorD5D5D5 : Colours.white,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
        child: Text(
          content,
          style: TextStyle(
            fontSize: 15.sp,
            color: Colours.color333333,
            height: 1,
          ),
        ),
      ),
    );
  }

  void _changeColorSelectorValue() {
    final hsvColor = _isNight
        ? _hsvNightColors[_isStartSelected ? 0 : 1]
        : _hsvColors[_isStartSelected ? 0 : 1];
    _hColorSelectorKey.currentState?.changeValue(hsvColor.hue);
    _sColorSelectorKey.currentState?.changeValue(hsvColor.saturation);
    _vColorSelectorKey.currentState?.changeValue(hsvColor.value);
  }
}
