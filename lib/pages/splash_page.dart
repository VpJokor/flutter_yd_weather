import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/model/city_data.dart';
import 'package:flutter_yd_weather/provider/main_provider.dart';
import 'package:flutter_yd_weather/routers/app_router.dart';
import 'package:flutter_yd_weather/routers/fluro_navigator.dart';
import 'package:flutter_yd_weather/routers/routers.dart';
import 'package:flutter_yd_weather/utils/commons.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/utils/image_utils.dart';
import 'package:flutter_yd_weather/utils/log.dart';
import 'package:flutter_yd_weather/utils/theme_utils.dart';
import 'package:flutter_yd_weather/widget/load_asset_image.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    final cityDataBox = context.read<MainProvider>().cityDataBox;
    var locationCity = cityDataBox.get(Constants.locationCityId);
    if (locationCity == null) {
      locationCity = CityData.locationCity();
      cityDataBox.put(Constants.locationCityId, locationCity);
    }
    Commons.postDelayed(delayMilliseconds: 800, () {
      if ((locationCity?.cityId).isNotNullOrEmpty()) {
        NavigatorUtils.push(
          context,
          Routes.main,
          transition: TransitionType.fadeIn,
          replace: true,
        );
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
