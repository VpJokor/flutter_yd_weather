import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/model/simple_weather_data.dart';
import 'package:flutter_yd_weather/model/weather_data.dart';
import 'package:flutter_yd_weather/net/api.dart';
import 'package:flutter_yd_weather/pages/provider/weather_provider.dart';
import 'package:flutter_yd_weather/pages/view/weather_main_view.dart';
import 'package:flutter_yd_weather/provider/main_provider.dart';
import 'package:provider/provider.dart';
import '../../mvp/base_page_presenter.dart';
import '../../net/net_utils.dart';

class WeatherMainPresenter extends BasePagePresenter<WeatherMainView> {
  @override
  void initState() {
    obtainWeatherData(delayMilliseconds: 200);
  }

  Future<dynamic> obtainWeatherData({int delayMilliseconds = 0}) {
    final mainP = view.getContext().read<MainProvider>();
    final Map<String, String> params = <String, String>{};
    final currentCityId = mainP.currentCityData?.cityId ?? "";
    params["citykey"] = currentCityId;
    return requestNetwork<WeatherData>(Method.get,
        url: Api.weatherApi,
        queryParameters: params,
        delayMilliseconds: delayMilliseconds, onSuccess: (data) {
      view.obtainWeatherDataCallback();
      (view.baseProvider as WeatherProvider).setWeatherData(data);
      if (mainP.currentCityData != null) {
        mainP.currentCityData!.weatherData =
            SimpleWeatherData.fromWeatherData(data);
        final isLocationCity = mainP.currentCityData!.isLocationCity ?? false;
        mainP.cityDataBox.put(
            isLocationCity ? Constants.locationCityId : currentCityId,
            mainP.currentCityData!);
      }
    }, onError: (_) {
      view.obtainWeatherDataCallback();
    });
  }
}
