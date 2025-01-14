import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart' as dioCookieManager;
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/model/city_data.dart';
import 'package:flutter_yd_weather/model/simple_weather_data.dart';
import 'package:flutter_yd_weather/pages/splash_page.dart';
import 'package:flutter_yd_weather/provider/locale_provider.dart';
import 'package:flutter_yd_weather/provider/main_provider.dart';
import 'package:flutter_yd_weather/provider/theme_provider.dart';
import 'package:flutter_yd_weather/routers/routers.dart';
import 'package:flutter_yd_weather/utils/device.dart';
import 'package:flutter_yd_weather/utils/handle_error_utils.dart';
import 'package:flutter_yd_weather/utils/log.dart';
import 'package:flutter_yd_weather/utils/theme_utils.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sp_util/sp_util.dart';

import 'config/app_runtime_data.dart';
import 'net/intercept.dart';
import 'net/net_utils.dart';

EventBus eventBus = EventBus();

class RefreshWeatherDataEvent {
  final bool isAdd;

  RefreshWeatherDataEvent({
    this.isAdd = false,
  });
}

class SwitchWeatherCityEvent {
  final bool refreshWeatherData;
  final int scrollToTopDelay;

  SwitchWeatherCityEvent({
    this.refreshWeatherData = false,
    this.scrollToTopDelay = 0,
  });
}

Future<void> main() async {
  /// 异常处理
  handleError(() async {
    /// 确保初始化完成
    WidgetsFlutterBinding.ensureInitialized();
    final info = await PackageInfo.fromPlatform();
    AppRuntimeData.instance.updatePackageInfo(info);
    await SpUtil.getInstance();

    /// Hive
    await Hive.initFlutter();
    Hive.registerAdapter(CityDataAdapter());
    Hive.registerAdapter(SimpleWeatherDataAdapter());
    await Hive.openBox<CityData>(Constants.cityDataBox);
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  MyApp({super.key, this.theme, this.home}) {
    Log.init();
    _initDio();
    Routes.initRoutes();
  }

  final Widget? home;
  final ThemeData? theme;

  void _initDio() {
    final List<Interceptor> interceptors = <Interceptor>[];

    /// 打印Log(生产模式去除)
    if (!Constants.inProduction) {
      interceptors.add(LoggingInterceptor());
    }
    final cookieJar = CookieJar();
    interceptors.add(dioCookieManager.CookieManager(cookieJar));

    configDio(
      interceptors: interceptors,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget app = MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => MainProvider()),
      ],
      child: Consumer3<ThemeProvider, LocaleProvider, MainProvider>(
        builder: (_, ThemeProvider provider, LocaleProvider localeProvider,
            MainProvider mainProvider, __) {
          return _buildMaterialApp(provider, localeProvider, mainProvider);
        },
      ),
    );

    /// Toast 配置
    return OKToast(
      backgroundColor: Colors.black54,
      textPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      radius: 20.0,
      position: ToastPosition.center,
      child: app,
    );
  }

  Widget _buildMaterialApp(ThemeProvider themeProvider,
      LocaleProvider localeProvider, MainProvider mainProvider) {
    return ScreenUtilInit(
      designSize: const Size(375, 667),
      builder: (context, child) => MaterialApp(
        title: AppRuntimeData.instance.getPackageInfo().appName,
        theme: theme ?? themeProvider.getTheme(),
        darkTheme: themeProvider.getTheme(isDarkMode: true),
        themeMode: themeProvider.getThemeMode(),
        home: home ?? const SplashPage(),
        onGenerateRoute: Routes.router.generator,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('zh', 'CH'),
          Locale('en', 'US'),
        ],
        locale: localeProvider.locale,
        navigatorObservers: [FlutterSmartDialog.observer],
        builder: FlutterSmartDialog.init(
            builder: (BuildContext context, Widget? child) {
          /// 仅针对安卓
          if (Device.isAndroid) {
            /// 切换深色模式会触发此方法，这里设置导航栏颜色
            ThemeUtils.setSystemNavigationBar(themeProvider.getThemeMode());
          }

          /// 保证文字大小不受手机系统设置影响 https://www.kikt.top/posts/flutter/layout/dynamic-text/
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.noScaling),
            child: child!,
          );
        }),
        restorationScopeId: 'app',
      ),
    );
  }
}
