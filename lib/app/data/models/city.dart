class City {
  final String name, latitude, longitude;

  City({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['city'],
      latitude: json['lat'],
      longitude: json['lng'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': name,
      'lat': latitude,
      'lng': longitude,
    };
  }

  City copyWith({
    String? name,
    String? latitude,
    String? longitude,
  }) {
    return City(
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is City && other.name == name;
  }

  @override
  String toString() {
    return 'City(name: $name, latitude: $latitude, longitude: $longitude)';
  }
}
