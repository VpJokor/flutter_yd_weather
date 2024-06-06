import '../utils/json_utils.dart';

class ResultData<T> {
  late int code;
  late String msg;
  T? data;

  ResultData(this.code, this.msg, this.data);

  ResultData.fromJson(Map<String, dynamic> jsonMap) {
    if (jsonMap.containsKey("status")) {
      code = jsonMap["status"];
    } else {
      code = -1;
    }
    if (jsonMap.containsKey("desc")) {
      msg = jsonMap["desc"];
    } else {
      msg = "error msg";
    }
    if (jsonMap.containsKey("data")) {
      final dataJsonMap = jsonMap["data"];
      data = _generateOBJ<T>(dataJsonMap);
    } else {
      data = _generateOBJ(jsonMap);
    }
  }

  T? _generateOBJ<O>(Object? json) {
    if (json == null) {
      return null;
    }
    if (T.toString() == 'String') {
      return json.toString() as T;
    } else if (T.toString() == 'Map<dynamic, dynamic>') {
      return json as T;
    } else {
      /// List类型数据由fromJsonAsT判断处理
      return JsonUtils.fromJsonAsT<T>(json);
    }
  }
}
