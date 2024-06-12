import '../../base/base_list_provider.dart';
import '../../mvp/mvps.dart';

abstract class BaseListView<ITEM> implements IMvpView {
  BaseListProvider<ITEM> get baseProvider;
}
