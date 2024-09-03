import 'package:animated_visibility/animated_visibility.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/res/colours.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/utils/theme_utils.dart';
import 'package:flutter_yd_weather/widget/load_asset_image.dart';
import 'package:flutter_yd_weather/widget/my_app_bar.dart';
import 'package:flutter_yd_weather/widget/weather_bg_edit_dialog.dart';

import '../model/weather_bg_model.dart';

class WeatherBgListPage extends StatefulWidget {
  const WeatherBgListPage({super.key});

  @override
  State<StatefulWidget> createState() => _WeatherBgListPageState();
}

class _WeatherBgListPageState extends State<WeatherBgListPage> {
  late ScrollController _scrollController;
  final _weatherBgEditDialogKey = GlobalKey<WeatherBgEditDialogState>();
  bool _isNight = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: MyAppBar(
        backgroundColor: context.backgroundColor,
        backImg: "ic_close_icon1",
        centerTitle: "天气背景",
        titleColor: context.black,
        rightAction1: _isNight ? "夜间" : "日间",
        onRightAction1Pressed: () {
          setState(() {
            _isNight = !_isNight;
          });
        },
      ),
      body: EasyRefresh.builder(
        scrollController: _scrollController,
        notRefreshHeader: const NotRefreshHeader(
          position: IndicatorPosition.locator,
          hitOver: true,
        ),
        childBuilder: (_, physics) {
          return ListView.builder(
            physics: physics,
            padding: EdgeInsets.only(bottom: 12.w),
            itemBuilder: (_, index) {
              final weatherType =
                  Constants.defaultWeatherBgMap.keys.toList()[index];
              final itemData =
                  Constants.defaultWeatherBgMap.values.toList()[index];
              return _buildItem(context, weatherType, itemData);
            },
            itemCount: Constants.defaultWeatherBgMap.length,
          );
        },
      ),
    );
  }

  Widget _buildItem(
      BuildContext context, String weatherType, List<WeatherBgModel> data) {
    final selectedItem = data.singleOrNull((e) => e.isSelected ?? false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 42.w,
          padding: EdgeInsets.only(left: 20.w),
          alignment: Alignment.centerLeft,
          child: Text(
            _getTitle(weatherType),
            style: TextStyle(
              fontSize: 18.sp,
              color: context.textColor01,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12.w,
              crossAxisSpacing: 12.w,
              childAspectRatio:
                  ScreenUtil().screenWidth / ScreenUtil().screenHeight,
            ),
            itemBuilder: (_, index) {
              final weatherBgModel = data.getOrNull(index);
              if (weatherBgModel != null) {
                return _buildWeatherBgItem(weatherBgModel);
              } else {
                return _buildWeatherBgAddItem(
                  weatherType,
                  selectedItem,
                );
              }
            },
            itemCount: data.length < Constants.maxWeatherBgCount
                ? data.length + 1
                : data.length,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherBgItem(WeatherBgModel data) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.w),
            gradient: LinearGradient(
              colors:
                  ((_isNight ? data.nightColors : data.colors) ?? data.colors)
                          ?.map((e) => Color(e))
                          .toList() ??
                      [],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: AnimatedVisibility(
            enter: fadeIn(),
            exit: fadeOut(),
            enterDuration: const Duration(milliseconds: 200),
            exitDuration: const Duration(milliseconds: 200),
            child: LoadAssetImage(
              "ic_xuanzhong",
              width: 32.w,
              height: 32.w,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherBgAddItem(
    String weatherType,
    WeatherBgModel? selectedItem,
  ) {
    return GestureDetector(
      onTap: () {
        SmartDialog.show(
          tag: "WeatherBgEditDialog",
          maskColor: Colours.transparent,
          animationTime: const Duration(milliseconds: 200),
          clickMaskDismiss: true,
          onDismiss: () {
            _weatherBgEditDialogKey.currentState?.exit();
          },
          animationBuilder: (
            controller,
            child,
            animationParam,
          ) {
            return child;
          },
          builder: (_) {
            return WeatherBgEditDialog(
              key: _weatherBgEditDialogKey,
              weatherBgModel: selectedItem,
            );
          },
        );
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.w),
              border: Border.all(
                width: 2.w,
                color: context.black.withOpacity(0.2),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 2.w,
              height: 32.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.w),
                color: context.black.withOpacity(0.2),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 32.w,
              height: 2.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.w),
                color: context.black.withOpacity(0.2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTitle(String weatherType) {
    switch (weatherType) {
      case "CLEAR":
        return "晴天";
      case "PARTLY_CLOUDY":
        return "多云";
      case "CLOUDY":
        return "阴";
      case "LIGHT_HAZE":
        return "轻度雾霾、中度雾霾";
      case "HEAVY_HAZE":
        return "重度雾霾";
      case "LIGHT_RAIN":
        return "小雨";
      case "MODERATE_RAIN":
        return "中雨、大雨、暴雨";
      case "FOG":
        return "雾";
      case "LIGHT_SNOW":
        return "小雪、中雪、大雪、暴雪";
      case "DUST":
        return "浮尘、沙尘";
      case "WIND":
        return "大风";
    }
    return "";
  }
}
