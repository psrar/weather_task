part of 'location_bloc.dart';

@immutable
abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationSet extends LocationState {
  final LatLng coords;
  final String ruName;

  LocationSet(this.coords, this.ruName);
}
