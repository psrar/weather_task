import 'package:flutter/material.dart';
import 'package:weather_test/apis/weather_api.dart';

//Виджет отображения средних показателей погоды за день недели
class WeekWeatherStamp extends StatelessWidget {
  final List<WeatherInfo> weekWeather;
  final double fontSize;

  const WeekWeatherStamp(
      {Key? key, required this.weekWeather, required this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double minTemperature = weekWeather.first.temperature;
    double maxTemperature = minTemperature;
    int avgHumidity = 0;
    double avgTemperature = 0;
    double avgWindSpeed = 0;
    for (var w in weekWeather) {
      //Вычисление максимальной и минимальной температуры
      if (w.temperature < minTemperature) minTemperature = w.temperature;
      if (w.temperature > maxTemperature) maxTemperature = w.temperature;
      //Вычисление средних показателей
      avgHumidity += w.humidity;
      avgTemperature += w.temperature;
      avgWindSpeed += w.windspeed;
    }
    avgHumidity ~/= weekWeather.length;
    avgTemperature /= weekWeather.length;
    avgWindSpeed /= weekWeather.length;

    final DateTime date = weekWeather.first.timeStamp;
    //Название дня недели на Русском
    final String day = _getWeekDayInRussian(date);

    final String dateStr =
        '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: fontSize - 4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$avgHumidity%',
                  style: TextStyle(
                    fontSize: fontSize - 4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${avgWindSpeed.round()}м/с',
                  style: TextStyle(
                    fontSize: fontSize - 4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  _temperatureTosString(avgTemperature),
                  style: TextStyle(
                    fontSize: fontSize + 4,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 4),
                Column(
                  children: [
                    Text(
                      _temperatureTosString(maxTemperature),
                      style: TextStyle(
                          fontSize: fontSize - 8,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange),
                    ),
                    Text(
                      _temperatureTosString(minTemperature),
                      style: TextStyle(
                          fontSize: fontSize - 8,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//Форматирование температуры и добавление плюса в начало
String _temperatureTosString(double temp) {
  int round = temp.round();
  if (round < 0) return round.toString();
  if (round > 1) return '+${round.toString()}';
  return '0';
}

String _getWeekDayInRussian(DateTime date) {
  switch (date.weekday) {
    case 1:
      return 'Понедельник';
    case 2:
      return 'Вторник';
    case 3:
      return 'Среда';
    case 4:
      return 'Четверг';
    case 5:
      return 'Пятница';
    case 6:
      return 'Суббота';
    case 7:
      return 'Воскресенье';
    default:
      return 'Неизвестно';
  }
}
