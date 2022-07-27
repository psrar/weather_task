import 'package:weather_test/apis/geocoding_api.dart';
import 'package:weather_test/apis/weather_api.dart';

//Приложение получает доступ к WeatherApi через этот репозиторий
//Это позволяет подменять провайдеров Api, не меняя код приложения
class WeatherApiRepository {
  static WeatherApiRepository? _instance;
  final WeatherApi weatherApi;

  factory WeatherApiRepository(WeatherApi weatherApi) {
    if (_instance?.weatherApi != weatherApi) {
      _instance = WeatherApiRepository._fromApi(weatherApi);
    }
    return _instance!;
  }

  WeatherApiRepository._fromApi(this.weatherApi);
}
