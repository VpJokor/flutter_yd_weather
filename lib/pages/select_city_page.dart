import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_yd_weather/base/base_list_view.dart';
import 'package:flutter_yd_weather/model/city_data.dart';
import 'package:flutter_yd_weather/mvp/power_presenter.dart';
import 'package:flutter_yd_weather/pages/presenter/select_city_presenter.dart';
import 'package:flutter_yd_weather/pages/provider/select_city_provider.dart';
import 'package:flutter_yd_weather/utils/log.dart';
import 'package:flutter_yd_weather/utils/theme_utils.dart';
import 'package:flutter_yd_weather/utils/toast_utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../base/base_list_page.dart';
import '../base/base_list_provider.dart';
import '../utils/permission_utils.dart';
import '../widget/my_search_bar.dart';

class SelectCityPage extends StatefulWidget {
  const SelectCityPage({super.key});

  @override
  State<StatefulWidget> createState() => _SelectCityPageState();
}

class _SelectCityPageState
    extends BaseListPageState<SelectCityPage, CityData, SelectCityProvider>
    implements BaseListView<CityData> {
  late SelectCityPresenter _selectCityPresenter;

  @override
  void initState() {
    super.initState();
    _obtainLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: MySearchBar(
          hintText: "搜索城市（中文/拼音）",
          backgroundColor: context.backgroundColor,
          showDivider: true,
          autofocus: false,
          onChanged: (searchKey) {},
          submittedHintText: "请输入搜索关键字",
          onSubmitted: (searchKey) {},
        ),
        body: super.build(context),
      ),
    );
  }

  void _obtainLocationPermission() {
    PermissionUtils.checkPermission(
      permissionList: [
        Permission.location,
      ],
      onSuccess: () {
        _startLocation();
      },
      onFailed: () {},
    );
  }

  void _startLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    final permission = await Geolocator.checkPermission();
    Log.e("serviceEnabled = $serviceEnabled permission = $permission");
    if (!serviceEnabled ||
        permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      Toast.show("定位失败！");
      return;
    }
    final lastPosition = await Geolocator.getLastKnownPosition();
    if (lastPosition != null) {
      _selectCityPresenter.obtainLocationInfoByCurrentPosition(lastPosition);
    } else {
      try {
        final position = await Geolocator.getCurrentPosition(
            timeLimit: const Duration(milliseconds: 4000));
        _selectCityPresenter.obtainLocationInfoByCurrentPosition(position);
      } catch (error) {
        Log.e("_startLocation error ${error.toString()}");
      }
    }
  }

  @override
  Widget buildItem(
      BuildContext context, int index, BaseListProvider<CityData> provider) {
    return Container();
  }

  @override
  BaseListProvider<CityData> get baseProvider => provider;

  @override
  PowerPresenter createPresenter() {
    final PowerPresenter<dynamic> powerPresenter =
        PowerPresenter<dynamic>(this);
    _selectCityPresenter = SelectCityPresenter();
    powerPresenter.requestPresenter([_selectCityPresenter]);
    return powerPresenter;
  }

  @override
  SelectCityProvider generateProvider() => SelectCityProvider();
}
