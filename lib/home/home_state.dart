import '../app/data/models/city.dart';
import '../app/data/models/weather.dart';

class HomeState {
  final List<Weather> weathers;
  final List<City> cities;

  const HomeState({
    this.weathers = const [],
    this.cities = const [],
  });

  HomeState copyWith({
    List<Weather>? weathers,
    List<City>? cities,
  }) {
    return HomeState(
      weathers: weathers ?? this.weathers,
      cities: cities ?? this.cities,
    );
  }
}
