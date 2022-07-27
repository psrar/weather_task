import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:weather_test/apis/geocoding_api.dart';

const String _requestPattern =
    'http://api.openweathermap.org/geo/1.0/reverse?lat={lat}&lon={lon}&appid=';

class OpenWeatherMapGeocodingApi extends GeocodingApi {
  static OpenWeatherMapGeocodingApi? _instance;
  final String _key;
  final String _baseRequest;

  factory OpenWeatherMapGeocodingApi(String apiKey) {
    if (_instance == null || _instance?._key != apiKey) {
      _instance = _instance = OpenWeatherMapGeocodingApi._internal(
          apiKey, _requestPattern + apiKey);
    }

    return _instance!;
  }

  OpenWeatherMapGeocodingApi._internal(this._key, this._baseRequest);

  @override
  Future<String> getRuNameFromLatLng(LatLng coords) async {
    final request = _baseRequest
        .replaceFirst('{lat}', coords.latitude.toString())
        .replaceFirst('{lon}', coords.longitude.toString());
    final response = jsonDecode((await http.get(Uri.parse(request))).body)[0];
    return response['local_names']?['ru'] ?? response['name'] as String;
  }
}
