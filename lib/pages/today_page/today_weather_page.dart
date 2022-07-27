import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_test/apis/weather_api.dart';
import 'package:weather_test/bloc/location/location_bloc.dart';
import 'package:weather_test/bloc/weather_data_repository.dart';
import 'package:weather_test/bloc/weather_request/weather_request_cubit.dart';
import 'package:weather_test/pages/today_page/weather_stamp.dart';

//Страница погоды на несколько часов вперёд
class TodayWeatherPage extends StatelessWidget {
  const TodayWeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherRequestCubit, WeatherRequestState>(
      builder: (context, requestState) {
        //Получение погоды на следующие 24 часа
        final forecast = requestState == WeatherRequestState.loaded
            ? RepositoryProvider.of<WeatherRepository>(context)
                .forecastForFewHours(24)
            : <WeatherInfo>[];

        final locationName =
            (context.read<LocationBloc>().state as LocationSet).ruName;

        return Column(
          children: [
            Expanded(
              child: Text(
                locationName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
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
                      tempFontSize: 70,
                      secondaryFontSize: 30,
                    ),
            ),
            Expanded(
              flex: 2,
              child: requestState == WeatherRequestState.loading
                  //Загрузочный экран
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

//Список виджетов прогноза погоды на несколько часов
  Widget todayForecastList(List<WeatherInfo> forecast) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: forecast.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: WeatherStamp(
          weatherInfo: forecast[index],
          tempFontSize: 38,
          secondaryFontSize: 20,
        ),
      ),
    );
  }
}
