import 'package:package_info_plus/package_info_plus.dart';

import '../utils/log.dart';

class AppRuntimeData {
  factory AppRuntimeData() => _singleton;

  AppRuntimeData._internal();

  static final AppRuntimeData _singleton = AppRuntimeData._internal();

  static AppRuntimeData get instance => AppRuntimeData();

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  PackageInfo getPackageInfo() => _packageInfo;

  void updatePackageInfo(PackageInfo? packageInfo) {
    if (packageInfo == null) return;
    L.e("packageInfo = $packageInfo");
    _packageInfo = packageInfo;
  }
}
