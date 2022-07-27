import 'package:weather_test/apis/geocoding_api.dart';

//Приложение получает доступ к GeocodingApi через этот репозиторий
//Это позволяет подменять провайдеров Api, не меняя код приложения
class GeocodingApiRepository {
  static GeocodingApiRepository? _instance;
  final GeocodingApi geocodingApi;

  factory GeocodingApiRepository(GeocodingApi geocodingApi) {
    if (_instance?.geocodingApi != geocodingApi) {
      _instance = GeocodingApiRepository._fromApi(geocodingApi);
    }
    return _instance!;
  }

  GeocodingApiRepository._fromApi(this.geocodingApi);
}
