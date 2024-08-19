import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/model/city_data.dart';
import 'package:flutter_yd_weather/mvp/power_presenter.dart';
import 'package:flutter_yd_weather/pages/presenter/select_city_presenter.dart';
import 'package:flutter_yd_weather/pages/provider/select_city_provider.dart';
import 'package:flutter_yd_weather/pages/view/select_city_view.dart';
import 'package:flutter_yd_weather/res/colours.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/utils/log.dart';
import 'package:flutter_yd_weather/utils/theme_utils.dart';
import 'package:flutter_yd_weather/utils/toast_utils.dart';
import 'package:flutter_yd_weather/widget/opacity_layout.dart';
import 'package:flutter_yd_weather/widget/select_city_footer.dart';
import 'package:flutter_yd_weather/widget/select_city_header.dart';
import 'package:flutter_yd_weather/widget/select_city_item.dart';
import 'package:provider/provider.dart';
import '../base/base_list_page.dart';
import '../base/base_list_provider.dart';
import '../model/location_data.dart';
import '../provider/main_provider.dart';
import '../widget/my_search_bar.dart';

class SelectCityPage extends StatefulWidget {
  const SelectCityPage({super.key});

  @override
  State<StatefulWidget> createState() => _SelectCityPageState();
}

class _SelectCityPageState
    extends BaseListPageState<SelectCityPage, CityData, SelectCityProvider>
    implements SelectCityView {
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
          debounced: true,
          debouncedMill: 333,
          onChanged: (searchKey) {
            Log.e("searchKey = $searchKey");
            if (searchKey.isNullOrEmpty()) {
              provider.searchResult = null;
            } else {
              searchCity(searchKey, (result) {
                if (result.isNullOrEmpty()) {
                  Toast.show("无匹配城市");
                }
                provider.searchResult = result;
              });
            }
          },
          submittedHintText: "请输入搜索关键字",
        ),
        body: super.build(context),
      ),
    );
  }

  @override
  Widget getContent(SelectCityProvider provider) {
    return Stack(
      children: [
        super.getContent(provider),
        AnimatedOpacity(
          opacity: provider.searchResult.isNotNullOrEmpty() ? 1 : 0,
          duration: const Duration(milliseconds: 222),
          child: Visibility(
            visible: provider.searchResult.isNotNullOrEmpty(),
            child: Container(
              color: context.backgroundColor,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 12.w),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                itemBuilder: (context, index) {
                  final data = provider.searchResult?[index];
                  final mainP = context.read<MainProvider>();
                  final cityDataBox = mainP.cityDataBox;
                  final hasAdded = cityDataBox.containsKey(data?.cityId);
                  final content = (data?.prov.isNullOrEmpty() ?? true)
                      ? "${data?.name} - ${data?.country}"
                      : "${data?.name} - ${data?.prov} - ${data?.country}";
                  return OpacityLayout(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.w),
                      child: Text(
                        content,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: hasAdded
                              ? context.appMain
                              : context.textColor01,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onPressed: () {
                      mainP.addCity(context, hasAdded, data);
                    },
                  );
                },
                itemCount: provider.searchResult?.length ?? 0,
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget? getHeader(SelectCityProvider provider) {
    return SliverToBoxAdapter(
      child: SelectCityHeader(
        locationData: provider.locationData,
        locationStatus: provider.locationStatus,
        onTap: () {
          final locationData = provider.locationData;
          if (locationData != null) {
          } else {
            if (provider.locationStatus == 1) {
              _selectCityPresenter.obtainLocationPermission();
            }
          }
        },
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
  Widget? getFooter(SelectCityProvider provider) {
    return SliverToBoxAdapter(
      child: SelectCityFooter(
        selectCityData: provider.selectCityData,
      ),
    );
  }

  @override
  void locationSuccess(LocationData? locationData) {
    final mainP = context.read<MainProvider>();
    final cityDataBox = mainP.cityDataBox;
    final locationCity = cityDataBox.get(Constants.locationCityId);
    if (locationData != null &&
        locationCity != null &&
        locationCity.cityId.isNullOrEmpty()) {
      searchCity(locationData.addressComponent?.district ?? "", (result) {
        if (result.isNotNullOrEmpty()) {
          final province = locationData.addressComponent?.province ?? "";
          final find = result!.singleOrNull((element) =>
              element.name == locationData.addressComponent?.district &&
              (province.contains(element.prov ?? "") ||
                  (element.prov ?? "").contains(province)));
          if (find != null) {
            find.isLocationCity = true;
            mainP.addCity(context, false, find);
          }
        }
      }, showLoading: false);
    }
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
