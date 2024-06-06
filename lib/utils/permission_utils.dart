import 'package:flutter_yd_weather/utils/toast_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

import 'log.dart';

/// 參考 https://gitee.com/half_city/flutter_identification_photo/blob/master/lib/utils/permission_util.dart
class PermissionUtils {
  static defaultCall(String msg) {
    Toast.show(msg);
  }

  /// 检测石是否有权限
  /// [permissionList] 权限申请列表
  /// [onSuccess] 全部成功
  /// [onFailed] 有一个失败
  /// [goSetting] 前往设置
  static checkPermission(
      {required List<Permission> permissionList,
      VoidCallback? onSuccess,
      VoidCallback? onFailed,
      VoidCallback? goSetting}) async {
    ///一个新待申请权限列表
    List<Permission> newPermissionList = [];

    ///遍历当前权限申请列表
    for (Permission permission in permissionList) {
      PermissionStatus status = await permission.status;

      ///如果不是允许状态就添加到新的申请列表中
      if (!status.isGranted) {
        newPermissionList.add(permission);
      }
    }

    ///如果需要重新申请的列表不是空的
    if (newPermissionList.isNotEmpty) {
      PermissionStatus permissionStatus =
          await requestPermission(newPermissionList);

      switch (permissionStatus) {
        ///拒绝状态
        case PermissionStatus.denied:
          onFailed != null ? onFailed() : defaultCall("权限申请失败");
          break;

        ///允许状态
        case PermissionStatus.granted:
          onSuccess != null ? onSuccess() : defaultCall("权限申请成功");
          break;

        /// 永久拒绝  活动限制
        case PermissionStatus.restricted:
        case PermissionStatus.limited:
        case PermissionStatus.permanentlyDenied:
          goSetting != null ? goSetting() : await openAppSettings();
          break;
        case PermissionStatus.provisional:
          break;
      }
    } else {
      onSuccess != null ? onSuccess() : defaultCall("权限申请成功");
    }
  }

  /// 获取新列表中的权限 如果有一项不合格就返回false
  static requestPermission(List<Permission> permissionList) async {
    Map<Permission, PermissionStatus> statuses = await permissionList.request();
    PermissionStatus currentPermissionStatus = PermissionStatus.granted;
    statuses.forEach((key, value) {
      if (!value.isGranted) {
        Log.e("not granted = $key");
        currentPermissionStatus = value;
        return;
      }
    });
    return currentPermissionStatus;
  }
}
