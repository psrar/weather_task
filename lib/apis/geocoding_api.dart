import 'package:latlong2/latlong.dart';

abstract class GeocodingApi {
  Future<String> getRuNameFromLatLng(LatLng coords);
}
