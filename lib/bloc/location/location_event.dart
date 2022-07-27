part of 'location_bloc.dart';

@immutable
abstract class LocationEvent {}

class LocationChangedManually extends LocationEvent {
  final LatLng coords;
  final String ruName;

  LocationChangedManually(this.coords, this.ruName);
}
