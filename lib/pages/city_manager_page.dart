import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/base/base_list_view.dart';
import 'package:flutter_yd_weather/model/city_data.dart';
import 'package:flutter_yd_weather/mvp/power_presenter.dart';
import 'package:flutter_yd_weather/pages/provider/city_manager_provider.dart';
import 'package:flutter_yd_weather/provider/main_provider.dart';
import 'package:flutter_yd_weather/routers/app_router.dart';
import 'package:flutter_yd_weather/routers/fluro_navigator.dart';
import 'package:flutter_yd_weather/utils/commons.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/utils/log.dart';
import 'package:flutter_yd_weather/utils/theme_utils.dart';
import 'package:flutter_yd_weather/widget/city_manager_item.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import '../base/base_list_page.dart';
import '../res/colours.dart';
import '../res/gaps.dart';
import '../widget/animated_list_item.dart';
import '../widget/my_app_bar.dart';

class CityManagerPage extends StatefulWidget {
  const CityManagerPage({super.key, this.hideCityManagerPage,});

  final VoidCallback? hideCityManagerPage;

  @override
  State<CityManagerPage> createState() => CityManagerPageState();
}

class CityManagerPageState
    extends BaseListPageState<CityManagerPage, CityData, CityManagerProvider>
    implements BaseListView<CityData> {
  late AnimationController _animationController;
  int _animStartIndex = 0;
  int _animEndIndex = 0;
  List<int> _displayingChildIndexList = [];

  @override
  NotRefreshHeader? get notRefreshHeader =>
      const NotRefreshHeader(
        position: IndicatorPosition.locator,
        hitOver: true,
      );

  @override
  void initState() {
    super.initState();
    setEnableRefresh(false);
    setEnableLoad(false);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    Commons.post((_) {
      provider.largeTitleColor = context.black;
      provider.hideLoading();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  List<Offset> fixItemPosition(String cityId, {bool jumpTo = true}) {
    final contentPosition =
        (contentKey.currentContext?.findRenderObject() as RenderBox?)
            ?.localToGlobal(Offset.zero) ??
            Offset.zero;
    final contentHeight = contentKey.currentContext?.size?.height ?? 0;
    final itemPosition = _findItemPosition(cityId) ?? Offset.zero;
    final offset = scrollController?.offset ?? 0;
    if (itemPosition.dy < contentPosition.dy) {
      if (jumpTo) {
        scrollController
            ?.jumpTo(offset - (itemPosition.dy - contentPosition.dy).abs());
      }
      return [
        Offset(contentPosition.dx, contentPosition.dy + contentHeight),
        Offset(itemPosition.dx, contentPosition.dy),
      ];
    } else if (itemPosition.dy + 98.w > contentPosition.dy + contentHeight) {
      if (jumpTo) {
        scrollController?.jumpTo(offset +
            ((itemPosition.dy + 98.w) - (contentPosition.dy + contentHeight))
                .abs());
      }
      return [
        Offset(contentPosition.dx, contentPosition.dy + contentHeight),
        Offset(itemPosition.dx, contentPosition.dy + contentHeight - 98.w),
      ];
    }
    return [
      Offset(contentPosition.dx, contentPosition.dy + contentHeight),
      itemPosition,
    ];
  }

  void show(String cityId) {
    final contentPosition =
        (contentKey.currentContext?.findRenderObject() as RenderBox?)
            ?.localToGlobal(Offset.zero) ??
            Offset.zero;
    final contentHeight = contentKey.currentContext?.size?.height ?? 0;
    final currentItemPosition = _findItemPosition(cityId) ?? Offset.zero;
    setState(() {
      if (currentItemPosition.dy > contentPosition.dy + contentHeight * 0.5) {
        _animStartIndex = _displayingChildIndexList.last;
        _animEndIndex = _displayingChildIndexList.first;
      } else {
        _animStartIndex = _displayingChildIndexList.first;
        _animEndIndex = _displayingChildIndexList.last;
      }
    });
    _animationController.forward();
  }

  void hide(String cityId) {
    _animationController.reset();
  }

  Offset? _findItemPosition(String cityId) {
    final mainP = context.read<MainProvider>();
    final index = mainP.cityDataBox.values.toList().indexWhere((cityData) => cityData.cityId == cityId);
    if (index >= 0) {
      final contentPosition =
          (contentKey.currentContext?.findRenderObject() as RenderBox?)
              ?.localToGlobal(Offset.zero) ??
              Offset.zero;
      final offset = scrollController?.offset ?? 0;
      final itemPosition = Offset(0, index * (98.w + 12.w) + 72.w - offset + contentPosition.dy);
      Log.e("itemPosition = $itemPosition offset = $offset index = $index dy = ${contentPosition.dy}");
      return itemPosition;
    }
    return null;
  }

  @override
  void setScrollController(ScrollController? scrollController) {
    super.setScrollController(scrollController);
    scrollController?.addListener(() {
      final percent = (scrollController.offset / 72.w).fixPercent();
      provider.changeAlpha(context, percent);
    });
  }

  @override
  Widget getRoot(CityManagerProvider provider) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: MyAppBar(
        needOverlayStyle: false,
        centerTitle: "城市管理",
        titleColor: provider.titleColor,
        backgroundColor: context.backgroundColor,
        rightIcon1: "ic_search_home",
        onRightIcon1Pressed: () {
          NavigatorUtils.push(context, AppRouter.selectCityPage);
        },
      ),
      body: ListViewObserver(
        onObserve: (resultModel) {
          _displayingChildIndexList = resultModel.displayingChildIndexList;
          Log.e("_displayingChildIndexList = $_displayingChildIndexList");
        },
        child: super.getRoot(provider),
      ),
    );
  }

  @override
  Widget getRefreshContent(CityManagerProvider provider) {
    final mainP = context.read<MainProvider>();
    return ValueListenableBuilder(
      valueListenable: mainP.cityDataBox.listenable(),
      builder: (context, cityDataBox, child) {
        if (mounted && _displayingChildIndexList.isEmpty) {
          Commons.post((_) {
            final contentHeight = contentKey.currentContext?.size?.height ?? 0;
            final count = ((contentHeight - 72.w) / (98.w + 12.w)).ceil();
            _displayingChildIndexList = List.generate(count, (index) => index);
            Log.e("_displayingChildIndexList = $_displayingChildIndexList");
          });
        }
        return SliverList.separated(
          itemBuilder: (context, index) {
            return AnimatedListItem(
              index: index,
              length: cityDataBox.length,
              aniController: _animationController,
              startIndex: _animStartIndex,
              endIndex: _animEndIndex,
              child: buildItem(context, index, provider),
            );
          },
          separatorBuilder: (context, index) {
            return buildItemDecoration(context, index);
          },
          itemCount: cityDataBox.length,
        );
      },
    );
  }

  @override
  Widget getHeader(CityManagerProvider provider) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            height: 72.w,
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 20.w, top: 12.w),
            child: Text(
              "城市管理",
              style: TextStyle(
                fontSize: 28.sp,
                color: provider.largeTitleColor,
              ),
            ),
          ),
        ),
        const HeaderLocator.sliver(),
      ],
    );
  }

  @override
  Widget buildItem(BuildContext context, int index,
      CityManagerProvider provider) {
    return CityManagerItem(
      key: GlobalKey(),
      index: index,
      onTap: widget.hideCityManagerPage,
    );
  }

  @override
  Widget buildItemDecoration(context, index) {
    return Gaps.generateGap(height: 12.w);
  }

  @override
  Widget getFooter(CityManagerProvider provider) {
    return SliverToBoxAdapter(
      child: Gaps.generateGap(height: 12.w),
    );
  }

  @override
  CityManagerProvider get baseProvider => provider;

  @override
  PowerPresenter createPresenter() {
    return PowerPresenter<dynamic>(this);
  }

  @override
  CityManagerProvider generateProvider() => CityManagerProvider();
}
