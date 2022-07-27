import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_test/apis/weather_api.dart';

//Виджет отображения информации о погоде
class WeatherStamp extends StatelessWidget {
  final WeatherInfo weatherInfo;
  final double tempFontSize;
  final double secondaryFontSize;

  const WeatherStamp(
      {Key? key,
      required this.weatherInfo,
      required this.tempFontSize,
      required this.secondaryFontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String temperature = _temperatureToString(weatherInfo.temperature);
    final String time =
        '${weatherInfo.timeStamp.hour.toString().padLeft(2, '0')}:${weatherInfo.timeStamp.minute.toString().padLeft(2, '0')}';
    final String humidity = '${weatherInfo.humidity}%';
    final String windSpeed = '${weatherInfo.windspeed.round()}м/с';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          temperature,
          style: TextStyle(
            fontSize: tempFontSize,
            fontWeight: FontWeight.w800,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              humidity,
              style: TextStyle(
                fontSize: secondaryFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              windSpeed,
              style: TextStyle(
                fontSize: secondaryFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          time.toString(),
          style: TextStyle(
            fontSize: tempFontSize - 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  //Форматирование температуры и добавление плюса в начало
  String _temperatureToString(double temp) {
    int round = temp.round();
    if (round < 0) return round.toString();
    if (round > 1) return '+${round.toString()}';
    return '0';
  }
}
