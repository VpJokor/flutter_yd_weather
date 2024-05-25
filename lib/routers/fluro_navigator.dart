import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'routers.dart';

/// fluro的路由跳转工具类
class NavigatorUtils {
  static void push(BuildContext context, String path,
      {bool replace = false,
      bool clearStack = false,
      transition = TransitionType.cupertino,
      Object? arguments}) {
    unfocus();
    Routes.router.navigateTo(
      context,
      path,
      replace: replace,
      clearStack: clearStack,
      transition: transition,
      routeSettings: RouteSettings(
        arguments: arguments,
      ),
    );
  }

  static void pushResult(
      BuildContext context, String path, void Function(Object) function,
      {bool replace = false,
      bool clearStack = false,
      transition = TransitionType.cupertino,
      Object? arguments}) {
    unfocus();
    Routes.router
        .navigateTo(
      context,
      path,
      replace: replace,
      clearStack: clearStack,
      transition: transition,
      routeSettings: RouteSettings(
        arguments: arguments,
      ),
    )
        .then((Object? result) {
      // 页面返回result为null
      if (result == null) {
        return;
      }
      function(result);
    }).catchError((dynamic error) {
      debugPrint('$error');
    });
  }

  /// 返回
  static void goBack(BuildContext context) {
    unfocus();
    Navigator.pop(context);
  }

  /// 带参数返回
  static void goBackWithParams(BuildContext context, Object result) {
    unfocus();
    Navigator.pop<Object>(context, result);
  }

  static void goBackUntil(BuildContext context, String path) {
    unfocus();
    Navigator.popUntil(context, ModalRoute.withName(path));
  }

  static void unfocus() {
    // 使用下面的方式，会触发不必要的build。
    // FocusScope.of(context).unfocus();
    // https://github.com/flutter/flutter/issues/47128#issuecomment-627551073
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
