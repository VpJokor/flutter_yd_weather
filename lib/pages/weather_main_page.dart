import 'package:flutter/material.dart';
import 'package:flutter_yd_weather/base/base_list_provider.dart';
import 'package:flutter_yd_weather/mvp/power_presenter.dart';
import 'package:flutter_yd_weather/pages/presenter/weather_main_presenter.dart';
import '../base/base_list_page.dart';
import '../base/base_list_view.dart';
import '../res/colours.dart';

class WeatherMainPage extends StatefulWidget {
  const WeatherMainPage({super.key});

  @override
  State<WeatherMainPage> createState() => _WeatherMainPageState();
}

class _WeatherMainPageState extends BaseListPageState<WeatherMainPage, Object, BaseListProvider<Object>>
    implements BaseListView<Object> {
  late WeatherMainPresenter _weatherMainPresenter;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colours.color1B81A7,
            Colours.color2FA6BA,
            Colours.color6DC1C1,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  @override
  BaseListProvider<Object> get baseProvider => provider;

  @override
  Widget buildItem(BuildContext context, int index, BaseListProvider<Object> provider) {
    return Container();
  }

  @override
  PowerPresenter createPresenter() {
    final PowerPresenter<dynamic> powerPresenter =
    PowerPresenter<dynamic>(this);
    _weatherMainPresenter = WeatherMainPresenter();
    powerPresenter.requestPresenter([_weatherMainPresenter]);
    return powerPresenter;
  }

  @override
  BaseListProvider<Object> generateProvider() => BaseListProvider();
}
