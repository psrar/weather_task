import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather_test/apis/geolocator_api.dart';
import 'package:weather_test/bloc/geocoding_api_repository.dart';
import 'package:weather_test/bloc/location/location_bloc.dart';
import 'package:weather_test/connectivity_checker.dart';

part 'map_location_picker.dart';

//Страница выбора местоположения
class LocationPickerPage extends StatelessWidget {
  const LocationPickerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Кнопка получения места через геолокацию
    final selectCurrentPos = LocationPickerModeButton(
        onPressed: () async {
          try {
            await getCurrentPosition().then((coords) async {
              final geocodingApi =
                  context.read<GeocodingApiRepository>().geocodingApi;
              await geocodingApi.getRuNameFromLatLng(coords).then((name) {
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Не удалось узнать название места')));
                  return;
                }

                context
                    .read<LocationBloc>()
                    .add(LocationChangedManually(coords, name));

                //Возвращение на главный экран
                Navigator.of(context).popUntil((route) => route.isFirst);
              });
            });
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text('Не удалось получить ваше местоположение'),
              ),
            );
          }
        },
        iconData: Icons.my_location_rounded,
        label: 'Текущее\nместоположение');

    //Кнопка выбора места на карте
    final selectOnMapButton = LocationPickerModeButton(
        onPressed: () async {
          await executeOrShowSnackBar(
            context,
            () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(),
                    body: const MapLocationPicker(),
                  );
                },
              ),
            ),
          );
        },
        iconData: Icons.map_rounded,
        label: 'Выбрать\nна карте');

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Выберите локацию для отображения погоды',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 40,
              runSpacing: 40,
              children: [selectCurrentPos, selectOnMapButton],
            ),
          ),
        ],
      ),
    );
  }
}

//Стиль кнопки выбора местоположения
class LocationPickerModeButton extends StatelessWidget {
  final void Function() onPressed;
  final IconData iconData;
  final String label;

  const LocationPickerModeButton(
      {Key? key,
      required this.onPressed,
      required this.iconData,
      required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      child: Column(
        children: [
          Icon(
            iconData,
            size: 48,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          )
        ],
      ),
    );
  }
}
