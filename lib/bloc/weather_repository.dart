import 'package:weather_test/apis/weather_api.dart';

class WeatherRepository {
  static final _instance = WeatherRepository._internal();
  final forecast = <WeatherInfo>[];

  factory WeatherRepository() => _instance;

  WeatherRepository._internal();

  int lastUpdateInMinutes() {
    return _instance.forecast.first.timeStamp
        .difference(DateTime.now())
        .inMinutes;
  }

  void rewrite(List<WeatherInfo> newForecast) {
    forecast.clear();
    forecast.addAll(newForecast);
  }

  List<WeatherInfo> forecastForFewHours(int hours) {
    final now = DateTime.now();
    return forecast.where((element) {
      return element.timeStamp.difference(now).inHours <= hours;
    }).toList();
  }
}
