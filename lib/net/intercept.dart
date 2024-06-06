import 'package:dio/dio.dart';
import '../utils/log.dart';
import 'error_handle.dart';

class LoggingInterceptor extends Interceptor {
  late DateTime _startTime;
  late DateTime _endTime;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _startTime = DateTime.now();
    Log.e('----------Start----------');
    if (options.queryParameters.isEmpty) {
      Log.e('RequestUrl: ${options.baseUrl}${options.path}');
    } else {
      Log.e(
          'RequestUrl: ${options.baseUrl}${options.path}?${Transformer.urlEncodeMap(options.queryParameters)}');
    }
    Log.e('RequestMethod: ${options.method}');
    Log.e('RequestHeaders:${options.headers}');
    Log.e('RequestContentType: ${options.contentType}');
    Log.e('RequestData: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    _endTime = DateTime.now();
    final int duration = _endTime.difference(_startTime).inMilliseconds;
    if (response.statusCode == ExceptionHandle.success) {
      Log.e('ResponseCode: ${response.statusCode}');
    } else {
      Log.e('ResponseCode: ${response.statusCode}');
    }
    // 输出结果
    Log.json(response.data.toString());
    Log.e('----------End: $duration 毫秒----------');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Log.e('----------Error-----------');
    super.onError(err, handler);
  }
}
