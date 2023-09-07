import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../core/assets.dart';
import '../data/models/city.dart';
import '../data/models/weather.dart';

class WeatherService {
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  static Future<Weather> fetchWeather(City city) async {
    try {
      final appId = dotenv.env[AppAssets.weatherApiKey];
      final url = Uri.parse(
        '$_baseUrl?lat=${city.latitude}&lon=${city.longitude}&appid=$appId',
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
