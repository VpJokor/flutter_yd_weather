import 'package:geolocator/geolocator.dart';

import '../model/location_data.dart';
import '../net/api.dart';
import '../net/net_utils.dart';
import 'location_utils.dart';
import 'log.dart';

Future<Position?> startLocation() async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  final permission = await Geolocator.checkPermission();
  Log.e("serviceEnabled = $serviceEnabled permission = $permission");
  if (!serviceEnabled ||
      permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    return Future.value(null);
  }

  /// longitude: 120.920537,
  /// latitude: 29.175187,
  try {
    final position = await Geolocator.getCurrentPosition(
        forceAndroidLocationManager: true,
        timeLimit: const Duration(milliseconds: 8000));
    return Future.value(position);
  } catch (error) {
    Log.e("_startLocation error ${error.toString()}");
    final lastPosition = await Geolocator.getLastKnownPosition();
    Log.e("lastPosition = $lastPosition");
    if (lastPosition != null) {
      return Future.value(lastPosition);
    } else {
      return Future.value(null);
    }
  }
}

void obtainLocationInfoByPosition(
  Position position,
  void Function(LocationData? data) successCallback, {
  void Function()? failureCallback,
}) {
  final newPosition =
      LocationUtils.transform(position.latitude, position.longitude);
  final Map<String, String> params = <String, String>{};
  params["location"] = "${newPosition[0]},${newPosition[1]}";
  NetUtils.instance.requestNetwork<LocationData>(Method.get, Api.locationApi,
      queryParameters: params, onSuccess: (data) {
    successCallback.call(data);
  }, onError: (msg) {
    failureCallback?.call();
  });
}

Future<LocationData?> obtainLocationInfoByPositionV1(Position position) {
  final newPosition =
      LocationUtils.transform(position.latitude, position.longitude);
  final Map<String, String> params = <String, String>{};
  params["location"] = "${newPosition[0]},${newPosition[1]}";
  return NetUtils.instance.requestNet<LocationData>(Method.get, Api.locationApi,
      queryParameters: params);
}
