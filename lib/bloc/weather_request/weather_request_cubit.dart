import 'package:bloc/bloc.dart';

//Состояния загрузки погоды для отображения загрузочного экрана
enum WeatherRequestState { empty, loading, loaded }

class WeatherRequestCubit extends Cubit<WeatherRequestState> {
  WeatherRequestCubit() : super(WeatherRequestState.empty);

  void changeState(WeatherRequestState state) => emit(state);
}
