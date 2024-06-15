import 'package:fluro/fluro.dart';
import 'package:flutter_yd_weather/pages/city_manager_page.dart';
import 'package:flutter_yd_weather/pages/select_city_page.dart';
import 'package:flutter_yd_weather/routers/router_init.dart';

class AppRouter implements IRouterProvider {
  static const String selectCityPage = '/home/selectCityPage';
  static const String cityManagerPage = '/home/cityManagerPage';

  @override
  void initRouter(FluroRouter router) {
    router.define(selectCityPage,
        handler: Handler(handlerFunc: (_, __) => const SelectCityPage()));
    router.define(cityManagerPage,
        handler: Handler(handlerFunc: (_, __) => const CityManagerPage()));
  }
}