import 'package:bloc/bloc.dart';

enum WeatherRequestState { empty, loading, loaded }

class WeatherRequestCubit extends Cubit<WeatherRequestState> {
  WeatherRequestCubit() : super(WeatherRequestState.empty);

  void changeState(WeatherRequestState state) => emit(state);
}
