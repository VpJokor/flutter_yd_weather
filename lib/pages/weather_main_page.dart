import 'package:extended_sliver/extended_sliver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/mvp/power_presenter.dart';
import 'package:flutter_yd_weather/pages/presenter/weather_main_presenter.dart';
import 'package:flutter_yd_weather/pages/provider/weather_provider.dart';
import 'package:flutter_yd_weather/res/gaps.dart';
import 'package:flutter_yd_weather/utils/weather_persistent_header_delegate.dart';
import '../base/base_list_page.dart';
import '../base/base_list_view.dart';
import '../config/constants.dart';
import '../model/weather_item_data.dart';
import '../res/colours.dart';

class WeatherMainPage extends StatefulWidget {
  const WeatherMainPage({super.key});

  @override
  State<WeatherMainPage> createState() => _WeatherMainPageState();
}

class _WeatherMainPageState
    extends BaseListPageState<WeatherMainPage, WeatherItemData, WeatherProvider>
    implements BaseListView<WeatherItemData> {
  late WeatherMainPresenter _weatherMainPresenter;

  @override
  void initState() {
    super.initState();
    setEnableRefresh(false);
    setEnableLoad(false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
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
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverPersistentHeader(
            pinned: true,
            delegate: WeatherPersistentHeaderDelegate(
              provider.list.last,
            ),
          ),
        ],
        body: super.build(context),
      ),
    );
  }

  @override
  WeatherProvider get baseProvider => provider;

  @override
  List<Widget> getRefreshGroup(WeatherProvider provider) {
    final refreshGroup = <Widget>[];
    for (var weatherItemData in provider.list) {
      refreshGroup.add(SliverMainAxisGroup(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: WeatherPersistentHeaderDelegate(
              weatherItemData,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colours.white,
              margin: EdgeInsets.symmetric(
                horizontal: 16.w,
              ),
              child: Text(
                weatherItemData.weatherData?.toJson().toString() ?? "",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colours.color333333,
                ),
              ),
            ),
          )
        ],
      ));
    }
    return refreshGroup;
  }

  @override
  Widget buildItem(BuildContext context, int index, WeatherProvider provider) {
    return Gaps.empty;
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
  WeatherProvider generateProvider() => WeatherProvider();
}
