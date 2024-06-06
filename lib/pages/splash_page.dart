import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/model/city_data.dart';
import 'package:flutter_yd_weather/routers/app_router.dart';
import 'package:flutter_yd_weather/routers/fluro_navigator.dart';
import 'package:flutter_yd_weather/utils/commons.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/utils/image_utils.dart';
import 'package:flutter_yd_weather/utils/log.dart';
import 'package:flutter_yd_weather/utils/theme_utils.dart';
import 'package:flutter_yd_weather/widget/load_asset_image.dart';
import 'package:hive/hive.dart';

import '../res/colours.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _cityDataBox = Hive.box<CityData>(Constants.cityDataBox);

  @override
  void initState() {
    super.initState();
    final cityListSize = _cityDataBox.length;
    Log.e("cityListSize = $cityListSize");
    Commons.postDelayed(delayMilliseconds: 800, () {
      if (cityListSize > 0) {
      } else {
        NavigatorUtils.push(
          context,
          AppRouter.selectCityPage,
          transition: TransitionType.fadeIn,
          replace: true,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.systemUiOverlayStyle,
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        body: LoadAssetImage(
          context.splash,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
