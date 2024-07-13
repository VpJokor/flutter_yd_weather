import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/utils/log.dart';

import '../res/colours.dart';

class AirQualityBar extends StatelessWidget {
  const AirQualityBar({
    super.key,
    this.width,
    required this.height,
    required this.aqi,
  });

  final double? width;
  final double height;
  final int aqi;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        final percent = (aqi / 500).fixPercent();
        final marginStart = (c.maxWidth - height) * percent;
        return Stack(
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.w),
                gradient: const LinearGradient(
                  colors: [
                    Colours.color00E301,
                    Colours.colorFDFD01,
                    Colours.colorFD7E01,
                    Colours.colorF70001,
                    Colours.color98004C,
                    Colours.color7D0023,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            Container(
              width: height,
              height: height,
              margin: EdgeInsets.only(left: marginStart),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.w),
                color: Colours.white,
              ),
            ),
          ],
        );
      },
    );
  }
}
