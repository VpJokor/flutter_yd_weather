import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_yd_weather/model/weather_index_data.dart';
import 'package:flutter_yd_weather/res/gaps.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/widget/life_index_dialog.dart';
import 'package:flutter_yd_weather/widget/scale_layout.dart';
import 'package:provider/provider.dart';

import '../config/constants.dart';
import '../model/weather_item_data.dart';
import '../pages/provider/weather_provider.dart';
import '../res/colours.dart';
import '../utils/commons.dart';
import 'blurry_container.dart';

class WeatherLifeIndexPanel extends StatelessWidget {
  WeatherLifeIndexPanel({
    super.key,
    required this.data,
    required this.shrinkOffset,
  });

  final WeatherItemData data;
  final double shrinkOffset;

  final _key = GlobalKey();
  final _lifeIndexDialogKey = GlobalKey<LifeIndexDialogState>();

  @override
  Widget build(BuildContext context) {
    final weatherItemData = data;
    final percent = ((weatherItemData.maxHeight - 12.w - shrinkOffset) /
            Constants.itemStickyHeight.w)
        .fixPercent();
    final isDark = context.read<WeatherProvider>().isDark;
    return AnimatedOpacity(
      opacity: percent,
      duration: Duration.zero,
      child: Stack(
        children: [
          BlurryContainer(
            width: double.infinity,
            height: double.infinity,
            blur: 5,
            margin: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
            ),
            padding: EdgeInsets.only(
              top: Constants.itemStickyHeight.w,
            ),
            color: (isDark ? Colours.white : Colours.black).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.w),
            useBlurry: false,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: -shrinkOffset,
                  right: 0,
                  bottom: 0,
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    removeBottom: true,
                    child: GridView.builder(
                      key: _key,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        /// 每行 widget 数量
                        crossAxisCount: 3,
                        childAspectRatio: 1 / 1,
                      ),
                      itemBuilder: (_, index) {
                        final item = weatherItemData.weatherData?.indexes
                            .getOrNull(index);
                        return ScaleLayout(
                          onPressed: () {
                            _showLifeIndexDialog(index, item);
                          },
                          onLongPressed: () {
                            _showLifeIndexDialog(index, item);
                          },
                          onLongPressMoveUpdate: (details) {
                            _updateLifeIndexDialog(details.globalPosition);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ExtendedImage.network(
                                  item?.ext?.icon ?? "",
                                  width: 48.w,
                                  height: 48.w,
                                  fit: BoxFit.cover,
                                  loadStateChanged: Commons.loadStateChanged(
                                      placeholder: Colours.transparent),
                                ),
                                Gaps.generateGap(height: 8.w),
                                Text(
                                  item?.value ?? "",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colours.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount:
                          weatherItemData.weatherData?.indexes?.length ?? 0,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: Constants.itemStickyHeight.w,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.only(left: 16.w),
            alignment: Alignment.centerLeft,
            child: Text(
              "生活指数",
              style: TextStyle(
                fontSize: 12.sp,
                color: Colours.white.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateLifeIndexDialog(Offset position) {
    final contentPosition =
        (_key.currentContext?.findRenderObject() as RenderBox?)
                ?.localToGlobal(Offset.zero) ??
            Offset.zero;
    final contentWidth = _key.currentContext?.size?.width ?? 0;
    final size = contentWidth / 3;
    final length = data.weatherData?.indexes?.length ?? 0;
    int row = (position.dy - contentPosition.dy) ~/ size;
    if (row < 0) row = 0;
    if (row > length ~/ 3 - 1) row = length ~/ 3 - 1;
    int column = (position.dx - contentPosition.dx) ~/ size;
    if (column < 0) column = 0;
    if (column > 2) column = 2;
    final index = row * 3 + column;
    _lifeIndexDialogKey.currentState?.update(
      data.weatherData?.indexes?.getOrNull(index),
      Offset(
          contentPosition.dx + size * column, contentPosition.dy + size * row),
      column,
    );
  }

  void _showLifeIndexDialog(int index, WeatherIndexData? item) {
    final contentPosition =
        (_key.currentContext?.findRenderObject() as RenderBox?)
                ?.localToGlobal(Offset.zero) ??
            Offset.zero;
    final contentWidth = _key.currentContext?.size?.width ?? 0;
    final size = contentWidth / 3;
    final row = (index / 3).floor();
    final column = index % 3;
    debugPrint(
        "contentPosition = $contentPosition contentWidth = $contentWidth");
    SmartDialog.show(
      tag: "LifeIndexDialog",
      maskColor: Colours.transparent,
      animationTime: const Duration(milliseconds: 200),
      clickMaskDismiss: true,
      onDismiss: () {
        _lifeIndexDialogKey.currentState?.exit();
      },
      animationBuilder: (
        controller,
        child,
        animationParam,
      ) {
        return child;
      },
      builder: (_) {
        return LifeIndexDialog(
          key: _lifeIndexDialogKey,
          data: item,
          position: Offset(contentPosition.dx + size * column,
              contentPosition.dy + size * row),
          size: size,
          column: column,
          update: _updateLifeIndexDialog,
        );
      },
    );
  }
}
