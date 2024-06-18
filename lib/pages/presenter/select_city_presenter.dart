import 'package:flutter_yd_weather/model/city_data.dart';
import 'package:flutter_yd_weather/model/location_data.dart';
import 'package:flutter_yd_weather/model/select_city_data.dart';
import 'package:flutter_yd_weather/net/api.dart';
import 'package:flutter_yd_weather/pages/provider/select_city_provider.dart';
import 'package:flutter_yd_weather/pages/view/select_city_view.dart';
import 'package:flutter_yd_weather/utils/location_utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../mvp/base_page_presenter.dart';
import '../../net/net_utils.dart';
import '../../utils/log.dart';
import '../../utils/permission_utils.dart';

class SelectCityPresenter extends BasePagePresenter<SelectCityView> {
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
        obtainLocationPermission();
      },
      onError: (_) {},
    );
  }

  Future<dynamic> _obtainLocationInfoByCurrentPosition(
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
        view.locationSuccess(data);
        (view.baseProvider as SelectCityProvider).setLocationData(data, 1);
      },
      onError: (_) {
        (view.baseProvider as SelectCityProvider).setLocationData(null, 1);
      },
    );
  }

  void obtainLocationPermission() {
    (view.baseProvider as SelectCityProvider).setLocationData(null, 0);
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

    try {
      final position = await Geolocator.getCurrentPosition(
          forceAndroidLocationManager: true,
          timeLimit: const Duration(milliseconds: 8000));
      _obtainLocationInfoByCurrentPosition(position);
    } catch (error) {
      Log.e("_startLocation error ${error.toString()}");
      final lastPosition = await Geolocator.getLastKnownPosition();
      Log.e("lastPosition = $lastPosition");
      if (lastPosition != null) {
        _obtainLocationInfoByCurrentPosition(lastPosition);
      } else {
        (view.baseProvider as SelectCityProvider).setLocationData(null, 1);
      }
    }
  }
}
