import '../../extensions/string_extensions.dart';
import 'city.dart';

const _baseIconUrl = 'https://openweathermap.org/img/wn';

class Weather {
  final String description;
  final String icon;
  final double temperature;
  final City city;
  final double windSpeed;
  final int humidity;
  final int pressure;
  final int cloudiness;

  const Weather({
    required this.description,
    required this.icon,
    required this.temperature,
    required this.city,
    required this.windSpeed,
    required this.humidity,
    required this.pressure,
    required this.cloudiness,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final weatherMap = json["weather"][0] as Map<String, dynamic>;
    return Weather(
      description: weatherMap["description"].toString().capitalizeCase,
      // include the base url for the icon
      icon: '$_baseIconUrl/${weatherMap["icon"]}@4x.png',
      // convert temperature from Kelvin to Celsius
      temperature: json["main"]["temp"].toDouble() - 273.15,
      // convert the wind speed from m/s to km/h
      windSpeed: json["wind"]["speed"].toDouble() * 3.6,
      humidity: json["main"]["humidity"].toInt(),
      pressure: json["main"]["pressure"].toInt(),
      cloudiness: json["clouds"]["all"].toInt(),
      city: City(
        name: json["name"].toString().capitalizeCase,
        latitude: json["coord"]["lat"].toString(),
        longitude: json["coord"]["lon"].toString(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "icon": icon,
      "temperature": temperature,
      "windSpeed": windSpeed,
      "humidity": humidity,
      "pressure": pressure,
      "city": city.toJson(),
      "cloudiness": cloudiness,
    };
  }

  Weather copyWith({
    String? description,
    String? icon,
    double? temperature,
    City? city,
    double? windSpeed,
    int? humidity,
    int? pressure,
    int? cloudiness,
  }) {
    return Weather(
      description: description ?? this.description,
      icon: icon ?? this.icon,
      temperature: temperature ?? this.temperature,
      city: city ?? this.city,
      windSpeed: windSpeed ?? this.windSpeed,
      humidity: humidity ?? this.humidity,
      pressure: pressure ?? this.pressure,
      cloudiness: cloudiness ?? this.cloudiness,
    );
  }
}
