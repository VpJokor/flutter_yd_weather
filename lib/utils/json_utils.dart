import 'package:flutter_yd_weather/model/location_data.dart';
import 'package:flutter_yd_weather/model/select_city_data.dart';

class JsonUtils {
  static M? fromJsonAsT<M>(dynamic json) {
    if (json == null) {
      return null;
    }
    if (json is List) {
      return _getListChildType<M>(json);
    } else {
      return _fromJsonSingle<M>(json as Map<String, dynamic>);
    }
  }

  static M? _fromJsonSingle<M>(Map<String, dynamic> json) {
    final String type = M.toString();
    if (type == (SelectCityData).toString()) {
      return SelectCityData.fromJson(json) as M;
    }
    if (type == (LocationData).toString()) {
      return LocationData.fromJson(json) as M;
    }
    return null;
  }

  static M? _getListChildType<M>(List<dynamic> data) {
    return null;
  }
}
