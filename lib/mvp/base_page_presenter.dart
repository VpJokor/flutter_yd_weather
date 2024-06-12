import 'package:dio/dio.dart';

import '../net/net_utils.dart';
import 'base_presenter.dart';
import 'mvps.dart';

class BasePagePresenter<V extends IMvpView> extends BasePresenter<V> {
  BasePagePresenter() {
    _cancelToken = CancelToken();
  }

  late CancelToken _cancelToken;

  @override
  void dispose() {
    /// 销毁时，将请求取消
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel();
    }
  }

  /// 返回Future 适用于刷新，加载更多
  Future<dynamic> requestNetwork<T>(
    Method method, {
    required String url,
    bool isShow = true,
    bool isShowToast = true,
    NetSuccessCallback<T?>? onSuccess,
    NetErrorCallback? onError,
    dynamic params,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    int delayMilliseconds = 0,
  }) {
    if (isShow) {
      view.showProgress();
    }
    return NetUtils.instance.requestNetwork<T>(
      method,
      url,
      params: params,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken ?? _cancelToken,
      delayMilliseconds: delayMilliseconds,
      onSuccess: (data) {
        if (isShow) {
          view.closeProgress(true);
        }
        onSuccess?.call(data);
      },
      onError: (msg) {
        _onError(msg, onError);
      },
    );
  }

  void _onError(String msg, NetErrorCallback? onError,
      {bool isShow = true, bool isShowToast = true}) {
    /// 异常时直接关闭加载圈，不受isClose影响
    if (isShow) {
      view.closeProgress(false);
    }
    if (isShowToast) {
      view.showToast(msg);
    }

    /// 页面如果dispose，则不回调onError
    if (onError != null) {
      onError(msg);
    }
  }
}
