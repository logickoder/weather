import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/models/city.dart';
import '../data/models/weather.dart';

class WeatherService {
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static const _appId = '1251af495dd0a5bf6c7374a3c52df6f1';

  static Future<Weather> fetchWeather(City city) async {
    try {
      final url = Uri.parse(
        '$_baseUrl?lat=${city.latitude}&lon=${city.longitude}&appid=$_appId',
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        return Future.error(response.reasonPhrase.toString());
      }
    } catch (error, stackTrace) {
      return Future.error(error, stackTrace);
    }
  }
}
