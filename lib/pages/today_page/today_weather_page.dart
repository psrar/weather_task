import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_test/apis/weather_api.dart';
import 'package:weather_test/bloc/location/location_bloc.dart';
import 'package:weather_test/bloc/weather_repository.dart';
import 'package:weather_test/bloc/weather_request/weather_request_cubit.dart';
import 'package:weather_test/pages/today_page/weather_stamp.dart';

class TodayWeatherPage extends StatelessWidget {
  const TodayWeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        if (state is! LocationSet) {
          return const Center(
            child: Text(
              'Выберите город, нажав на кнопку в верхнем углу',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          return BlocBuilder<WeatherRequestCubit, WeatherRequestState>(
            builder: (context, requestState) {
              final forecast = requestState == WeatherRequestState.loaded
                  ? RepositoryProvider.of<WeatherRepository>(context)
                      .forecastForFewHours(24)
                  : <WeatherInfo>[];

              return Column(
                children: [
                  Expanded(
                    child: Text(
                      state.ruName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: requestState == WeatherRequestState.loading
                        ? const Center(
                            child: CircularProgressIndicator(strokeWidth: 6),
                          )
                        : WeatherStamp(
                            weatherInfo: forecast.first,
                            fontSize: 70,
                          ),
                  ),
                  Expanded(
                    flex: 2,
                    child: requestState == WeatherRequestState.loading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.sync_rounded,
                                size: 24,
                              ),
                              Text(
                                'Загружаем прогноз погоды...',
                                style: TextStyle(fontSize: 24),
                              ),
                            ],
                          )
                        //Sublist(1) убирает из списка отметок о погоде настоящее время
                        : todayForecastList(forecast.sublist(1)),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  Widget todayForecastList(List<WeatherInfo> forecast) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: forecast.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: WeatherStamp(
          weatherInfo: forecast[index],
          fontSize: 40,
        ),
      ),
    );
  }
}
