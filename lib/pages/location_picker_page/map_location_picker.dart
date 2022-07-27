part of 'location_picker_page.dart';

//Виджет выбора места на карте
class MapLocationPicker extends StatefulWidget {
  const MapLocationPicker({Key? key}) : super(key: key);

  @override
  State<MapLocationPicker> createState() => MapLocationPickerState();
}

class MapLocationPickerState extends State<MapLocationPicker> {
  final _mapController = MapController();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final geocodingApi = context.read<GeocodingApiRepository>().geocodingApi;

    final locationState = context.read<LocationBloc>().state;
    final initPosition = locationState is LocationSet
        ? locationState.coords
        : LatLng(55.766611, 37.622044);

//Виджет карты. Если место уже было выбрано ранее, начальная
//позиция будет установлена в это место
    final flutterMap = FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: initPosition,
        zoom: 9,
        maxZoom: 16,
        onTap: (_, latLng) => _mapController.move(latLng, 9),
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: 'com.example.app',
        ),
      ],
      nonRotatedChildren: [
        AttributionWidget.defaultWidget(
          source: 'OpenStreetMap',
        ),
      ],
    );

//Виджет красного маркера выбора места
    final marker = IgnorePointer(
      child: Align(
        alignment: Alignment.center,
        child: Transform.translate(
          offset: const Offset(0, -24),
          child: const Icon(
            Icons.place_rounded,
            color: Colors.red,
            size: 52,
          ),
        ),
      ),
    );

//Кнопка подтверждения выбора места
    final applyButton = Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: ElevatedButton(
          onPressed: () async {
            //Сначала приложение получает название места
            await geocodingApi.getRuNameFromLatLng(_mapController.center).then(
              (name) {
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    margin: EdgeInsets.only(bottom: 100, left: 18, right: 18),
                    behavior: SnackBarBehavior.floating,
                    content:
                        Text('Не удаётся получить название выбранного места'),
                  ));
                  return;
                }

                final locationBloc = context.read<LocationBloc>();
                locationBloc.add(
                  LocationChangedManually(
                    _mapController.center,
                    name,
                  ),
                );

                //Возвращение на главный экран
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            );
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Выбрать место',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );

    return Stack(
      children: [
        flutterMap,
        marker,
        applyButton,
      ],
    );
  }
}
