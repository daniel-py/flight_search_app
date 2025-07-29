import 'package:dio/dio.dart';

import '../data/flights_datasource.dart';

abstract class FlightsRepository {
  Future<Response> fetchCities({int offset = 0});

  Future<Response> fetchFlights({
    required String departureCity,
    required String arrivalCity,
    required String departureDate,
  });
}

class FlightsRepositoryImpl implements FlightsRepository {
  final FlightsDataSource _dataSource;

  FlightsRepositoryImpl(this._dataSource);

  @override
  Future<Response> fetchCities({int offset = 0}) async {
    return await _dataSource.fetchCities(offset: offset);
  }

  @override
  Future<Response> fetchFlights({
    required String departureCity,
    required String arrivalCity,
    required String departureDate,
  }) async {
    return await _dataSource.fetchFlights(
      departureCity: departureCity,
      arrivalCity: arrivalCity,
      departureDate: departureDate,
    );
  }
} 