import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_yd_weather/res/colours.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/widget/load_asset_image.dart';
import 'package:flutter_yd_weather/widget/opacity_layout.dart';

class CityManagerSlidableAction extends StatelessWidget {
  const CityManagerSlidableAction({
    super.key,
    required this.percent,
    this.onTap,
  });

  final double percent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.centerRight,
        child: OpacityLayout(
          child: AnimatedOpacity(
            opacity: ((percent - 0.5) / 0.5).fixPercent(),
            duration: Duration.zero,
            child: Container(
              width: 32.w + 16.w * percent,
              height: 32.w + 16.w * percent,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.w),
                color: Colours.colorFE2C3C,
              ),
              child: LoadAssetImage(
                "ic_delete_icon",
                width: 20.w,
                height: 20.w,
                color: Colours.white,
              ),
            ),
          ),
          onPressed: () {
            Slidable.of(context)?.close().then((_) {
              onTap?.call();
            });
          },
        ),
      ),
    );
  }
}
