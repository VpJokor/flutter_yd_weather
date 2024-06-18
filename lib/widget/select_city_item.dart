import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/model/city_data.dart';
import 'package:flutter_yd_weather/provider/main_provider.dart';
import 'package:flutter_yd_weather/res/colours.dart';
import 'package:flutter_yd_weather/widget/scale_layout.dart';
import 'package:flutter_yd_weather/widget/shadow_card_widget.dart';
import 'package:provider/provider.dart';

class SelectCityItem extends StatefulWidget {
  const SelectCityItem({
    super.key,
    required this.cityData,
  });

  final CityData? cityData;

  @override
  State<StatefulWidget> createState() => _SelectCityItemState();
}

class _SelectCityItemState extends State<SelectCityItem> {
  @override
  Widget build(BuildContext context) {
    final p = context.read<MainProvider>();
    final cityDataBox = p.cityDataBox;
    final hasAdded = cityDataBox.containsKey(widget.cityData?.cityId);
    return ScaleLayout(
      child: ShadowCardWidget(
        borderRadius: BorderRadius.circular(100.w),
        blurRadius: 0,
        bgColor: context.cardColor06,
        pressBgColor: context.cardColor05,
        alignment: Alignment.center,
        enable: false,
        child: Text(
          widget.cityData?.name ?? "",
          style: TextStyle(
            fontSize: 13.sp,
            color: hasAdded ? context.appMain : context.textColor01,
          ),
        ),
      ),
      onPressed: () {
        p.addCity(context, hasAdded, widget.cityData);
      },
    );
  }
}
