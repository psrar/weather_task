import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_test/bloc/weather_data_repository.dart';
import 'package:weather_test/bloc/weather_request/weather_request_cubit.dart';
import 'package:weather_test/pages/week_page/week_weather_stamp.dart';

//Страница погоды на неделю
class WeekWeatherPage extends StatelessWidget {
  const WeekWeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherRequestCubit, WeatherRequestState>(
      builder: (context, state) {
        if (state == WeatherRequestState.loading) {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 6),
          );
        } else {
          final weekForecast =
              context.read<WeatherRepository>().forecastForWeek();

          return ListView.separated(
            itemCount: weekForecast.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) => WeekWeatherStamp(
              weekWeather: weekForecast[index],
              fontSize: 22,
            ),
          );
        }
      },
    );
  }
}
