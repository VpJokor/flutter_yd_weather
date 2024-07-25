import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/main.dart';
import 'package:flutter_yd_weather/mvp/power_presenter.dart';
import 'package:flutter_yd_weather/pages/presenter/weather_main_presenter.dart';
import 'package:flutter_yd_weather/pages/provider/weather_provider.dart';
import 'package:flutter_yd_weather/pages/view/weather_main_view.dart';
import 'package:flutter_yd_weather/res/gaps.dart';
import 'package:flutter_yd_weather/routers/app_router.dart';
import 'package:flutter_yd_weather/routers/fluro_navigator.dart';
import 'package:flutter_yd_weather/utils/log.dart';
import 'package:flutter_yd_weather/utils/weather_persistent_header_delegate.dart';
import 'package:flutter_yd_weather/widget/load_asset_image.dart';
import 'package:flutter_yd_weather/widget/opacity_layout.dart';
import 'package:flutter_yd_weather/widget/weather_header_widget.dart';
import 'package:provider/provider.dart';
import '../base/base_list_page.dart';
import '../config/constants.dart';
import '../model/weather_item_data.dart';
import '../res/colours.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';

class WeatherMainPage extends StatefulWidget {
  const WeatherMainPage({super.key});

  @override
  State<WeatherMainPage> createState() => _WeatherMainPageState();
}

class _WeatherMainPageState
    extends BaseListPageState<WeatherMainPage, WeatherItemData, WeatherProvider>
    implements WeatherMainView {
  late WeatherMainPresenter _weatherMainPresenter;
  final _weatherHeaderKey = GlobalKey<WeatherHeaderWidgetState>();
  late StreamSubscription<RefreshWeatherDataEvent>
      _refreshWeatherDataEventSubscription;

  @override
  void initState() {
    super.initState();
    setEnableRefresh(false);
    setEnableLoad(false);
    _refreshWeatherDataEventSubscription =
        eventBus.on<RefreshWeatherDataEvent>().listen((event) {
      _weatherMainPresenter.obtainWeatherData(delayMilliseconds: 200);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _refreshWeatherDataEventSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colours.color464E96,
              Colours.color547EA9,
              Colours.color409AAF,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ChangeNotifierProvider<WeatherProvider>(
          create: (_) => provider,
          child: Consumer<WeatherProvider>(
            builder: (_, p, __) {
              final weatherHeaderItemData = p.list.singleOrNull((element) =>
                  element.itemType == Constants.itemTypeWeatherHeader);
              return Stack(
                children: [
                  WeatherHeaderWidget(
                    key: _weatherHeaderKey,
                    weatherItemData: weatherHeaderItemData,
                    onRefresh: () {
                      _weatherMainPresenter.obtainWeatherData(delayMilliseconds: 800);
                    },
                  ),
                  Column(
                    children: [
                      Gaps.generateGap(height: ScreenUtil().statusBarHeight),
                      Gaps.generateGap(
                          height: weatherHeaderItemData?.minHeight),
                      Expanded(
                        child: Listener(
                          onPointerUp: (_) {
                            _weatherHeaderKey.currentState?.onRelease();
                          },
                          child: super.build(context),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    top: ScreenUtil().statusBarHeight,
                    child: OpacityLayout(
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        margin: EdgeInsets.all(8.w),
                        child: LoadAssetImage(
                          "ic_add",
                          width: 20.w,
                          height: 20.w,
                        ),
                      ),
                      onPressed: () {
                        NavigatorUtils.push(context, AppRouter.cityManagerPage,
                            transition: TransitionType.fadeIn);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  WeatherProvider get baseProvider => provider;

  @override
  void setScrollController(ScrollController? scrollController) {
    super.setScrollController(scrollController);
    scrollController?.addListener(() {
      final offset = scrollController.offset;
      final weatherHeaderItemData = provider.list.singleOrNull(
          (element) => element.itemType == Constants.itemTypeWeatherHeader);
      final percent = offset /
          ((weatherHeaderItemData?.maxHeight ?? 0) -
              (weatherHeaderItemData?.minHeight ?? 0));
      _weatherHeaderKey.currentState?.change(offset, percent);
    });
  }

  @override
  List<Widget> getRefreshGroup(WeatherProvider provider) {
    final refreshGroup = <Widget>[];
    for (var weatherItemData in provider.list) {
      if (weatherItemData.itemType == Constants.itemTypeWeatherHeader) continue;
      refreshGroup.add(SliverMainAxisGroup(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: WeatherPersistentHeaderDelegate(
              weatherItemData,
            ),
          ),
          SliverToBoxAdapter(
            child: Gaps.generateGap(height: 12.w),
          ),
        ],
      ));
    }
    return refreshGroup;
  }

  @override
  double getAnchor(WeatherProvider provider, double contentHeight) {
    if (!mounted) return 0.0;
    final weatherHeaderItemData = provider.list.singleOrNull(
        (element) => element.itemType == Constants.itemTypeWeatherHeader);
    final anchor = ((weatherHeaderItemData?.maxHeight ?? 0) -
            (weatherHeaderItemData?.minHeight ?? 0)) /
        contentHeight;
    Log.e("anchor = $anchor");
    return anchor;
  }

  @override
  Widget buildItem(BuildContext context, int index, WeatherProvider provider) {
    return Gaps.empty;
  }

  @override
  Widget? getFooter(WeatherProvider provider) {
    final source = provider.list.firstOrNull()?.weatherData?.source?.title;
    return source.isNullOrEmpty()
        ? null
        : SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 12.w),
              child: Text(
                "天气信息来自$source",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colours.white.withOpacity(0.4),
                ),
              ),
            ),
          );
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

  @override
  void obtainWeatherDataCallback() {
    _weatherHeaderKey.currentState?.refreshComplete();
  }
}
