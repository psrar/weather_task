part of 'location_bloc.dart';

abstract class LocationState {}

//Если местоположение потеряно или не установлено
class LocationInitial extends LocationState {}

//Местоположение установлено
class LocationSet extends LocationState {
  //Координаты (широта и долгота)
  final LatLng coords;
  final String ruName;

  LocationSet(this.coords, this.ruName);
}
