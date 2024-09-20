import '../../base/base_list_view.dart';
import '../../model/weather_item_data.dart';

abstract class WeatherMainView implements BaseListView<WeatherItemData> {
  void obtainWeatherDataCallback(bool isAdd, bool reObtainWeatherData);
}