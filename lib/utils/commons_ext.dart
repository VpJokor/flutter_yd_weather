import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_yd_weather/model/city_data.dart';
import 'package:flutter_yd_weather/utils/commons.dart';
import 'package:flutter_yd_weather/utils/theme_utils.dart';

import '../net/api.dart';
import '../net/net_utils.dart';

extension StringExt on String? {
  bool isNullOrEmpty() => this == null || this!.isEmpty;

  bool isNotNullOrEmpty() => !isNullOrEmpty();
}

extension IntExt on int? {
  String getTemp() {
    return this == null ? "" : "$this°";
  }
}

extension ContextExtension on BuildContext {
  SystemUiOverlayStyle get systemUiOverlayStyle =>
      isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;

  void hideKeyboard() {
    final currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus && currentFocus.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}

extension ListExt<E> on List<E>? {
  bool isNullOrEmpty() => this == null || this!.isEmpty;

  bool isNotNullOrEmpty() => !this.isNullOrEmpty();

  E? singleOrNull(bool Function(E element) test) {
    if (this == null) return null;
    E? single;
    bool found = false;
    for (var element in this!) {
      if (test(element)) {
        if (found) continue;
        single = element;
        found = true;
      }
    }
    if (!found) return null;
    return single;
  }

  E? getOrNull(int index) {
    if (this == null) return null;
    return index >= 0 && index <= this!.length - 1 ? this![index] : null;
  }
}

extension NetExt<E> on void {
  void searchCity(String searchKey, void Function(List<CityData>? result) block,
      {bool showLoading = true}) {
    if (showLoading) {
      Commons.showLoading();
    }
    final Map<String, String> params = <String, String>{};
    params["keyword"] = searchKey;
    NetUtils.instance.requestNetwork<List<CityData>>(
        Method.post, Api.searchCityApi, queryParameters: params,
        onSuccess: (data) {
      if (showLoading) {
        Commons.hideLoading();
      }
      block.call(data);
    }, onError: (msg) {
      if (showLoading) {
        Commons.hideLoading();
      }
      block.call(null);
    });
  }
}
