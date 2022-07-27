import 'package:latlong2/latlong.dart';

//Приложение опирается на абстрактный класс, чтобы API можно было легко подменить
abstract class WeatherApi {
  Future<List<WeatherInfo>> getTodayWeatherInfo(LatLng coords);
  Future<WeatherInfo> getCurrentWeatherInfo(LatLng coords);
  Future<List<WeatherInfo>> getForecast(LatLng coords);
}

//Модель погоды на конкретное время
class WeatherInfo {
  final DateTime timeStamp;
  final double temperature;
  final int humidity;
  final double windspeed;

  const WeatherInfo(
      this.temperature, this.humidity, this.windspeed, this.timeStamp);
}
