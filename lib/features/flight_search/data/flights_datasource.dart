import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../core/constants.dart';

class FlightsDataSource {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.aviationstack.com/v1';

  FlightsDataSource() {
    _dio.options.baseUrl = _baseUrl;
  }

  Future<Response> fetchCities({int offset = 0}) async {
    return await _dio.get('/cities', queryParameters: {
      'access_key': dotenv.env[Constants.aviationStackApiKey],
      'offset': offset,
    });
  }

  Future<Response> fetchFlights({
    required String departureCity,
    required String arrivalCity,
    required String departureDate,
  }) async {
    return await _dio.get('/flights', queryParameters: {
      'access_key': dotenv.env[Constants.aviationStackApiKey],
      'dep_iata': departureCity,
      'arr_iata': arrivalCity,
      'flight_date': departureDate,
    });
  }
} 