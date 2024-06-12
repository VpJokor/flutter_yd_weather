import 'package:flutter_yd_weather/model/city_data.dart';
import 'package:flutter_yd_weather/model/location_data.dart';
import 'package:flutter_yd_weather/model/select_city_data.dart';
import 'package:flutter_yd_weather/net/api.dart';
import 'package:flutter_yd_weather/utils/location_utils.dart';
import 'package:geolocator/geolocator.dart';

import '../../base/base_list_view.dart';
import '../../mvp/base_page_presenter.dart';
import '../../net/net_utils.dart';

class SelectCityPresenter extends BasePagePresenter<BaseListView<CityData>> {
  @override
  void initState() {
    obtainCityList(delayMilliseconds: 400);
  }

  Future<dynamic> obtainCityList({int delayMilliseconds = 0}) {
    return requestNetwork<SelectCityData>(
      Method.get,
      url: Api.selectCityApi,
      delayMilliseconds: delayMilliseconds,
      onSuccess: (data) {},
      onError: (_) {},
    );
  }

  Future<dynamic> obtainLocationInfoByCurrentPosition(
      Position currentPosition) {
    final newPosition = LocationUtils.transform(currentPosition.latitude, currentPosition.longitude);
    final Map<String, String> params = <String, String>{};
    params["location"] =
        "${newPosition[0]},${newPosition[1]}";
    return requestNetwork<LocationData>(
      Method.get,
      url: Api.locationApi,
      isShow: false,
      queryParameters: params,
      onSuccess: (data) {},
      onError: (_) {},
    );
  }
}
