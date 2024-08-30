import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/model/city_data.dart';
import 'package:flutter_yd_weather/res/colours.dart';
import 'package:flutter_yd_weather/res/gaps.dart';
import 'package:flutter_yd_weather/utils/commons.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/utils/theme_utils.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';

import '../config/constants.dart';
import '../provider/main_provider.dart';

class WeatherHeaderPopupMenu extends StatefulWidget {
  const WeatherHeaderPopupMenu({
    super.key,
    required this.initPosition,
  });

  final Offset initPosition;

  @override
  State<StatefulWidget> createState() => WeatherHeaderPopupMenuState();
}

class WeatherHeaderPopupMenuState extends State<WeatherHeaderPopupMenu> {
  final _horizontalGap = 16.w;
  final _maxHeight = (294.w - ScreenUtil().statusBarHeight) * 0.98;
  final _width = ScreenUtil().screenWidth * 0.4;
  double _opacity = 0;
  double _scale = 0;
  bool _isShow = false;
  final _list = [];
  CityData? _selectedItem;
  final _listViewKey = GlobalKey();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _opacity = 0;
    _scale = 0;
    _isShow = false;
    Commons.post((_) {
      setState(() {
        _generateList();
        _opacity = 1;
        _scale = 1;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _generateList() {
    final mainP = context.read<MainProvider>();
    _selectedItem = mainP.currentCityData;
    _list.clear();
    final currentCityIdList =
        SpUtil.getStringList(Constants.currentCityIdList) ?? [];
    for (var cityId in currentCityIdList) {
      final cityData = mainP.cityDataBox.get(cityId);
      final findCityId = cityData?.cityId ?? "";
      if (findCityId.isNotNullOrEmpty()) {
        if (cityId == Constants.locationCityId) {
          _list.insert(0, cityData);
        } else {
          _list.add(cityData);
        }
      }
    }
    final index = _list.indexOf((e) => e == _selectedItem);
    if (index >= 0) {}
  }

  void scroll(Offset position) {
    if (!_isShow) return;
    final contentPosition =
        (_listViewKey.currentContext?.findRenderObject() as RenderBox?)
                ?.localToGlobal(Offset.zero) ??
            Offset.zero;
    final contentHeight = _listViewKey.currentContext?.size?.height ?? 0;
    final offset = position.dy - contentPosition.dy;
    final dy = offset + _scrollController.offset;
    final index = (dy / 48.w).floor();
    debugPrint("offset = $offset index = $index}");
    final item = _list.getOrNull(index);
    if (item != null) {
      if (_selectedItem != item) {
        _selectedItem = item;
        HapticFeedback.lightImpact();
        setState(() {});
      }
    }
  }

  void exit() {
    _isShow = false;
    setState(() {
      _opacity = 0;
      _scale = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final initPosition = widget.initPosition;
    double width = initPosition.dx + _width;
    double height = initPosition.dy;
    if (initPosition.dx + _width + _horizontalGap > ScreenUtil().screenWidth) {
      width = initPosition.dx;
    }
    final listViewHeight = min(_list.length * 48.w, _maxHeight);
    if (initPosition.dy < ScreenUtil().statusBarHeight + listViewHeight) {
      height = initPosition.dy + _maxHeight;
    }
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.bottomRight,
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 200),
          onEnd: () {
            _isShow = _opacity == 1;
          },
          child: AnimatedScale(
            scale: _scale,
            alignment: initPosition.dy < height
                ? (initPosition.dx < width
                    ? Alignment.topLeft
                    : Alignment.topRight)
                : (initPosition.dx < width
                    ? Alignment.bottomLeft
                    : Alignment.bottomRight),
            duration: const Duration(milliseconds: 200),
            child: SizedBox(
              width: _width,
              height: _maxHeight,
              child: Stack(
                children: [
                  Align(
                    alignment: initPosition.dy < height
                        ? Alignment.topCenter
                        : Alignment.bottomCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: _maxHeight),
                      child: Container(
                        width: _width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.w),
                          color: context.backgroundColor,
                        ),
                        margin: initPosition.dy < height
                            ? EdgeInsets.only(top: 12.w)
                            : EdgeInsets.only(bottom: 12.w),
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          removeBottom: true,
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(
                              overscroll: false,
                            ),
                            child: ListView.builder(
                              key: _listViewKey,
                              controller: _scrollController,
                              shrinkWrap: true,
                              itemExtent: 48.w,
                              itemBuilder: (_, index) {
                                final item = _list[index];
                                if (item is CityData) {
                                  return _buildWeatherCityItem(context, item);
                                }
                                return Gaps.empty;
                              },
                              itemCount: _list.length,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherCityItem(BuildContext context, CityData? cityData) {
    final isSelected = _selectedItem == cityData;
    return Container(
      height: 48.w,
      color: context.black.withOpacity(isSelected ? 0.1 : 0),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Text(
        cityData?.name ?? "",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 17.sp,
          color: context.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
