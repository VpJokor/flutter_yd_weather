import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_yd_weather/res/colours.dart';
import 'package:flutter_yd_weather/res/gaps.dart';
import 'package:flutter_yd_weather/utils/theme_utils.dart';
import 'package:flutter_yd_weather/widget/load_asset_image.dart';
import 'package:flutter_yd_weather/widget/opacity_layout.dart';

class AirQualityQueryDialog extends StatelessWidget {
  const AirQualityQueryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: ScreenUtil().screenHeight * 0.865,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.w),
          topRight: Radius.circular(24.w),
        ),
        color: context.backgroundColor,
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: OpacityLayout(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: LoadAssetImage(
                      "ic_close_icon1",
                      width: 22.w,
                      height: 22.w,
                      color: context.black,
                    ),
                  ),
                  onPressed: () {
                    SmartDialog.dismiss(tag: "AirQualityQueryDialog");
                  },
                ),
              ),
              Align(
                child: Padding(
                  padding: EdgeInsets.only(top: 12.w),
                  child: Text(
                    "中国国家环境保护部\n空气质量指数及相关信息",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: context.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                overscroll: false,
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.w),
                child: SizedBox(
                  width: double.infinity,
                  height: ScreenUtil().screenHeight * 0.865 * 0.8,
                  child: Row(
                    children: [
                      Container(
                        width: 16.w,
                        height: double.infinity,
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
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Gaps.generateGap(width: 12.w),
                      Expanded(
                        child: Column(
                          children: [
                            _buildContent(
                                context,
                                "优：0-50",
                                "空气质量令人满意，基本无空气污染，各类人群可正常活动",
                                Alignment.topLeft),
                            _buildContent(
                                context,
                                "良：51-100",
                                "空气质量可接受，但某些污染物可能对极少数异常敏感人群健康有较弱影响",
                                Alignment.topLeft),
                            _buildContent(
                                context,
                                "轻度污染：101-150",
                                "儿童、老年人及心脏病、呼吸系统疾病患者应减少长时间、高强度的户外锻炼",
                                Alignment.topLeft),
                            _buildContent(
                                context,
                                "中度污染：151-200",
                                "儿童、老年人及心脏病、呼吸系统疾病患者应减少长时间、高强度的户外锻炼，一般人群适量减少户外运动",
                                Alignment.topLeft),
                            _buildContent(
                                context,
                                "重度污染：201-300",
                                "儿童、老年人和心脏病、肺病患者应停留在室内，停止户外运动，一般人群减少户外运动",
                                Alignment.bottomLeft),
                            _buildContent(
                                context,
                                "严重污染：大于300",
                                "儿童、老年人和病人应当留在室内，避免体力消耗，一般人群应避免户外活动",
                                Alignment.bottomLeft),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, String title, String content, Alignment alignment) {
    return Expanded(
      child: Container(
        alignment: alignment,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                color: context.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gaps.generateGap(height: 2.w),
            Text(
              content,
              style: TextStyle(
                fontSize: 15.sp,
                color: context.textColor01,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
