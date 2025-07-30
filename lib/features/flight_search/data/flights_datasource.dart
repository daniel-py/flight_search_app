import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../core/constants.dart';

class FlightsDataSource {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.aviationstack.com/v1';

  FlightsDataSource() {
    _dio.options.baseUrl = _baseUrl;
  }

  String? get _apiKey {
    final key = dotenv.env[Constants.aviationStackApiKey];
    if (key == null || key.isEmpty || key == 'your_api_key_here') {
      throw Exception('AviationStack API key is not configured. Please add your API key to the .env file.');
    }
    return key;
  }

  Future<Response> fetchCities({int offset = 0}) async {
    return await _dio.get('/cities', queryParameters: {
      'access_key': _apiKey,
      'offset': offset,
    });
  }

  Future<Response> fetchFlights({
    required String departureCity,
    required String arrivalCity,
    required String departureDate,
  }) async {
    return await _dio.get('/flights', queryParameters: {
      'access_key': _apiKey,
      'dep_iata': departureCity, //'jfk', //
      'arr_iata': arrivalCity, //'lax', //
      'flight_date': departureDate,
    });
  }
} 