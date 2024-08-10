import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yd_weather/config/constants.dart';
import 'package:flutter_yd_weather/provider/main_provider.dart';
import 'package:flutter_yd_weather/utils/theme_utils.dart';
import 'package:flutter_yd_weather/widget/my_app_bar.dart';
import 'package:provider/provider.dart';

import '../res/colours.dart';
import '../res/gaps.dart';
import '../widget/weather_card_sort_item.dart';
import '../widget/yd_reorderable_list.dart';

class WeatherCardSortPage extends StatefulWidget {
  const WeatherCardSortPage({super.key});

  @override
  State<StatefulWidget> createState() => _WeatherCardSortPageState();
}

class _WeatherCardSortPageState extends State<WeatherCardSortPage> {
  late ScrollController _scrollController;
  List<int> _currentWeatherCardSort = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    final mainP = context.read<MainProvider>();
    _currentWeatherCardSort = mainP.currentWeatherCardSort
        .where((e) => e != Constants.itemTypeWeatherHeader)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: MyAppBar(
        backgroundColor: context.backgroundColor,
        backImg: "ic_close_icon1",
        centerTitle: "卡片排序",
        titleColor: context.black,
        rightAction1: "恢复默认",
        onRightAction1Pressed: () {},
      ),
      body: Stack(
        children: [
          YdReorderableList(
            onReorderStart: _reorderStart,
            onReorder: _reorderCallback,
            onReorderDone: _reorderDone,
            child: EasyRefresh.builder(
              scrollController: _scrollController,
              notRefreshHeader: const NotRefreshHeader(
                position: IndicatorPosition.locator,
                hitOver: true,
              ),
              childBuilder: (context, physics) {
                return CustomScrollView(
                  controller: _scrollController,
                  physics: physics,
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.only(
                        left: 16.w,
                        top: 12.w,
                        bottom: 12.w,
                      ),
                      sliver: SliverToBoxAdapter(
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
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Gaps.generateGap(height: 12.w);
                      },
                      itemCount: _currentWeatherCardSort.length,
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _reorderStart() {}

  int _indexOfKey(Key key) {
    return _currentWeatherCardSort.indexWhere((element) => (key as ValueKey<int>).value == element);
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

  void _reorderDone(Key item) {}
}
