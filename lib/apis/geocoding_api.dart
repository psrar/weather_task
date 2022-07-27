import 'package:latlong2/latlong.dart';

//Приложение опирается на абстрактный класс, чтобы API для получения названия места можно было легко подменить
abstract class GeocodingApi {
  Future<String> getRuNameFromLatLng(LatLng coords);
}
