import 'package:flutter/material.dart';
import '../utils/log.dart';
import '../utils/toast_utils.dart';
import 'base_presenter.dart';
import 'mvps.dart';

mixin BasePageMixin<T extends StatefulWidget, P extends BasePresenter>
    on State<T> implements IMvpView {
  P? presenter;

  P createPresenter();

  @override
  BuildContext getContext() {
    return context;
  }

  @override
  void closeProgress(bool success) {}

  @override
  void showProgress() {}

  @override
  void handleData(
    bool hasData,
    bool isRefresh, {
    String icon = "",
    String title = "",
  }) {}

  @override
  void showToast(String string) {
    Toast.show(string);
  }

  /// 可自定义Progress
  Widget buildProgress() => const Text("buildProgress");

  @override
  void didChangeDependencies() {
    presenter?.didChangeDependencies();
    Log.e('$T ==> didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    presenter?.dispose();
    Log.e('$T ==> dispose');
    super.dispose();
  }

  @override
  void deactivate() {
    presenter?.deactivate();
    Log.e('$T ==> deactivate');
    super.deactivate();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    presenter?.didUpdateWidgets<T>(oldWidget);
    Log.e('$T ==> didUpdateWidgets');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    Log.e('$T ==> initState');
    presenter = createPresenter();
    presenter?.view = this;
    presenter?.initState();
    super.initState();
  }
}
