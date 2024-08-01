
import 'base_page_provider.dart';

class BaseListProvider<T> extends BasePageProvider {
  final List<T> _list = <T>[];

  List<T> get list => _list;

  void add(T data) {
    _list.add(data);
    notifyListeners();
  }

  void addAll(List<T>? data) {
    _list.addAll(data ?? <T>[]);
    notifyListeners();
  }

  void replace(List<T>? data, {bool refresh = true}) {
    _list.clear();
    _list.addAll(data ?? <T>[]);
    if (refresh) {
      notifyListeners();
    }
  }

  void insert(int i, T data, {bool refresh = true}) {
    _list.insert(i, data);
    if (refresh) {
      notifyListeners();
    }
  }

  void insertAll(int i, List<T> data) {
    _list.insertAll(i, data);
    notifyListeners();
  }

  void remove(T data) {
    _list.remove(data);
    notifyListeners();
  }

  void removeAt(int i, {bool refresh = true}) {
    _list.removeAt(i);
    if (refresh) {
      notifyListeners();
    }
  }

  void clear() {
    _list.clear();
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }
}
