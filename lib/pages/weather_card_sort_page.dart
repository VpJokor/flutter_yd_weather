import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/provider/main_provider.dart';
import 'package:flutter_yd_weather/utils/commons.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import 'package:flutter_yd_weather/utils/theme_utils.dart';
import 'package:flutter_yd_weather/utils/toast_utils.dart';
import 'package:flutter_yd_weather/widget/my_app_bar.dart';
import 'package:flutter_yd_weather/widget/opacity_layout.dart';
import 'package:flutter_yd_weather/widget/weather_observe_card_sort_item.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

import '../res/colours.dart';
import '../res/gaps.dart';
import '../widget/load_asset_image.dart';
import '../widget/weather_card_sort_item.dart';
import '../widget/yd_reorderable_list.dart';

class WeatherCardSortPage extends StatefulWidget {
  const WeatherCardSortPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _WeatherCardSortPageState();
}

class _WeatherCardSortPageState extends State<WeatherCardSortPage> {
  late ScrollController _scrollController;
  List<int> _currentWeatherCardSort = [];
  List<int> _currentWeatherObserveCardSort = [];
  bool _rightAction1Enabled = true;
  bool _isBackEnabled = true;
  Duration _duration = Duration.zero;
  double _marginTop = 0;
  double _tempMarginTop = 0;
  double _opacity = 1;
  double _opacity1 = 0;
  bool _isShowWeatherObserveCardSort = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    final mainP = context.read<MainProvider>();
    _currentWeatherCardSort = mainP.currentWeatherCardSort
        .where((e) => e != Constants.itemTypeWeatherHeader)
        .toList();
    _currentWeatherObserveCardSort = mainP.currentWeatherObservesCardSort;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: MyAppBar(
        backgroundColor: context.backgroundColor,
        backImg: "ic_close_icon1",
        isBackEnabled: _isBackEnabled,
        centerTitle: "卡片排序",
        titleColor: context.black,
        rightAction1: "恢复默认",
        rightAction1Enabled: _rightAction1Enabled,
        onRightAction1Pressed: () {
          final currentWeatherCardSort = [Constants.itemTypeWeatherHeader];
          currentWeatherCardSort.addAll(_currentWeatherCardSort);
          if (compareCurrentWeatherCardSort(currentWeatherCardSort) ||
              compareCurrentWeatherObserverCardSort(
                  _currentWeatherObserveCardSort)) {
            debugPrint("恢复默认");
            final mainP = context.read<MainProvider>();
            final defaultWeatherCardSort = Constants.defaultWeatherCardSort
                .map((e) => int.parse(e))
                .toList();
            final currentWeatherObserveCardSort = Constants
                .defaultWeatherObservesCardSort
                .map((e) => int.parse(e))
                .toList();
            mainP.currentWeatherCardSort = defaultWeatherCardSort;
            mainP.currentWeatherObservesCardSort =
                currentWeatherObserveCardSort;
            Toast.show("已恢复默认");
            setState(() {
              _currentWeatherCardSort = defaultWeatherCardSort
                  .where((e) => e != Constants.itemTypeWeatherHeader)
                  .toList();
              _currentWeatherObserveCardSort = currentWeatherObserveCardSort;
            });
          }
        },
      ),
      body: EasyRefresh.builder(
        scrollController: _scrollController,
        notRefreshHeader: const NotRefreshHeader(
          position: IndicatorPosition.locator,
          hitOver: true,
        ),
        childBuilder: (context, physics) {
          return Stack(
            children: [
              AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 200),
                child: YdReorderableList(
                  onReorderStart: _reorderStart,
                  onReorder: _reorderCallback,
                  onReorderDone: _reorderDone,
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: physics,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          height: 42.w,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 16.w),
                          child: Text(
                            "首页的天气卡片将会按照以下排序进行展示",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colours.color999999,
                            ),
                          ),
                        ),
                      ),
                      SliverList.separated(
                        itemBuilder: (context, index) {
                          return WeatherCardSortItem(
                            weatherCardItemType: _currentWeatherCardSort[index],
                            weatherObserveSortTap: () {
                              setState(() {
                                _opacity = 0;
                                _isShowWeatherObserveCardSort = true;
                                _duration = Duration.zero;
                                _marginTop = index * (48.w + 12.w);
                                _tempMarginTop = _marginTop;
                                Commons.post((_) {
                                  setState(() {
                                    _duration =
                                        const Duration(milliseconds: 200);
                                    _marginTop = 0;
                                    _opacity1 = 1;
                                  });
                                });
                              });
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Gaps.generateGap(height: 12.w);
                        },
                        itemCount: _currentWeatherCardSort.length,
                      ),
                    ],
                  ),
                ),
              ),
              Offstage(
                offstage: !_isShowWeatherObserveCardSort,
                child: _weatherObserveCardSortContent(physics),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _weatherObserveCardSortContent(ScrollPhysics? physics) {
    return AnimatedOpacity(
      opacity: 1 - _opacity,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: context.backgroundColor,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: physics,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 42.w,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 16.w),
                child: Text(
                  "专业数据卡片将会按照以下排序进行展示",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colours.color999999,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: _duration,
                margin:
                    EdgeInsets.only(left: 16.w, top: _marginTop, right: 16.w),
                width: double.infinity,
                height: 48.w,
                padding: EdgeInsets.only(left: 16.w, right: 8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.w),
                  color: context.cardColor06,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            "专业数据",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: context.black,
                              height: 1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8.w),
                            child: LoadAssetImage(
                              "ic_sort_icon",
                              width: 18.w,
                              height: 18.w,
                              color: Colours.color999999,
                            ),
                          ),
                        ],
                      ),
                    ),
                    OpacityLayout(
                      child: Container(
                        height: double.infinity,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: LoadAssetImage(
                          "ic_close_icon1",
                          width: 18.w,
                          height: 18.w,
                          color: Colours.color999999,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _opacity1 = 0;
                          _duration = const Duration(milliseconds: 200);
                          _marginTop = _tempMarginTop;
                          Commons.postDelayed(delayMilliseconds: 200, () {
                            setState(() {
                              _opacity = 1;
                              Commons.postDelayed(delayMilliseconds: 200, () {
                                setState(() {
                                  _isShowWeatherObserveCardSort = false;
                                });
                              });
                            });
                          });
                        });
                      },
                    ),
                  ],
                ),
              ),
              AnimatedOpacity(
                opacity: _opacity1,
                duration: const Duration(milliseconds: 200),
                child: ReorderableWrap(
                  spacing: 12.w,
                  runSpacing: 12.w,
                  padding: EdgeInsets.all(16.w),
                  onReorder: _onReorder,
                  onNoReorder: (_) {
                    setState(() {
                      _isBackEnabled = true;
                      _rightAction1Enabled = true;
                    });
                  },
                  onReorderStarted: (_) {
                    setState(() {
                      _isBackEnabled = false;
                      _rightAction1Enabled = false;
                    });
                  },
                  children: _currentWeatherObserveCardSort
                      .mapIndexed((itemType, index) {
                    return WeatherObserveCardSortItem(
                      itemType: itemType,
                      index: index,
                    );
                  }),
                  buildDraggableFeedback: (_, __, child) {
                    return child;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      _isBackEnabled = true;
      _rightAction1Enabled = true;
      final item = _currentWeatherObserveCardSort.removeAt(oldIndex);
      _currentWeatherObserveCardSort.insert(newIndex, item);
    });
    final mainP = context.read<MainProvider>();
    mainP.currentWeatherObservesCardSort = _currentWeatherObserveCardSort;
  }

  bool compareCurrentWeatherCardSort(List<int> currentWeatherCardSort) {
    if (currentWeatherCardSort.length !=
        Constants.defaultWeatherCardSort.length) {
      return false;
    }
    for (int i = 0; i < currentWeatherCardSort.length; i++) {
      if (Constants.defaultWeatherCardSort[i] !=
          currentWeatherCardSort[i].toString()) {
        return true;
      }
    }
    return false;
  }

  bool compareCurrentWeatherObserverCardSort(
      List<int> currentWeatherObserverCardSort) {
    if (currentWeatherObserverCardSort.length !=
        Constants.defaultWeatherObservesCardSort.length) {
      return false;
    }
    for (int i = 0; i < currentWeatherObserverCardSort.length; i++) {
      if (Constants.defaultWeatherObservesCardSort[i] !=
          currentWeatherObserverCardSort[i].toString()) {
        return true;
      }
    }
    return false;
  }

  void _reorderStart() {
    setState(() {
      _isBackEnabled = false;
      _rightAction1Enabled = false;
    });
  }

  int _indexOfKey(Key key) {
    return _currentWeatherCardSort
        .indexWhere((element) => (key as ValueKey<int>).value == element);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);
    final draggedItem = _currentWeatherCardSort[draggingIndex];
    setState(() {
      _currentWeatherCardSort.removeAt(draggingIndex);
      _currentWeatherCardSort.insert(newPositionIndex, draggedItem);
    });
    return true;
  }

  void _reorderDone(Key item) {
    setState(() {
      _isBackEnabled = true;
      _rightAction1Enabled = true;
    });
    final mainP = context.read<MainProvider>();
    final currentWeatherCardSort = [Constants.itemTypeWeatherHeader];
    currentWeatherCardSort.addAll(_currentWeatherCardSort);
    mainP.currentWeatherCardSort = currentWeatherCardSort;
  }
}
