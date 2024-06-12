import 'package:flutter/cupertino.dart';
import '../../mvp/mvps.dart';

abstract class BaseView<PROVIDER extends ChangeNotifier> implements IMvpView {
  PROVIDER get baseProvider;
}
