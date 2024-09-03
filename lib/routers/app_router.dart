import 'package:fluro/fluro.dart';
import 'package:flutter_yd_weather/pages/select_city_page.dart';
import 'package:flutter_yd_weather/pages/weather_bg_list_page.dart';
import 'package:flutter_yd_weather/pages/weather_card_sort_page.dart';
import 'package:flutter_yd_weather/routers/router_init.dart';

class AppRouter implements IRouterProvider {
  static const String selectCityPage = '/home/selectCityPage';
  static const String weatherCardSortPage = '/home/weatherCardSortPage';
  static const String weatherBgListPage = '/home/weatherBgListPage';

  @override
  void initRouter(FluroRouter router) {
    router.define(selectCityPage,
        handler: Handler(handlerFunc: (_, __) => const SelectCityPage()));
    router.define(weatherCardSortPage,
        handler: Handler(handlerFunc: (_, __) => const WeatherCardSortPage()));
    router.define(weatherBgListPage,
        handler: Handler(handlerFunc: (_, __) => const WeatherBgListPage()));
  }
}
