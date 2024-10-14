import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_yd_weather/model/weather_index_data.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/widget/life_index_dialog.dart';
import 'package:flutter_yd_weather/widget/weather_life_index_static_panel.dart';
import 'package:provider/provider.dart';

import '../model/weather_item_data.dart';
import '../pages/provider/weather_provider.dart';
import '../res/colours.dart';

class WeatherLifeIndexPanel extends StatelessWidget {
  const WeatherLifeIndexPanel({
    super.key,
    required this.data,
    required this.shrinkOffset,
  });

  final WeatherItemData data;
  final double shrinkOffset;

  @override
  Widget build(BuildContext context) {
    final mainP = context.read<WeatherProvider>();
    final key = GlobalKey();
    GlobalKey<LifeIndexDialogState>? lifeIndexDialogKey;
    return WeatherLifeIndexStaticPanel(
      weatherItemData: data,
      shrinkOffset: shrinkOffset,
      isDark: mainP.isDark,
      panelOpacity: mainP.panelOpacity,
      gridViewKey: key,
      showLifeIndexDialog: (index, item, lightImpact) {
        lifeIndexDialogKey = GlobalKey<LifeIndexDialogState>();
        _showLifeIndexDialog(key, lifeIndexDialogKey, index, item, lightImpact);
      },
      updateLifeIndexDialog: (position) {
        _updateLifeIndexDialog(key, lifeIndexDialogKey, position);
      },
    );
  }

  void _updateLifeIndexDialog(
    GlobalKey key,
    GlobalKey<LifeIndexDialogState>? lifeIndexDialogKey,
    Offset position,
  ) {
    final contentPosition =
        (key.currentContext?.findRenderObject() as RenderBox?)
                ?.localToGlobal(Offset.zero) ??
            Offset.zero;
    final contentWidth = key.currentContext?.size?.width ?? 0;
    final size = contentWidth / 3;
    final length = data.weatherData?.indexes?.length ?? 0;
    int row = (position.dy - contentPosition.dy) ~/ size;
    if (row < 0) row = 0;
    if (row > length ~/ 3 - 1) row = length ~/ 3 - 1;
    int column = (position.dx - contentPosition.dx) ~/ size;
    if (column < 0) column = 0;
    if (column > 2) column = 2;
    final index = row * 3 + column;
    lifeIndexDialogKey?.currentState?.update(
      data.weatherData?.indexes?.getOrNull(index),
      Offset(
          contentPosition.dx + size * column, contentPosition.dy + size * row),
      column,
    );
  }

  void _showLifeIndexDialog(
    GlobalKey key,
    GlobalKey<LifeIndexDialogState>? lifeIndexDialogKey,
    int index,
    WeatherIndexData? item,
    bool lightImpact,
  ) {
    final contentPosition =
        (key.currentContext?.findRenderObject() as RenderBox?)
                ?.localToGlobal(Offset.zero) ??
            Offset.zero;
    final contentWidth = key.currentContext?.size?.width ?? 0;
    final size = contentWidth / 3;
    final row = (index / 3).floor();
    final column = index % 3;
    debugPrint(
        "contentPosition = $contentPosition contentWidth = $contentWidth");
    if (lightImpact) {
      HapticFeedback.lightImpact();
    }
    SmartDialog.show(
      tag: "LifeIndexDialog",
      maskColor: Colours.transparent,
      animationTime: const Duration(milliseconds: 200),
      clickMaskDismiss: true,
      onDismiss: () {
        lifeIndexDialogKey?.currentState?.exit();
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
          key: lifeIndexDialogKey,
          data: item,
          position: Offset(contentPosition.dx + size * column,
              contentPosition.dy + size * row),
          size: size,
          column: column,
          update: (position) {
            _updateLifeIndexDialog(key, lifeIndexDialogKey, position);
          },
        );
      },
    );
  }
}
