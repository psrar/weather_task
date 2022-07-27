import 'package:weather_test/apis/weather_api.dart';

//Репозиторий для предоставления информации о полученной
//погоде приложению
class WeatherRepository {
  static final _instance = WeatherRepository._internal();
  final forecast = <WeatherInfo>[];

  factory WeatherRepository() => _instance;

  WeatherRepository._internal();

//Перезапись информации о полученной погоде
  void rewrite(List<WeatherInfo> newForecast) {
    forecast.clear();
    forecast.addAll(newForecast);
  }

//Выборка информации о погоде на следующие hours часов
//OpenWeatherApi возвращает прогноз с интервалом в 3 часа
  List<WeatherInfo> forecastForFewHours(int hours) {
    final now = DateTime.now();
    return forecast.where((element) {
      return element.timeStamp.difference(now).inHours <= hours;
    }).toList();
  }

//Возвращает прогноз погоды, разбитый по дням
  List<List<WeatherInfo>> forecastForWeek() {
    int day = forecast.first.timeStamp.day;
    int index = 0;
    final result = <List<WeatherInfo>>[[]];
    for (var f in forecast) {
      if (f.timeStamp.day == day) {
        result[index].add(f);
      } else {
        result.add([f]);
        day = f.timeStamp.day;
        index++;
      }
    }
    return result;
  }
}
