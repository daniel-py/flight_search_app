import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../data/models/city.dart';
import '../data/models/flight.dart';
import '../domain/flights_repository.dart';

class FlightsController extends ChangeNotifier {
  final FlightsRepository flightsRepository;

  List<Flight> _flights = [];
  List<City> _cities = [];
  bool _isLoading = false;
  String? _errorMessage;

  FlightsController(this.flightsRepository);

  List<City> get cities => List.unmodifiable(_cities);
  String? get errorMessage => _errorMessage;
  List<Flight> get flights => List.unmodifiable(_flights);
  bool get isLoading => _isLoading;

  void clearCities() {
    _cities.clear();
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearFlights() {
    _flights.clear();
    notifyListeners();
  }

  Future<bool?> fetchCities({int offset = 0}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final Response response = await flightsRepository.fetchCities(offset: offset);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        _cities = data.map((json) => City.fromJson(json)).toList();
        log('Fetched cities: ${_cities.length} cities found');
        return true;
      } else {
        _errorMessage = 'Failed to fetch cities: ${response.statusCode}';
        log('Error fetching cities: ${response.statusCode}');
        return false;
      }
    } catch (e, stack) {
      _errorMessage = 'Error fetching cities: ${e.toString()}';
      log('Error fetching cities: ${e.toString()}\n', error: e, stackTrace: stack);
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool?> fetchFlights({
    required String departureCity,
    required String arrivalCity,
    required String departureDate,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final Response response = await flightsRepository.fetchFlights(
        departureCity: departureCity,
        arrivalCity: arrivalCity,
        departureDate: departureDate,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        _flights = data.map((json) => Flight.fromJson(json)).toList();
        log('Fetched flights: ${_flights.length} flights found');
        return true;
      } else {
        _errorMessage = 'Failed to fetch flights: ${response.statusCode}';
        log('Error fetching flights: ${response.statusCode}');
        return false;
      }
    } catch (e, stack) {
      _errorMessage = 'Error fetching flights: ${e.toString()}';
      log('Error fetching flights: ${e.toString()}\n', error: e, stackTrace: stack);
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 