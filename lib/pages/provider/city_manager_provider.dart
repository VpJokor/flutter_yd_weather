import 'package:flutter/cupertino.dart';
import 'package:flutter_yd_weather/base/base_list_provider.dart';
import 'package:flutter_yd_weather/model/city_data.dart';

import '../../res/colours.dart';
import '../../utils/color_utils.dart';

class CityManagerProvider extends BaseListProvider<CityData> {
  Color _titleColor = Colours.transparent;
  Color largeTitleColor = Colours.color333333;

  Color get titleColor => _titleColor;

  void changeAlpha(BuildContext context, double alpha) {
    _titleColor = ColorUtils.adjustAlpha(context.black, alpha);
    largeTitleColor = ColorUtils.adjustAlpha(context.black, 1 - alpha);
    notifyListeners();
  }
}
