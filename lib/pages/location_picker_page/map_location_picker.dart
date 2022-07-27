part of 'location_picker_page.dart';

class MapLocationPicker extends StatefulWidget {
  const MapLocationPicker({Key? key}) : super(key: key);

  @override
  State<MapLocationPicker> createState() => MapLocationPickerState();
}

class MapLocationPickerState extends State<MapLocationPicker> {
  final geocodingApi = OpenWeatherMapGeocodingApi(owmKey);
  final _mapController = MapController();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flutterMap = BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: state is LocationSet
                ? state.coords
                : LatLng(55.766611, 37.622044),
            zoom: 9,
            maxZoom: 16,
            onTap: (_, ll) => _mapController.move(ll, 9),
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: 'com.example.app',
            ),
          ],
          nonRotatedChildren: [
            AttributionWidget.defaultWidget(
              source: 'OpenStreetMap contributors',
              onSourceTapped: null,
            ),
          ],
        );
      },
    );

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

    return Stack(
      children: [
        flutterMap,
        marker,
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: ElevatedButton(
              onPressed: () async {
                await geocodingApi
                    .getRuNameFromLatLng(_mapController.center)
                    .then(
                  (ruName) {
                    final locationBloc = context.read<LocationBloc>();
                    locationBloc.add(
                      LocationChangedManually(
                        _mapController.center,
                        ruName,
                      ),
                    );
                    Navigator.of(context).pop();
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
        ),
      ],
    );
  }
}
