import '../app/data/models/city.dart';
import '../app/data/models/weather.dart';

class HomeState {
  final Weather? selectedLocation;
  final List<Weather> weathers;
  final List<City> cities;

  const HomeState({
    this.selectedLocation,
    this.weathers = const [],
    this.cities = const [],
  });

  HomeState copyWith({
    Weather? selectedLocation,
    List<Weather>? weathers,
    List<City>? cities,
  }) {
    return HomeState(
      selectedLocation: selectedLocation ?? this.selectedLocation,
      weathers: weathers ?? this.weathers,
      cities: cities ?? this.cities,
    );
  }
}
