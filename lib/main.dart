import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather_test/apis/open_weather_map/owm_key.dart';
import 'package:weather_test/apis/open_weather_map/owm_weather_api.dart';
import 'package:weather_test/bloc/location/location_bloc.dart';
import 'package:weather_test/bloc/weather_repository.dart';
import 'package:weather_test/bloc/weather_request/weather_request_cubit.dart';
import 'package:weather_test/pages/location_picker_page/location_picker_page.dart';
import 'package:weather_test/pages/today_page/today_weather_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LocationBloc()),
        BlocProvider(create: (_) => WeatherRequestCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather test',
        theme: ThemeData(
          colorSchemeSeed: Colors.blue,
          useMaterial3: true,
        ),
        home: RepositoryProvider(
          create: (context) => WeatherRepository(),
          child: MultiBlocListener(
            listeners: [
              getLocationListener(),
              getRequestStateListener(),
            ],
            child: const HomePage(),
          ),
        ),
      ),
    );
  }

  BlocListener<LocationBloc, LocationState> getLocationListener() {
    return BlocListener<LocationBloc, LocationState>(
      listener: (context, state) async {
        if (state is LocationSet) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Прогноз установлен для //${state.ruName}'),
            duration: const Duration(milliseconds: 800),
          ));

          context
              .read<WeatherRequestCubit>()
              .changeState(WeatherRequestState.loading);

          // await updateForecast(context);
        }
      },
    );
  }

  BlocListener<WeatherRequestCubit, WeatherRequestState>
      getRequestStateListener() {
    return BlocListener<WeatherRequestCubit, WeatherRequestState>(
      listener: (context, state) async {
        //loading означает и само состояние обновления, и
        //поступивший запрос на обновление.
        //Так что мы можем обновлять погоду, переводя
        //WeatherRequestCubit в состояние loading.
        if (state == WeatherRequestState.loading) {
          final locationState =
              context.read<LocationBloc>().state as LocationSet;

          //Получаем погоду на ближайшие 5 дней
          await OpenWeatherMapApi(owmKey)
              .getTodayWeatherInfo(locationState.coords)
              .then(
            (forecast) {
              //Записываем погоду в репозиторий для обращения на других экранах
              RepositoryProvider.of<WeatherRepository>(context)
                  .rewrite(forecast);

              //Объявляем о завершении загрузки
              context
                  .read<WeatherRequestCubit>()
                  .changeState(WeatherRequestState.loaded);
            },
          );
        }
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Внедрение Bloc сильно и неоправданно усложняло код
  //В данном случае выбрано простое управление состоянием
  int _selectedIndex = 0;

  final _pageController = PageController();

  final _navBarDestinations = const [
    NavigationDestination(
      icon: Icon(Icons.today),
      label: 'Погода на сегодня',
    ),
    NavigationDestination(
      icon: Icon(Icons.calendar_month),
      label: 'Погода на неделю',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Погода'),
        elevation: 0,
        centerTitle: true,
        actions: [getPlacePickerWidget(context)],
      ),
      body: PageView(
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        onPageChanged: (index) => setState(
          () => _selectedIndex = index,
        ),
        children: [
          const TodayWeatherPage(),
          Container(color: Colors.green),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
          );
        },
        destinations: _navBarDestinations,
      ),
    );
  }

  Widget getPlacePickerWidget(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LocationPickerPage(),
          ),
        );
      },
      icon: const Icon(Icons.place_outlined),
    );
  }
}
