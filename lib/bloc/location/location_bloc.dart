import 'package:bloc/bloc.dart';
import 'package:latlong2/latlong.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<LocationChangedManually>((event, emit) {
      emit(LocationSet(event.coords, event.ruName));
    });

    on<LocationStartSetting>((event, emit) {
      emit(LocationInitial());
    });
  }
}
