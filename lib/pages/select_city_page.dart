import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/base/base_list_view.dart';
import 'package:flutter_yd_weather/model/city_data.dart';
import 'package:flutter_yd_weather/mvp/power_presenter.dart';
import 'package:flutter_yd_weather/pages/presenter/select_city_presenter.dart';
import 'package:flutter_yd_weather/pages/provider/select_city_provider.dart';
import 'package:flutter_yd_weather/utils/theme_utils.dart';
import 'package:flutter_yd_weather/widget/select_city_header.dart';
import 'package:flutter_yd_weather/widget/select_city_item.dart';
import '../base/base_list_page.dart';
import '../base/base_list_provider.dart';
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
    setEnableRefresh(false);
    setEnableLoad(false);
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

  @override
  Widget? getHeader(SelectCityProvider provider) {
    return SliverToBoxAdapter(
      child: SelectCityHeader(
        locationData: provider.locationData,
        locationStatus: provider.locationStatus,
      ),
    );
  }

  @override
  Widget getRefreshContent(SelectCityProvider provider) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          /// 每行 widget 数量
          crossAxisCount: 4,

          /// widget 水平之间的距离
          crossAxisSpacing: 16.w,

          /// widget 垂直之间的距离
          mainAxisSpacing: 16.w,

          childAspectRatio: 2 / 1,
        ),
        itemBuilder: (context, index) {
          return buildItem(context, index, provider);
        },
        itemCount: provider.selectCityData?.hotNational?.length ?? 0,
      ),
    );
  }

  @override
  Widget buildItem(
      BuildContext context, int index, SelectCityProvider provider) {
    return SelectCityItem(
      cityData: provider.selectCityData?.hotNational?[index],
    );
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
