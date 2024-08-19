import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/model/simple_weather_data.dart';
import 'package:flutter_yd_weather/model/weather_data.dart';
import 'package:flutter_yd_weather/net/api.dart';
import 'package:flutter_yd_weather/pages/provider/weather_provider.dart';
import 'package:flutter_yd_weather/pages/view/weather_main_view.dart';
import 'package:flutter_yd_weather/provider/main_provider.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/utils/location_ext.dart';
import 'package:flutter_yd_weather/utils/log.dart';
import 'package:provider/provider.dart';
import '../../mvp/base_page_presenter.dart';
import '../../net/net_utils.dart';

class WeatherMainPresenter extends BasePagePresenter<WeatherMainView> {
  bool _hasCheckLocationCity = false;

  @override
  void initState() {
    obtainWeatherData(
      delayMilliseconds: 200,
    );
  }

  Future<dynamic> obtainWeatherData({
    int delayMilliseconds = 0,
    bool isAdd = false,
  }) async {
    final mainP = view.getContext().read<MainProvider>();
    final Map<String, String> params = <String, String>{};
    if (!_hasCheckLocationCity && (mainP.currentCityData?.isLocationCity ?? false)) {
      final position = await startLocation();
      if (position != null) {
        _hasCheckLocationCity = true;
        final locationData = await obtainLocationInfoByPositionV1(position);
        if (locationData != null) {
          final province = locationData.addressComponent?.province ?? "";
          if (mainP.currentCityData?.name ==
                  locationData.addressComponent?.district &&
              (province.contains(mainP.currentCityData?.prov ?? "") ||
                  (mainP.currentCityData?.prov ?? "").contains(province))) {
            /// 定位位置相同
            Log.e("定位位置相同");
          } else {
            final result = await searchCityResult(
                locationData.addressComponent?.district ?? "");
            if (result.isNotNullOrEmpty()) {
              final find = result!.singleOrNull((element) =>
                  element.name == locationData.addressComponent?.district &&
                  (province.contains(element.prov ?? "") ||
                      (element.prov ?? "").contains(province)));
              if (find != null) {
                find.isLocationCity = true;
                mainP.currentCityData = find;
              }
            }
          }
        }
      }
    }
    final currentCityId = mainP.currentCityData?.cityId ?? "";
    params["citykey"] = currentCityId;
    return requestNetwork<WeatherData>(Method.get,
        url: Api.weatherApi,
        queryParameters: params,
        delayMilliseconds: delayMilliseconds, onSuccess: (data) {
      (view.baseProvider as WeatherProvider).setWeatherData(
        mainP.currentWeatherCardSort,
        mainP.currentWeatherObservesCardSort,
        data,
      );
      if (mainP.currentCityData != null) {
        mainP.currentCityData!.weatherData =
            SimpleWeatherData.fromWeatherData(data);
        final isLocationCity = mainP.currentCityData!.isLocationCity ?? false;
        mainP.cityDataBox.put(
            isLocationCity ? Constants.locationCityId : currentCityId,
            mainP.currentCityData!);
      }
      view.obtainWeatherDataCallback(isAdd);
    }, onError: (_) {
      view.obtainWeatherDataCallback(false);
    });
  }
}
