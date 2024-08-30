import 'dart:math';

import 'package:animated_item/animated_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/config/app_runtime_data.dart';
import 'package:flutter_yd_weather/model/city_data.dart';
import 'package:flutter_yd_weather/res/colours.dart';
import 'package:flutter_yd_weather/utils/commons.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/utils/pair.dart';
import 'package:flutter_yd_weather/utils/theme_utils.dart';
import 'package:flutter_yd_weather/utils/weather_data_utils.dart';
import 'package:flutter_yd_weather/widget/scroll_snap_list.dart';
import 'package:flutter_yd_weather/widget/weather_city_selector_item.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';

import '../config/constants.dart';
import '../model/weather_item_data.dart';
import '../provider/main_provider.dart';

class WeatherCitySelector extends StatefulWidget {
  const WeatherCitySelector({super.key});

  @override
  State<StatefulWidget> createState() => WeatherCitySelectorState();
}

class WeatherCitySelectorState extends State<WeatherCitySelector> {
  ScrollController? _scrollController;
  final _list = <Pair<CityData?, List<WeatherItemData>>>[];
  double _opacity = 0;
  double _scale = 1;

  @override
  void initState() {
    super.initState();
    _opacity = 0;
    _scale = 1;

    Commons.post((_) {
      _generateData();
    });
  }

  Future<void> _generateData() async {
    final mainP = context.read<MainProvider>();
    final currentCityIdList =
        SpUtil.getStringList(Constants.currentCityIdList) ?? [];
    for (var cityId in currentCityIdList) {
      final cityData = mainP.cityDataBox.get(cityId);
      final findCityId = cityData?.cityId ?? "";
      if (findCityId.isNotNullOrEmpty()) {
        final pair = Pair(
          first: cityData,
          second: WeatherDataUtils.generateWeatherItems(
            mainP.currentWeatherCardSort,
            mainP.currentWeatherObservesCardSort,
            AppRuntimeData.instance.getWeatherData(cityId),
          ),
        );
        if (cityId == Constants.locationCityId) {
          _list.insert(0, pair);
        } else {
          _list.add(pair);
        }
      }
    }
    final initIndex = _list.indexWhere((e) => e.first == mainP.currentCityData);
    _scrollController = ScrollController();
    setState(() {
      _opacity = 1;
      _scale = 0.6;
    });
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  void exit() {
    setState(() {
      _opacity = 0;
      _scale = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1,
      duration: const Duration(milliseconds: 600),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: context.backgroundColor,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: double.infinity,
                height: ScreenUtil().screenHeight * 0.6,
                child: ScrollSnapList(
                  scrollPhysics: const BouncingScrollPhysics(),
                  onItemFocus: (index) {
                    debugPrint("onItemFocus index = $index");
                  },
                  itemSize: ScreenUtil().screenWidth * 0.6,
                  itemBuilder: (_, index) {
                    final item = _list[index];
                    return WeatherCitySelectorItem(
                      pair: item,
                    );
                  },
                  itemCount: _list.length,
                  dynamicItemSize: true,
                  dynamicSizeEquation: (difference) {
                    return 1 - min(difference.abs() / 1500, 0.6);
                  }, //optional
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
