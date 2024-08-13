import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../mvp/base_page.dart';
import '../mvp/power_presenter.dart';
import '../widget/multiple_status_layout.dart';
import 'base_page_provider.dart';

abstract class BaseLoadingPageState<T extends StatefulWidget,
        PROVIDER extends BasePageProvider> extends State<T>
    with
        AutomaticKeepAliveClientMixin<T>,
        SingleTickerProviderStateMixin<T>,
        BasePageMixin<T, PowerPresenter<dynamic>> {
  late PROVIDER _provider;

  PROVIDER get provider => _provider;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<PROVIDER>(
      create: (_) => _provider,
      child: Consumer<PROVIDER>(builder: (_, provider, __) {
        return getRoot(provider);
      }),
    );
  }

  Widget getRoot(PROVIDER provider) {
    return MultipleStatusLayout(
      status: provider.status,
      content: getContent(provider),
      onTap: onRetry,
      title: provider.title,
    );
  }

  Widget getContent(PROVIDER provider);

  @override
  void initState() {
    _provider = generateProvider();
    super.initState();
  }

  PROVIDER generateProvider();

  void showLoading() {
    _provider.showLoading();
  }

  void hideLoading() {
    _provider.hideLoading();
  }

  @override
  void showProgress() {
    showLoading();
  }

  @override
  void closeProgress(bool success) {
    if (success) {
      hideLoading();
    } else {
      showErrorLayout(
        title: "出错啦！",
      );
    }
  }

  void showErrorLayout({
    String title = "",
  }) {
    _provider.showErrorLayout(
      title: title,
    );
  }

  void onRetry() {}

  @override
  bool get wantKeepAlive => true;
}
