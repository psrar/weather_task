import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather_test/apis/open_weather_map/owm_geocoding_api.dart';
import 'package:weather_test/apis/open_weather_map/owm_key.dart';
import 'package:weather_test/apis/weather_api.dart';
import 'package:weather_test/bloc/location/location_bloc.dart';
import 'package:weather_test/bloc/weather_request/weather_request_cubit.dart';
import 'location_picker_mode_button.dart';

part 'map_location_picker.dart';

class LocationPickerPage extends StatelessWidget {
  const LocationPickerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectCurrentPos = LocationPickerModeButton(
        onPressed: () {
          print('Текущее местоположение');
        },
        iconData: Icons.my_location_rounded,
        label: 'Текущее\nместоположение');

    final selectOnMapButton = LocationPickerModeButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return Scaffold(
                  appBar: AppBar(),
                  body: const MapLocationPicker(),
                );
              },
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
          BlocBuilder<LocationBloc, LocationState>(
            builder: (context, state) {
              return Text(
                'Выбранное место:\n${state is LocationSet ? state.ruName : 'не выбрано'}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 42),
              );
            },
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
