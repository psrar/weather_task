part of 'location_bloc.dart';

abstract class LocationEvent {}

//Событие изменения местоположения
class LocationChangedManually extends LocationEvent {
  //Координаты (широта и долгота)
  final LatLng coords;
  final String ruName;

  LocationChangedManually(this.coords, this.ruName);
}

//Вызывается при принудительном сбросе местоположения
class LocationStartSetting extends LocationEvent {}
