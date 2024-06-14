import 'package:flutter_yd_weather/model/city_data.dart';
import 'package:flutter_yd_weather/model/location_data.dart';
import 'package:flutter_yd_weather/model/select_city_data.dart';
import 'package:flutter_yd_weather/net/api.dart';
import 'package:flutter_yd_weather/pages/provider/select_city_provider.dart';
import 'package:flutter_yd_weather/utils/location_utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../base/base_list_view.dart';
import '../../mvp/base_page_presenter.dart';
import '../../net/net_utils.dart';
import '../../utils/log.dart';
import '../../utils/permission_utils.dart';

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
      onSuccess: (data) {
        (view.baseProvider as SelectCityProvider).selectCityData = data;
        _obtainLocationPermission();
      },
      onError: (_) {},
    );
  }

  Future<dynamic> obtainLocationInfoByCurrentPosition(
      Position currentPosition) {
    final newPosition = LocationUtils.transform(
        currentPosition.latitude, currentPosition.longitude);
    final Map<String, String> params = <String, String>{};
    params["location"] = "${newPosition[0]},${newPosition[1]}";
    return requestNetwork<LocationData>(
      Method.get,
      url: Api.locationApi,
      isShow: false,
      queryParameters: params,
      onSuccess: (data) {
        (view.baseProvider as SelectCityProvider).setLocationData(data, 1);
      },
      onError: (_) {
        (view.baseProvider as SelectCityProvider).setLocationData(null, 1);
      },
    );
  }

  void _obtainLocationPermission() {
    PermissionUtils.checkPermission(
      permissionList: [
        Permission.location,
      ],
      onSuccess: () {
        _startLocation();
      },
      onFailed: () {
        (view.baseProvider as SelectCityProvider).setLocationData(null, 1);
      },
    );
  }

  void _startLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    final permission = await Geolocator.checkPermission();
    Log.e("serviceEnabled = $serviceEnabled permission = $permission");
    if (!serviceEnabled ||
        permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      (view.baseProvider as SelectCityProvider).setLocationData(null, 1);
      return;
    }
    final lastPosition = await Geolocator.getLastKnownPosition();
    if (lastPosition != null) {
      obtainLocationInfoByCurrentPosition(lastPosition);
    } else {
      try {
        final position = await Geolocator.getCurrentPosition(
            timeLimit: const Duration(milliseconds: 4000));
        obtainLocationInfoByCurrentPosition(position);
      } catch (error) {
        Log.e("_startLocation error ${error.toString()}");
        (view.baseProvider as SelectCityProvider).setLocationData(null, 1);
      }
    }
  }
}
