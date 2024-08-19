import 'package:flutter_yd_weather/model/location_data.dart';
import 'package:flutter_yd_weather/model/select_city_data.dart';
import 'package:flutter_yd_weather/net/api.dart';
import 'package:flutter_yd_weather/pages/provider/select_city_provider.dart';
import 'package:flutter_yd_weather/pages/view/select_city_view.dart';
import 'package:flutter_yd_weather/utils/location_ext.dart';
import 'package:flutter_yd_weather/utils/location_utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../mvp/base_page_presenter.dart';
import '../../net/net_utils.dart';
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

  void obtainLocationPermission() {
    (view.baseProvider as SelectCityProvider).setLocationData(null, 0);
    PermissionUtils.checkPermission(
      permissionList: [
        Permission.location,
      ],
      onSuccess: () {
        startLocation().then((position) {
          if (position != null) {
            obtainLocationInfoByPosition(
              position,
              (data) {
                view.locationSuccess(data);
                (view.baseProvider as SelectCityProvider)
                    .setLocationData(data, 1);
              },
              failureCallback: () {
                (view.baseProvider as SelectCityProvider)
                    .setLocationData(null, 1);
              },
            );
          } else {
            (view.baseProvider as SelectCityProvider).setLocationData(null, 1);
          }
        });
      },
      onFailed: () {
        (view.baseProvider as SelectCityProvider).setLocationData(null, 1);
      },
    );
  }
}
