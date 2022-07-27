import 'dart:convert';

import 'package:latlong2/latlong.dart';
import 'package:weather_test/apis/weather_api.dart';
import 'package:http/http.dart' as http;

const String _requestPattern =
    'https://api.openweathermap.org/data/2.5/{type}?lat={lat}&lon={lon}&appid=';

//API OpenWeatherMap для получения погоды
class OpenWeatherMapApi extends WeatherApi {
  static OpenWeatherMapApi? _instance;
  final String _key;
  final String _baseRequest;

  factory OpenWeatherMapApi(String apiKey) {
    if (_instance == null || _instance?._key != apiKey) {
      _instance = OpenWeatherMapApi._internal(apiKey, _requestPattern + apiKey);
    }
    return _instance!;
  }

  OpenWeatherMapApi._internal(this._key, this._baseRequest);

//Получение погоды на настоящий момент и следующие 5 дней
  @override
  Future<List<WeatherInfo>> getTodayWeatherInfo(LatLng coords) async {
    final result = <WeatherInfo>[];
    result.add(await getCurrentWeatherInfo(coords));
    result.addAll(await getForecast(coords));
    return result;
  }

//Получение текущей погоды
  @override
  Future<WeatherInfo> getCurrentWeatherInfo(LatLng coords) async {
    final request = _baseRequest
        .replaceFirst('{type}', 'weather')
        .replaceFirst('{lat}', coords.latitude.toString())
        .replaceFirst('{lon}', coords.longitude.toString());
    final data = jsonDecode((await http.get(Uri.parse(request))).body);
    final weather = WeatherInfo(
      //Перевод температуры из кельвина в цельсии
      data['main']['temp'] - 273.15,
      data['main']['humidity'],
      //Перевод скорости ветра в тип double
      data['wind']['speed'] + 0.0,
      //Конвертация времени из Unix формата
      DateTime.fromMillisecondsSinceEpoch(data['dt'] * 1000),
    );
    return weather;
  }

//Получение прогноза погоды на 5 дней
  @override
  Future<List<WeatherInfo>> getForecast(LatLng coords) async {
    final request = _baseRequest
        .replaceFirst('{type}', 'forecast')
        .replaceFirst('{lat}', coords.latitude.toString())
        .replaceFirst('{lon}', coords.longitude.toString());
    final dataList =
        jsonDecode((await http.get(Uri.parse(request))).body)['list'] as List;
    final forecast = dataList
        .map((e) => WeatherInfo(
              e['main']['temp'] - 273.15,
              e['main']['humidity'],
              e['wind']['speed'] + 0.0,
              DateTime.fromMillisecondsSinceEpoch(e['dt'] * 1000),
            ))
        .toList();
    return forecast;
  }
}
