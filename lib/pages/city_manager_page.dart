import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_yd_weather/base/base_list_view.dart';
import 'package:flutter_yd_weather/model/city_data.dart';
import 'package:flutter_yd_weather/model/city_manager_data.dart';
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
import 'package:reorderables/reorderables.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import '../base/base_list_page.dart';
import '../res/colours.dart';
import '../res/gaps.dart';
import '../widget/animated_list_item.dart';
import '../widget/my_app_bar.dart';
import '../widget/yd_reorderable_list.dart';

class CityManagerPage extends StatefulWidget {
  const CityManagerPage({
    super.key,
    this.hideCityManagerPage,
  });

  final VoidCallback? hideCityManagerPage;

  @override
  State<CityManagerPage> createState() => CityManagerPageState();
}

class CityManagerPageState
    extends BaseListPageState<CityManagerPage, CityManagerData, CityManagerProvider>
    implements BaseListView<CityManagerData> {
  late AnimationController _animationController;
  late SlidableController _slidableController;
  int _animStartIndex = 0;
  int _animEndIndex = 0;
  List<int> _displayingChildIndexList = [];

  @override
  NotRefreshHeader? get notRefreshHeader => const NotRefreshHeader(
        position: IndicatorPosition.locator,
        hitOver: true,
      );

  @override
  void initState() {
    super.initState();
    setEnableRefresh(false);
    setEnableLoad(false);
    _slidableController = SlidableController(this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    Commons.post((_) {
      provider.largeTitleColor = context.black;
      provider.hideLoading();

      final mainP = context.read<MainProvider>();
      provider.generate(mainP);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    _slidableController.dispose();
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
    final index = provider.list.indexWhere((element) => element.cityData?.cityId == cityId);
    if (index >= 0) {
      final contentPosition =
          (contentKey.currentContext?.findRenderObject() as RenderBox?)
                  ?.localToGlobal(Offset.zero) ??
              Offset.zero;
      final offset = scrollController?.offset ?? 0;
      final itemPosition =
          Offset(0, index * (98.w + 12.w) + 72.w - offset + contentPosition.dy);
      Log.e(
          "itemPosition = $itemPosition offset = $offset index = $index dy = ${contentPosition.dy}");
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
        child: SlidableAutoCloseBehavior(
          child: YdReorderableList(
            onReorder: _reorderCallback,
            child: super.getRoot(provider),
          ),
        ),
      ),
    );
  }

  int _indexOfKey(Key key) {
    return provider.list.indexWhere((element) => element.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    final draggingIndex = _indexOfKey(item);
    final draggedItem = provider.list[draggingIndex];
    if (draggedItem.cityData?.isLocationCity ?? false) {
      return false;
    }
    final newPositionIndex = _indexOfKey(newPosition);
    provider.swap(draggingIndex, newPositionIndex, draggedItem);
    Log.e(
        "draggingIndex = $draggingIndex newPositionIndex = $newPositionIndex");
    return true;
  }

  @override
  Widget getRefreshContent(CityManagerProvider provider) {
    if (mounted && _displayingChildIndexList.isEmpty) {
      Commons.post((_) {
        final contentHeight = contentKey.currentContext?.size?.height ?? 0;
        final count = ((contentHeight - 72.w) / (98.w + 12.w)).ceil();
        _displayingChildIndexList = List.generate(count, (index) => index);
      });
    }
    Log.e("getRefreshContent");
    return SliverList.separated(
      itemBuilder: (context, index) {
        return AnimatedListItem(
          index: index,
          length: provider.list.length,
          aniController: _animationController,
          startIndex: _animStartIndex,
          endIndex: _animEndIndex,
          child: buildItem(context, index, provider),
        );
      },
      separatorBuilder: (context, index) {
        return buildItemDecoration(context, index);
      },
      itemCount: provider.list.length,
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
  Widget buildItem(
      BuildContext context, int index, CityManagerProvider provider) {
    return CityManagerItem(
      cityManagerData: provider.list[index],
      slidableController: _slidableController,
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
