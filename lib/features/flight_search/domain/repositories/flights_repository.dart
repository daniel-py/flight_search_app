import 'package:dio/dio.dart';

abstract class FlightsRepository {
  Future<Response> fetchCities({int offset = 0});

  Future<Response> fetchFlights({
    required String departureCity,
    required String arrivalCity,
    required String departureDate,
  });
} 