import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/data/models/city.dart';
import '../app/services/city_service.dart';
import '../app/services/location_service.dart';
import '../app/services/logger_service.dart';
import '../app/services/weather_service.dart';
import 'home_state.dart';

final homeController = NotifierProvider.autoDispose<HomeController, HomeState>(
  HomeController.new,
);

class HomeController extends AutoDisposeNotifier<HomeState> {
  static City currentLocation = City(
    name: 'Current Location',
    latitude: '',
    longitude: '',
  );

  @override
  HomeState build() {
    Future.microtask(() async {
      // fetch the available cities
      await _fetchAvailableCities();
      // fetch the saved cities
      await _fetchSavedCities();
    });
    return const HomeState();
  }

  /// Fetches the weather for the saved cities
  Future<void> _fetchSavedCities() async {
    final cities = await CityService.fetchSavedCities();
    // fetch the weather for each city
    for (final city in cities) {
      try {
        // update the state with the weather for the city
        state = state.copyWith(
          weathers: state.weathers + [await WeatherService.fetchWeather(city)],
        );
      } catch (error, stackTrace) {
        logger.e(error, stackTrace: stackTrace);
      }
    }
  }

  /// Fetches the list of available cities the user can select from.
  Future<void> _fetchAvailableCities() async {
    final cities = await CityService.fetchCities();
    // update the state
    state = state.copyWith(cities: cities);
    // update the selected location to lagos
    await getWeatherForLocation(cities.first, (_, __) {});
  }

  /// Adds a city to the list of saved cities.
  Future<String?> addCity(City city) async {
    try {
      // if the city is already saved, return
      if (state.weathers.any((w) => w.city == city)) {
        return '${city.name} is already added.';
      }
      // fetch the weather for the city
      final weather = await WeatherService.fetchWeather(city);
      // save the city
      await CityService.saveCity(city);
      // update the state
      state = state.copyWith(
        weathers: state.weathers + [weather],
      );
      return null;
    } catch (error, stackTrace) {
      logger.e(error, stackTrace: stackTrace);
      return error.toString();
    }
  }

  /// Removes a city from the list of saved cities.
  Future<String?> removeCity(String cityName) async {
    try {
      // get the saved cities
      final cities = await CityService.fetchSavedCities();
      // return false if their is only one city left
      if (cities.length == 1) {
        return 'Cannot remove the last city.';
      }
      final city = cities.firstWhere((c) => c.name == cityName);
      // remove the city
      await CityService.removeCity(city);
      // update the state
      state = state.copyWith(
        weathers: state.weathers.where((w) => w.city != city).toList(),
      );
      return null;
    } catch (error, stackTrace) {
      logger.e(error, stackTrace: stackTrace);
      return error.toString();
    }
  }

  /// Get weather for location
  Future<void> getWeatherForLocation(
    City city,
    Function(String, Future Function()) showLocationRationaleDialog,
  ) async {
    try {
      // check if the city is the current location
      if (city == currentLocation) {
        // get the current location
        final position = await LocationService.getCurrentLocation(
          showLocationRationaleDialog,
        );
        // update the city
        city = city.copyWith(
          latitude: position.latitude.toString(),
          longitude: position.longitude.toString(),
        );
      }
      // fetch the weather for the city
      final weather = await WeatherService.fetchWeather(city);
      // update the state
      state = state.copyWith(
        selectedLocation: weather.copyWith(
          city: city,
        ),
      );
    } catch (error, stackTrace) {
      logger.e(error, stackTrace: stackTrace);
    }
  }
}
