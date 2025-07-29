import 'dart:convert';

class City {
  final String? id;
  final String? gmt;
  final String? cityId;
  final String? iataCode;
  final String? countryIso2;
  final String? geonameId;
  final String? latitude;
  final String? longitude;
  final String? cityName;
  final String? timezone;

  City({
    this.id,
    this.gmt,
    this.cityId,
    this.iataCode,
    this.countryIso2,
    this.geonameId,
    this.latitude,
    this.longitude,
    this.cityName,
    this.timezone,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      gmt: json['gmt'],
      cityId: json['city_id'],
      iataCode: json['iata_code'],
      countryIso2: json['country_iso2'],
      geonameId: json['geoname_id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      cityName: json['city_name'],
      timezone: json['timezone'],
    );
  }

  @override
  int get hashCode {
    return id.hashCode ^
        gmt.hashCode ^
        cityId.hashCode ^
        iataCode.hashCode ^
        countryIso2.hashCode ^
        geonameId.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        cityName.hashCode ^
        timezone.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is City &&
        other.id == id &&
        other.gmt == gmt &&
        other.cityId == cityId &&
        other.iataCode == iataCode &&
        other.countryIso2 == countryIso2 &&
        other.geonameId == geonameId &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.cityName == cityName &&
        other.timezone == timezone;
  }

  String encode() {
    return toJson().toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gmt': gmt,
      'city_id': cityId,
      'iata_code': iataCode,
      'country_iso2': countryIso2,
      'geoname_id': geonameId,
      'latitude': latitude,
      'longitude': longitude,
      'city_name': cityName,
      'timezone': timezone,
    };
  }

  static City decode(String encoded) {
    try {
      final Map<String, dynamic> json = jsonDecode(encoded);
      return City.fromJson(json);
    } catch (e) {
      throw Exception('Failed to decode City: $e');
    }
  }
} 