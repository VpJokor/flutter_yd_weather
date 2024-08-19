import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_yd_weather/net/result_data.dart';
import '../utils/log.dart';
import 'error_handle.dart';

/// 默认dio配置
Duration _connectTimeout = const Duration(seconds: 15);
Duration _receiveTimeout = const Duration(seconds: 15);
Duration _sendTimeout = const Duration(seconds: 10);
String _baseUrl = '';
List<Interceptor> _interceptors = [];

/// 初始化Dio配置
void configDio({
  Duration? connectTimeout,
  Duration? receiveTimeout,
  Duration? sendTimeout,
  String? baseUrl,
  List<Interceptor>? interceptors,
}) {
  _connectTimeout = connectTimeout ?? _connectTimeout;
  _receiveTimeout = receiveTimeout ?? _receiveTimeout;
  _sendTimeout = sendTimeout ?? _sendTimeout;
  _baseUrl = baseUrl ?? _baseUrl;
  _interceptors = interceptors ?? _interceptors;
}

typedef NetSuccessCallback<T> = void Function(T data);
typedef NetSuccessListCallback<T> = void Function(List<T> data);
typedef NetErrorCallback = void Function(String msg);

class NetUtils {
  factory NetUtils() => _singleton;

  static late Dio _dio;

  Dio get dio => _dio;

  NetUtils._internal() {
    // 初始化
    final BaseOptions options = BaseOptions(
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      sendTimeout: _sendTimeout,

      /// dio默认json解析，这里指定返回UTF8字符串，自己处理解析。（可也以自定义Transformer实现）
      responseType: ResponseType.plain,
      validateStatus: (_) {
        // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
        return true;
      },
      baseUrl: _baseUrl,
      contentType: Headers.formUrlEncodedContentType, // 适用于post form表单提交
    );

    _dio = Dio(options);

    /// 添加拦截器
    void addInterceptor(Interceptor interceptor) {
      _dio.interceptors.add(interceptor);
    }

    _interceptors.forEach(addInterceptor);
  }

  static final NetUtils _singleton = NetUtils._internal();

  static NetUtils get instance => NetUtils();

  // 数据返回格式统一，统一处理异常
  Future<ResultData<T>> _request<T>(String method, String url,
      {Object? data,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken,
      Options? options,
      int delayMilliseconds = 0}) async {
    if (delayMilliseconds > 0) {
      await Future.delayed(Duration(milliseconds: delayMilliseconds));
    }
    final Response<String> response = await _dio.request<String>(
      url,
      data: data,
      queryParameters: queryParameters,
      options: _checkOptions(method, options),
      cancelToken: cancelToken,
    );
    try {
      final String data = response.data.toString();
      final Map<String, dynamic> map = parseData(data);

      return ResultData<T>.fromJson(map);
    } catch (e) {
      Log.e("request error ${e.toString()}");
      return ResultData<T>(-1, "数据解析错误", null);
    }
  }

  Options _checkOptions(String method, Options? options) {
    options ??= Options();
    options.method = method;
    return options;
  }

  Map<String, dynamic> parseData(String data) {
    return json.decode(data) as Map<String, dynamic>;
  }

  Future<dynamic> requestNetwork<T>(Method method, String url,
      {NetSuccessCallback<T?>? onSuccess,
      NetErrorCallback? onError,
      Object? params,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken,
      Options? options,
      int delayMilliseconds = 0}) {
    return _request<T>(method.value, url,
            data: params,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            delayMilliseconds: delayMilliseconds)
        .then<void>((ResultData<T> result) {
      if (result.data != null) {
        onSuccess?.call(result.data);
      } else {
        _onError(result.msg, onError);
      }
    }, onError: (dynamic e) {
      _cancelLogPrint(e, url);
      final NetError error = ExceptionHandle.handleException(e);
      _onError(error.msg, onError);
    });
  }

  Future<T?> requestNet<T>(Method method, String url,
      {NetSuccessCallback<T?>? onSuccess,
      NetErrorCallback? onError,
      Object? params,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken,
      Options? options,
      int delayMilliseconds = 0}) async {
    try {
      final result = await _request<T>(method.value, url,
          data: params,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          delayMilliseconds: delayMilliseconds);
      return Future.value(result.data);
    } catch (err) {
      _cancelLogPrint(err, url);
      return Future.value(null);
    }
  }

  void _cancelLogPrint(dynamic e, String url) {
    if (e is DioException && CancelToken.isCancel(e)) {
      Log.e('取消请求接口： $url');
    }
  }

  void _onError(String msg, NetErrorCallback? onError) {
    Log.e('接口请求异常： mag: $msg');
    onError?.call(msg);
  }
}

enum Method { get, post, put, patch, delete, head }

/// 使用拓展枚举替代 switch判断取值
/// https://zhuanlan.zhihu.com/p/98545689
extension MethodExtension on Method {
  String get value => ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD'][index];
}
