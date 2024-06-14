import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/model/location_data.dart';
import 'package:flutter_yd_weather/res/colours.dart';
import 'package:flutter_yd_weather/res/gaps.dart';
import 'package:flutter_yd_weather/widget/load_asset_image.dart';
import 'package:flutter_yd_weather/widget/shadow_card_widget.dart';

class SelectCityHeader extends StatefulWidget {
  const SelectCityHeader({
    super.key,
    required this.locationData,
    required this.locationStatus,
  });

  final LocationData? locationData;
  final int locationStatus;

  @override
  State<StatefulWidget> createState() => _SelectCityHeaderState();
}

class _SelectCityHeaderState extends State<SelectCityHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gaps.generateGap(height: 8.w),
        Row(
          children: [
            ShadowCardWidget(
              borderRadius: BorderRadius.circular(100.w),
              blurRadius: 0,
              bgColor: context.cardColor06,
              pressBgColor: context.cardColor05,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 12.w),
              margin: EdgeInsets.only(left: 20.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LoadAssetImage(
                    "writing_icon_location1",
                    width: 18.w,
                    height: 18.w,
                  ),
                  Gaps.generateGap(width: 4.w),
                  Text(
                    widget.locationStatus == 0
                        ? "定位中..."
                        : widget.locationData?.addressComponent?.city ?? "定位失败",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: context.textColor01,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Gaps.generateGap(height: 16.w),
        Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: Text(
            "国内热门城市",
            style: TextStyle(
              fontSize: 20.sp,
              color: context.textColor01,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Gaps.generateGap(height: 8.w),
      ],
    );
  }
}
