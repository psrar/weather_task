import 'package:latlong2/latlong.dart';

abstract class WeatherApi {
  Future<WeatherInfo> getCurrentWeatherInfo(LatLng coords);
  Future<List<WeatherInfo>> getForecast(LatLng coords);
}

class WeatherInfo {
  final DateTime timeStamp;
  final double temperature;
  final int humidity;
  final double windspeed;

  const WeatherInfo(
      this.temperature, this.humidity, this.windspeed, this.timeStamp);
}
