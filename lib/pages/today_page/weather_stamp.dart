import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_test/apis/weather_api.dart';

class WeatherStamp extends StatelessWidget {
  final WeatherInfo weatherInfo;
  final double fontSize;

  const WeatherStamp({Key? key, required this.weatherInfo, this.fontSize = 44})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String temperature = weatherInfo.temperature.round().toString();
    if (temperature[0] != '-') temperature = '+$temperature';
    final time =
        '${weatherInfo.timeStamp.hour.toString().padLeft(2, '0')}:${weatherInfo.timeStamp.minute.toString().padLeft(2, '0')}';
    final humidity = '${weatherInfo.humidity}%';
    final windSpeed = '${weatherInfo.windspeed.round()}м/с';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          temperature,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              humidity,
              style: TextStyle(
                fontSize: fontSize - 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              windSpeed,
              style: TextStyle(
                fontSize: fontSize - 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        Text(
          time.toString(),
          style: TextStyle(
            fontSize: fontSize - 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
