import 'base_page.dart';
import 'base_page_presenter.dart';
import 'base_presenter.dart';

class PowerPresenter<IMvpView> extends BasePresenter {
  PowerPresenter(BasePageMixin state) {
    _state = state;
  }

  late BasePageMixin _state;
  List<BasePagePresenter> _presenters = [];

  void requestPresenter(List<BasePagePresenter> presenters) {
    _presenters = presenters;
    _presenters.forEach(_requestPresenter);
  }

  void _requestPresenter(BasePagePresenter presenter) {
    presenter.view = _state;
  }

  @override
  void deactivate() {
    _presenters.forEach(_deactivate);
  }

  void _deactivate(BasePagePresenter presenter) {
    presenter.deactivate();
  }

  @override
  void didChangeDependencies() {
    _presenters.forEach(_didChangeDependencies);
  }

  void _didChangeDependencies(BasePagePresenter presenter) {
    presenter.didChangeDependencies();
  }

  @override
  void didUpdateWidgets<W>(W oldWidget) {
    void didUpdateWidgets(BasePagePresenter presenter) {
      presenter.didUpdateWidgets<W>(oldWidget);
    }

    _presenters.forEach(didUpdateWidgets);
  }

  @override
  void dispose() {
    _presenters.forEach(_dispose);
  }

  void _dispose(BasePagePresenter presenter) {
    presenter.dispose();
  }

  @override
  void initState() {
    _presenters.forEach(_initState);
  }

  void _initState(BasePagePresenter presenter) {
    presenter.initState();
  }
}
