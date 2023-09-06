import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/assets.dart';
import '../data/models/city.dart';

class CityService {
  static const key = 'cities';

  /// Fetches the list of cities from the assets folder.
  static Future<List<City>> fetchCities() async {
    final json = await rootBundle.loadString(AppAssets.cities);
    final cities = jsonDecode(json) as List<dynamic>;
    return cities.map((city) => City.fromJson(city)).toList().sublist(0, 15);
  }

  /// Fetches the list of saved cities from the local store.
  static Future<List<City>> fetchSavedCities() async {
    final pref = await SharedPreferences.getInstance();
    final cities = pref.getStringList(key);
    if (cities == null) {
      // If there are no saved cities, return the first 3 cities from the list.
      return (await fetchCities()).sublist(0, 3);
    } else {
      return cities.map((city) => City.fromJson(jsonDecode(city))).toList();
    }
  }

  /// Saves the list of user selected cities to the local store.
  static Future<void> saveCities(List<City> cities) async {
    final pref = await SharedPreferences.getInstance();
    // make sure that the list is unique
    cities = cities.toSet().toList();
    await pref.setStringList(
      key,
      cities.map((city) => jsonEncode(city.toJson())).toList(),
    );
  }

  /// Saves a user selected city to the local store.
  static Future<void> saveCity(City city) async {
    final cities = await fetchSavedCities();
    saveCities([...cities, city]);
  }

  /// Removes a city from the local store.
  static Future<void> removeCity(City city) async {
    final cities = await fetchSavedCities();
    cities.removeWhere((c) => c == city);
    saveCities(cities);
  }
}
