import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/model/weather_data.dart';
import 'package:flutter_yd_weather/net/api.dart';
import 'package:flutter_yd_weather/pages/provider/weather_provider.dart';
import 'package:flutter_yd_weather/provider/main_provider.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';

import '../../base/base_list_view.dart';
import '../../mvp/base_page_presenter.dart';
import '../../net/net_utils.dart';

class WeatherMainPresenter extends BasePagePresenter<BaseListView<Object>> {
  @override
  void initState() {
    obtainWeatherData(delayMilliseconds: 200);
  }

  Future<dynamic> obtainWeatherData({int delayMilliseconds = 0}) {
    final mainP = view.getContext().read<MainProvider>();
    final Map<String, String> params = <String, String>{};
    params["citykey"] = mainP.currentCityData?.cityId ?? "";
    return requestNetwork<WeatherData>(Method.get,
        url: Api.weatherApi,
        queryParameters: params,
        delayMilliseconds: delayMilliseconds, onSuccess: (data) {
      if (data != null) {
        SpUtil.putObject(Constants.currentWeatherData, data);
      }
      (view.baseProvider as WeatherProvider).setWeatherData(data);
    }, onError: (_) {});
  }
}
