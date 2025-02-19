import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_yd_weather/utils/commons_ext.dart';
import '../res/gaps.dart';
import '../utils/log.dart';
import 'base_list_provider.dart';
import 'base_loading_page.dart';

abstract class BaseListPageState<T extends StatefulWidget, ITEM,
        PROVIDER extends BaseListProvider<ITEM>>
    extends BaseLoadingPageState<T, PROVIDER> {
  late EasyRefreshController _controller;
  ScrollController? _scrollController;

  ScrollController? get scrollController => _scrollController;

  final _contentKey = GlobalKey();

  GlobalKey get contentKey => _contentKey;

  // 是否开启刷新
  bool _enableRefresh = true;

  // 是否开启加载
  bool _enableLoad = true;

  Color? _bgColor;

  set bgColor(Color bgColor) {
    _bgColor = bgColor;
  }

  @override
  void initState() {
    super.initState();
    Log.e("initState $this");
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    setScrollController(ScrollController());
  }

  void setScrollController(ScrollController? scrollController) {
    _scrollController = scrollController;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _scrollController?.dispose();
  }

  @override
  Widget getContent(PROVIDER provider) {
    Widget? header = getHeader(provider);
    final refreshContent = getRefreshContent(provider);
    final refreshGroup = getRefreshGroup(provider);
    Widget? footer = getFooter(provider);
    final slivers = <Widget>[];
    if (header != null) {
      slivers.add(header);
    }
    if (refreshGroup.isNotEmpty) {
      slivers.addAll(refreshGroup);
    } else {
      slivers.add(refreshContent);
    }
    if (footer != null) {
      slivers.add(footer);
    }
    return LayoutBuilder(builder: (_, constraints) {
      return Container(
        key: _contentKey,
        color: _bgColor,
        child: EasyRefresh.builder(
          controller: _controller,
          scrollController: _scrollController,
          notRefreshHeader: notRefreshHeader,
          onRefresh: _enableRefresh
              ? () async {
                  onRefresh();
                }
              : null,
          onLoad: _enableLoad
              ? () async {
                  onLoad();
                }
              : null,
          childBuilder: (context, physics) {
            return CustomScrollView(
              controller: _scrollController,
              anchor: getAnchor(provider, constraints.maxHeight),
              physics: physics,
              slivers: slivers,
            );
          },
        ),
      );
    });
  }

  NotRefreshHeader? notRefreshHeader;

  void finishRefresh() {
    _controller.finishRefresh();
    _controller.resetFooter();
  }

  void finishLoad({IndicatorResult result = IndicatorResult.success}) {
    _controller.finishLoad(result);
  }

  @override
  void showProgress() {
    if (provider.list.isEmpty) {
      super.showProgress();
    }
  }

  @override
  void closeProgress(bool success) {
    if (success) {
      super.closeProgress(success);
    } else {
      if (provider.list.isEmpty) {
        super.closeProgress(success);
      }
    }
  }

  @override
  void handleData(bool hasData, bool isRefresh,
      {String icon = "",
      String title = "",
      String subTitle = "",
      String actionText = ""}) {
    if (isRefresh) {
      finishRefresh();
    } else {
      finishLoad(
          result: hasData ? IndicatorResult.success : IndicatorResult.noMore);
    }
    if (!hasData && provider.list.isNullOrEmpty()) {
      showErrorLayout(
        title: title,
      );
    }
  }

  Widget getRefreshContent(PROVIDER provider) {
    return SliverList.separated(
        itemBuilder: (context, index) {
          return buildItem(context, index, provider);
        },
        separatorBuilder: (context, index) {
          return buildItemDecoration(context, index);
        },
        itemCount: provider.list.length);
  }

  List<Widget> getRefreshGroup(PROVIDER provider) => <Widget>[];

  Widget? getHeader(PROVIDER provider) => null;

  Widget? getFooter(PROVIDER provider) => null;

  double getAnchor(PROVIDER provider, double contentHeight) => 0.0;

  Widget buildItem(BuildContext context, int index, PROVIDER provider);

  Widget buildItemDecoration(context, index) => Gaps.empty;

  void setEnableRefresh(bool enableRefresh) {
    setState(() {
      _enableRefresh = enableRefresh;
    });
  }

  void setEnableLoad(bool enableLoad) {
    setState(() {
      _enableLoad = enableLoad;
    });
  }

  void onRefresh() {
    Log.e("onRefresh");
  }

  void onLoad() {
    Log.e("onLoad");
  }

  void callRefresh() {
    _controller.callRefresh();
  }

  Future<void> scrollToTop() async {
    return _scrollController?.jumpTo(0);
  }

  Future<void> animateScrollToTop({milliseconds = 600}) {
    return _scrollController?.animateTo(0,
            duration: Duration(milliseconds: milliseconds),
            curve: Curves.linear) ??
        Future.value();
  }

  Future<void> scrollToBottom() async {
    return _scrollController
        ?.jumpTo(_scrollController?.position.maxScrollExtent ?? 0);
  }

  Future<void> animateScrollToBottom({double offset = 0, milliseconds = 600}) {
    return _scrollController?.animateTo(
            (_scrollController?.position.maxScrollExtent ?? 0) + offset,
            duration: Duration(milliseconds: milliseconds),
            curve: Curves.linear) ??
        Future.value();
  }
}
