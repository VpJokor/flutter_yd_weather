import 'package:flutter/cupertino.dart';
import 'package:sp_util/sp_util.dart';

import '../config/constants.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? get locale {
    final String locale = SpUtil.getString(Constants.locale) ?? '';
    switch (locale) {
      case 'zh':
        return const Locale('zh', 'CN');
      case 'en':
        return const Locale('en', 'US');
      default:
        return null;
    }
  }

  void setLocale(String locale) {
    SpUtil.putString(Constants.locale, locale);
    notifyListeners();
  }
}
