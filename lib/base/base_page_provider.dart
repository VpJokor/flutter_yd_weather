import 'package:flutter/material.dart';
import '../../widget/multiple_status_layout.dart';

class BasePageProvider with ChangeNotifier {
  int _status = LoadStatus.loading;

  int get status => _status;
  String title = "";

  void showLoading() {
    _status = LoadStatus.loading;
    notifyListeners();
  }

  void hideLoading() {
    _status = LoadStatus.success;
    notifyListeners();
  }

  void showErrorLayout({
    String title = "",
  }) {
    _status = LoadStatus.error;
    this.title = title;
    notifyListeners();
  }
}
