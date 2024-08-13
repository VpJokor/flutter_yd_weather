import 'package:easy_refresh/easy_refresh.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/res/gaps.dart';
import 'package:flutter_yd_weather/utils/commons.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/widget/blurry_container.dart';

import '../model/weather_alarms_data.dart';
import '../res/colours.dart';

class WeatherAlarmsDetailDialog extends StatefulWidget {
  const WeatherAlarmsDetailDialog({
    super.key,
    required this.alarms,
    required this.initPosition,
    required this.initHeight,
    required this.isDark,
  });

  final Offset initPosition;
  final double initHeight;
  final bool isDark;
  final List<WeatherAlarmsData>? alarms;

  @override
  State<StatefulWidget> createState() => WeatherAlarmsDetailDialogState();
}

class WeatherAlarmsDetailDialogState extends State<WeatherAlarmsDetailDialog> {
  double _opacity = 0;
  double _marginTop = 0;
  double _height = 0;

  @override
  void initState() {
    super.initState();
    _marginTop = widget.initPosition.dy;
    _height = widget.initHeight;
    Commons.post((_) {
      setState(() {
        _marginTop = 0;
        _height = ScreenUtil().screenHeight;
        _opacity = 1;
      });
    });
  }

  void exit() {
    setState(() {
      _opacity = 0;
      _marginTop = widget.initPosition.dy;
      _height = widget.initHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: AnimatedContainer(
        width: double.infinity,
        height: _height,
        duration: const Duration(milliseconds: 400),
        margin: EdgeInsets.only(
          left: 16.w,
          top: _marginTop,
          right: 16.w,
        ),
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 400),
          child: BlurryContainer(
            width: double.infinity,
            height: double.infinity,
            blur: 10,
            color: (widget.isDark ? Colours.white : Colours.black)
                .withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.w),
            padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
            child: EasyRefresh.builder(
              childBuilder: (_, physics) {
                return MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 12.w),
                    physics: physics,
                    itemBuilder: (_, index) {
                      final item = widget.alarms.getOrNull(index);
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ExtendedImage.network(
                                  item?.icon ?? "",
                                  width: 24.w,
                                  height: 24.w,
                                  fit: BoxFit.cover,
                                  loadStateChanged: Commons.loadStateChanged(
                                    placeholder: Colours.transparent,
                                  ),
                                ),
                                Gaps.generateGap(width: 4.w),
                                Text(
                                  item?.title ?? "",
                                  style: TextStyle(
                                    fontSize: 18.w,
                                    color: Colours.white,
                                    height: 1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Gaps.generateGap(height: 12.w),
                            Text(
                              item?.desc ?? "",
                              style: TextStyle(
                                fontSize: 15.w,
                                color: Colours.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, __) {
                      return Gaps.generateGap(height: 16.w);
                    },
                    itemCount: widget.alarms?.length ?? 0,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
