import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/res/colours.dart';
import 'package:flutter_yd_weather/widget/select_city_item.dart';

import '../model/select_city_data.dart';
import '../res/gaps.dart';

class SelectCityFooter extends StatelessWidget {
  const SelectCityFooter({
    super.key,
    required this.selectCityData,
  });

  final SelectCityData? selectCityData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gaps.generateGap(height: 16.w),
        Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: Text(
            "国际热门城市",
            style: TextStyle(
              fontSize: 20.sp,
              color: context.textColor01,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Gaps.generateGap(height: 8.w),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            /// 每行 widget 数量
            crossAxisCount: 4,

            /// widget 水平之间的距离
            crossAxisSpacing: 16.w,

            /// widget 垂直之间的距离
            mainAxisSpacing: 16.w,

            childAspectRatio: 2 / 1,
          ),
          itemBuilder: (context, index) {
            return SelectCityItem(
              cityData: selectCityData?.hotInternational?[index],
            );
          },
          itemCount: selectCityData?.hotInternational?.length ?? 0,
        )
      ],
    );
  }
}
