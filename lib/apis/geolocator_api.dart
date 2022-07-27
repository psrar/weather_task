import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

//Получение геолокации
Future<LatLng> getCurrentPosition() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw 'Пользователь не предоставил доступ к местоположению';
    }
  }

  final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low);
  return LatLng(pos.latitude, pos.longitude);
}
