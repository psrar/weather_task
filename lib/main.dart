import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_test/apis/open_weather_map/owm_geocoding_api.dart';
import 'package:weather_test/apis/open_weather_map/owm_key.dart';
import 'package:weather_test/apis/open_weather_map/owm_weather_api.dart';
import 'package:weather_test/bloc/geocoding_api_repository.dart';
import 'package:weather_test/bloc/location/location_bloc.dart';
import 'package:weather_test/bloc/weather_api_repository.dart';
import 'package:weather_test/bloc/weather_data_repository.dart';
import 'package:weather_test/bloc/weather_request/weather_request_cubit.dart';
import 'package:weather_test/pages/location_picker_page/location_picker_page.dart';
import 'package:weather_test/pages/today_page/today_weather_page.dart';
import 'package:weather_test/pages/week_page/week_weather_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WeatherRequestCubit()),
        BlocProvider(create: (_) => LocationBloc()),
      ],
      //Репозитории выбранных Api и информации о погоде
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => WeatherRepository(),
          ),
          RepositoryProvider(
            create: (context) =>
                GeocodingApiRepository(OpenWeatherMapGeocodingApi(owmKey)),
          ),
          RepositoryProvider(
            create: (context) =>
                WeatherApiRepository(OpenWeatherMapApi(owmKey)),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Weather test',
          theme: ThemeData(
            colorSchemeSeed: Colors.blue,
            useMaterial3: true,
          ),
          home: MultiBlocListener(
            listeners: [
              getLocationListener(),
              getRequestStateListener(),
            ],
            child: BlocBuilder<LocationBloc, LocationState>(
              builder: (context, state) {
                //Если местоположение не установлено, переходим на экран настройки
                if (state is LocationSet) {
                  return const HomePage();
                } else {
                  return const LocationPickerPage();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  //Изменение состояния приложения при изменении
  //выбранного местоположения
  BlocListener<LocationBloc, LocationState> getLocationListener() {
    return BlocListener<LocationBloc, LocationState>(
      listener: (context, state) async {
        //Если местоположение установлено, сообщаем об этом пользователю
        if (state is LocationSet) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Выбранное местоположение: ${state.ruName}'),
          ));
          //Запускаем загрузку погоды для выбранного местоположения
          context
              .read<WeatherRequestCubit>()
              .changeState(WeatherRequestState.loading);
        }
      },
    );
  }

  //Изменение состояния приложения в зависимости от статуса
  //загрузки погоды
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
          final weatherApi = context.read<WeatherApiRepository>().weatherApi;

          //Получаем погоду на ближайшие 5 дней
          await weatherApi.getTodayWeatherInfo(locationState.coords).then(
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
  //В данном случае выбран обычный setState
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
        elevation: 1,
        centerTitle: true,
        actions: [getPlacePickerWidget(context)],
      ),
      body: PageView(
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        onPageChanged: (index) => setState(
          () => _selectedIndex = index,
        ),
        children: const [
          TodayWeatherPage(),
          WeekWeatherPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
        ),
        destinations: _navBarDestinations,
      ),
    );
  }

//Виджет в AppBar для выбора местоположения
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
