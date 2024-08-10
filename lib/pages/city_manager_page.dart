import 'package:animated_visibility/animated_visibility.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_yd_weather/base/base_list_view.dart';
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
import 'package:flutter_yd_weather/widget/opacity_layout.dart';
import 'package:provider/provider.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:sp_util/sp_util.dart';

import '../base/base_list_page.dart';
import '../config/constants.dart';
import '../main.dart';
import '../res/colours.dart';
import '../res/gaps.dart';
import '../widget/animated_list_item.dart';
import '../widget/load_asset_image.dart';
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

class CityManagerPageState extends BaseListPageState<
    CityManagerPage,
    CityManagerData,
    CityManagerProvider> implements BaseListView<CityManagerData> {
  late AnimationController _animationController;
  int _animStartIndex = 0;
  int _animEndIndex = 0;
  List<int> _displayingChildIndexList = [];
  final _deleteButtonEnable = ValueNotifier<bool>(true);

  @override
  NotRefreshHeader? get notRefreshHeader => const NotRefreshHeader(
        position: IndicatorPosition.locator,
        hitOver: true,
      );

  bool get isEditMode => provider.isEditMode;

  void closeEditMode() {
    provider.isEditMode = false;
  }

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
      provider.hideLoading();

      final mainP = context.read<MainProvider>();
      provider.generate(mainP);
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
    for (var element in provider.list) {
      element.slidableController?.close();
    }
  }

  Offset? _findItemPosition(String cityId) {
    final index = provider.list
        .indexWhere((element) => element.cityData?.cityId == cityId);
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
  Widget getRoot(CityManagerProvider provider) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: MyAppBar(
        needOverlayStyle: false,
        backImg: provider.isEditMode ? "ic_close_icon1" : "ic_close_icon",
        centerText: AnimatedBuilder(
          animation: scrollController!,
          builder: (_, __) {
            final positions = scrollController?.positions;
            double percent = 0;
            if (positions != null && positions.isNotEmpty) {
              final offset = scrollController?.offset ?? 0;
              percent = (offset / 72.w).fixPercent();
            }
            return AnimatedOpacity(
              opacity: percent,
              duration: Duration.zero,
              child: Text(
                _title,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: context.black,
                ),
              ),
            );
          },
        ),
        backgroundColor: context.backgroundColor,
        rightIcon1:
            provider.isEditMode ? "ic_select_all_icon" : "ic_search_icon",
        rightIconColor: provider.isEditMode
            ? (provider.isSelectedAll ? Colours.appMain : null)
            : null,
        onRightIcon1Pressed: () {
          if (provider.isEditMode) {
            if (provider.isSelectedAll) {
              provider.clearSelected();
            } else {
              provider.selectedAll();
            }
          } else {
            NavigatorUtils.push(context, AppRouter.selectCityPage);
          }
        },
      ),
      body: Stack(
        children: [
          ListViewObserver(
            onObserve: (resultModel) {
              _displayingChildIndexList = resultModel.displayingChildIndexList;
              Log.e("_displayingChildIndexList = $_displayingChildIndexList");
            },
            child: SlidableAutoCloseBehavior(
              child: YdReorderableList(
                onReorderStart: _reorderStart,
                onReorder: _reorderCallback,
                onReorderDone: _reorderDone,
                child: super.getRoot(provider),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ValueListenableBuilder<bool>(
              valueListenable: _deleteButtonEnable,
              builder: (_, value, ___) {
                return AnimatedVisibility(
                  visible: provider.isEditMode,
                  enter: slideInVertically(),
                  exit: slideOutVertically(),
                  enterDuration: const Duration(milliseconds: 200),
                  exitDuration: const Duration(milliseconds: 200),
                  child: SafeArea(
                    child: Container(
                      width: double.infinity,
                      height: 54.w,
                      alignment: Alignment.center,
                      color: context.backgroundColor,
                      child: AnimatedOpacity(
                        opacity:
                            provider.selectedList.isEmpty || !value ? 0.3 : 1,
                        duration: Duration.zero,
                        child: OpacityLayout(
                          onPressed: provider.selectedList.isEmpty || !value
                              ? null
                              : () {
                                  _removeItems(provider.selectedList);
                                },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LoadAssetImage(
                                "ic_delete_icon",
                                width: 20.w,
                                height: 20.w,
                                color: context.black,
                              ),
                              Gaps.generateGap(height: 4.w),
                              Text(
                                "删除",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: context.black,
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String get _title => provider.isEditMode
      ? (provider.selectedList.isEmpty
          ? "请选择项目"
          : "已选择${provider.selectedList.length}项")
      : "城市管理";

  int _indexOfKey(Key key) {
    return provider.list.indexWhere((element) => element.key == key);
  }

  void _reorderStart() {
    _deleteButtonEnable.value = false;
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

  void _reorderDone(Key item) {
    _deleteButtonEnable.value = true;
    final currentCityIdList = provider.list
        .map((e) => e.cityData?.isLocationCity == true
            ? Constants.locationCityId
            : e.cityData?.cityId ?? "")
        .toList();
    SpUtil.putStringList(Constants.currentCityIdList, currentCityIdList);
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
          child: AnimatedBuilder(
            animation: scrollController!,
            builder: (_, __) {
              final offset = scrollController?.offset ?? 0;
              final percent = (offset / 72.w).fixPercent();
              return AnimatedOpacity(
                opacity: 1 - percent,
                duration: Duration.zero,
                child: Container(
                  height: 72.w,
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 20.w, top: 12.w),
                  child: Text(
                    _title,
                    style: TextStyle(
                      fontSize: 28.sp,
                      color: context.black,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const HeaderLocator.sliver(),
      ],
    );
  }

  @override
  Widget buildItem(
      BuildContext context, int index, CityManagerProvider provider) {
    final data = provider.list[index];
    final isSelected =
        provider.isEditMode ? provider.selectedList.contains(data) : false;
    return CityManagerItem(
      cityManagerData: data,
      isEditMode: provider.isEditMode,
      isSelected: isSelected,
      onTap: () {
        if (provider.isEditMode) {
          provider.selected(data);
        } else {
          widget.hideCityManagerPage?.call();
        }
      },
      toEditMode: _toEditMode,
      removeItem: _removeItem,
    );
  }

  void _toEditMode(CityManagerData? data) {
    if (provider.isEditMode) return;
    if (provider.list.length <= 1) return;
    provider.isEditMode = true;
    if (data != null) {
      provider.selected(data);
    }
  }

  void refresh(bool isAdd) {
    final mainP = context.read<MainProvider>();
    if (isAdd) {
      provider.add(CityManagerData(
          ValueKey("${provider.list.length}-${mainP.currentCityData?.cityId}"),
          mainP.currentCityData));
      Commons.post((_) {
        final contentHeight = contentKey.currentContext?.size?.height ?? 0;
        final count = ((contentHeight - 72.w) / (98.w + 12.w)).ceil();
        animateScrollToBottom(offset: provider.list.length > count ? 98.w : 0, milliseconds: 200);
      });
    } else {
      provider.list.forEachIndexed((e, index) {
        if (e.cityData == mainP.currentCityData) {
          e.cityData = mainP.currentCityData;
          provider.set(index, e, refresh: false);
        }
      });
      provider.refresh();
    }
  }

  void _removeItem(CityManagerData item) {
    final cityData = item.cityData;
    if (cityData == null) return;
    final mainP = context.read<MainProvider>();
    mainP.cityDataBox.delete(cityData.cityId).then((_) {
      final currentCityIdList =
          SpUtil.getStringList(Constants.currentCityIdList, defValue: []) ?? [];
      currentCityIdList.remove(cityData.cityId);
      SpUtil.putStringList(Constants.currentCityIdList, currentCityIdList);
      item.removed = true;
      provider.refresh();
      Commons.postDelayed(delayMilliseconds: 200, () {
        provider.remove(item);
        _afterRemove(mainP, mainP.currentCityData == item.cityData);
      });
    });
  }

  void _removeItems(List<CityManagerData> items) {
    final mainP = context.read<MainProvider>();
    final removeKeys = items.map((item) => item.cityData?.cityId);
    mainP.cityDataBox.deleteAll(removeKeys).then((_) {
      bool resetCurrentCityData = false;
      final currentCityIdList =
          SpUtil.getStringList(Constants.currentCityIdList, defValue: []) ?? [];
      for (var item in items) {
        if (!resetCurrentCityData) {
          resetCurrentCityData = mainP.currentCityData == item.cityData;
        }
        currentCityIdList.remove(item.cityData?.cityId);
        provider.list.singleOrNull((e) => e == item)?.removed = true;
      }
      SpUtil.putStringList(Constants.currentCityIdList, currentCityIdList);
      provider.refresh();
      Commons.postDelayed(delayMilliseconds: 200, () {
        provider.removeWhere((item) => items.contains(item), refresh: false);
        provider.isEditMode = false;
        _afterRemove(mainP, resetCurrentCityData);
      });
    });
  }

  void _afterRemove(MainProvider mainP, bool resetCurrentCityData) {
    if (provider.list.isEmpty) {
      SpUtil.putString(Constants.currentCityId, "");
      NavigatorUtils.push(
        context,
        AppRouter.selectCityPage,
        transition: TransitionType.fadeIn,
        replace: true,
      );
    } else {
      if (resetCurrentCityData) {
        mainP.currentCityData = provider.list.first.cityData;
        eventBus.fire(RefreshWeatherDataEvent());
      }
    }
  }

  @override
  Widget buildItemDecoration(context, index) {
    return Gaps.generateGap(height: 12.w);
  }

  @override
  Widget getFooter(CityManagerProvider provider) {
    return SliverToBoxAdapter(
      child: Gaps.generateGap(height: 12.w + (provider.isEditMode ? 54.w : 0)),
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
