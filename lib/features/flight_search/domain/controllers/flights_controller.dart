import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../data/models/city.dart';
import '../../data/models/flight.dart';
import '../repositories/flights_repository.dart';

class FlightsController extends ChangeNotifier {
  final FlightsRepository flightsRepository;

  List<Flight> _flights = [];
  List<City> _cities = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  City? _fromCity;
  City? _toCity;
  DateTime? _departureDate;
  String _tripType = 'One way';
  bool _directFlightsOnly = false;
  bool _includeNearbyAirports = false;
  String _travelClass = 'Economy';
  int _passengers = 1;

  FlightsController(this.flightsRepository);

  List<City> get cities => List.unmodifiable(_cities);
  DateTime? get departureDate => _departureDate;
  bool get directFlightsOnly => _directFlightsOnly;
  String? get errorMessage => _errorMessage;
  
  List<Flight> get flights => List.unmodifiable(_flights);
  // Search parameters getters
  City? get fromCity => _fromCity;
  bool get includeNearbyAirports => _includeNearbyAirports;
  bool get isLoading => _isLoading;
  int get passengers => _passengers;
  City? get toCity => _toCity;
  String get travelClass => _travelClass;
  String get tripType => _tripType;

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

  Future<String?> fetchFlights() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final departureCity = _fromCity?.iataCode ?? '';
      final arrivalCity = _toCity?.iataCode ?? '';
      final departureDate = _departureDate != null
          ? '${_departureDate!.year}-${_departureDate!.month.toString().padLeft(2, '0')}-${_departureDate!.day.toString().padLeft(2, '0')}'
          : '';

      final Response response = await flightsRepository.fetchFlights(
        departureCity: departureCity,
        arrivalCity: arrivalCity,
        departureDate: departureDate,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        _flights = data.map((json) => Flight.fromJson(json)).toList();
        log('Fetched flights: ${_flights.length} flights found');
        return 'success';
      } else {
        _errorMessage = 'Failed to fetch flights: ${response.statusCode}';
        log('Error fetching flights: ${response.statusCode}');
        return 'error';
      }
    } catch (e, stack) {
      if (e.toString().contains('function_access_restricted') ||
          e.toString().contains('403') ||
          e.toString().contains('subscription')) {
        log('Using mock data due to subscription limitation');
        _flights = _getMockFlights();
        return 'mock_data';
      }
      
      _errorMessage = 'Error fetching flights: ${e.toString()}';
      log('Error fetching flights: ${e.toString()}\n', error: e, stackTrace: stack);
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setDepartureDate(DateTime? date) {
    _departureDate = date;
    notifyListeners();
  }

  void setDirectFlightsOnly(bool value) {
    _directFlightsOnly = value;
    notifyListeners();
  }

  void setFromCity(City? city) {
    _fromCity = city;
    notifyListeners();
  }

  void setIncludeNearbyAirports(bool value) {
    _includeNearbyAirports = value;
    notifyListeners();
  }

  void setPassengers(int passengers) {
    _passengers = passengers;
    notifyListeners();
  }

  void setToCity(City? city) {
    _toCity = city;
    notifyListeners();
  }

  void setTravelClass(String travelClass) {
    _travelClass = travelClass;
    notifyListeners();
  }

  void setTripType(String tripType) {
    _tripType = tripType;
    notifyListeners();
  }

  List<Flight> _getMockFlights() {
    final departureCity = _fromCity?.iataCode ?? 'JFK';
    final arrivalCity = _toCity?.iataCode ?? 'LAX';
    final departureDate = _departureDate != null
        ? '${_departureDate!.year}-${_departureDate!.month.toString().padLeft(2, '0')}-${_departureDate!.day.toString().padLeft(2, '0')}'
        : '2024-01-15';
    return [
      Flight(
        flightDate: departureDate,
        flightStatus: 'scheduled',
        departure: Departure(
          airport: 'John F Kennedy International',
          timezone: 'America/New_York',
          iata: departureCity,
          icao: 'KJFK',
          terminal: '8',
          gate: '46',
          delay: null,
          scheduled: '${departureDate}T13:00:00+00:00',
          estimated: '${departureDate}T13:00:00+00:00',
          actual: null,
          estimatedRunway: null,
          actualRunway: null,
        ),
        arrival: Arrival(
          airport: 'Los Angeles International',
          timezone: 'America/Los_Angeles',
          iata: arrivalCity,
          icao: 'KLAX',
          terminal: '5',
          gate: '51B',
          baggage: 'T5C5',
          delay: null,
          scheduled: '${departureDate}T16:00:00+00:00',
          estimated: null,
          actual: null,
          estimatedRunway: null,
          actualRunway: null,
        ),
        airline: Airline(
          name: 'Alaska Airlines',
          iata: 'AS',
          icao: 'ASA',
        ),
        flight: FlightInfo(
          number: '1234',
          iata: 'AS1234',
          icao: 'ASA1234',
          codeshared: null,
        ),
        aircraft: Aircraft(
          registration: 'N123AS',
          iata: 'B738',
          icao: 'B738',
          icao24: 'A12345',
        ),
        live: null,
      ),
      Flight(
        flightDate: departureDate,
        flightStatus: 'scheduled',
        departure: Departure(
          airport: 'John F Kennedy International',
          timezone: 'America/New_York',
          iata: departureCity,
          icao: 'KJFK',
          terminal: '4',
          gate: 'A12',
          delay: null,
          scheduled: '${departureDate}T12:00:00+00:00',
          estimated: '${departureDate}T12:00:00+00:00',
          actual: null,
          estimatedRunway: null,
          actualRunway: null,
        ),
        arrival: Arrival(
          airport: 'Los Angeles International',
          timezone: 'America/Los_Angeles',
          iata: arrivalCity,
          icao: 'KLAX',
          terminal: '6',
          gate: '68A',
          baggage: 'T6A1',
          delay: null,
          scheduled: '${departureDate}T15:00:00+00:00',
          estimated: null,
          actual: null,
          estimatedRunway: null,
          actualRunway: null,
        ),
        airline: Airline(
          name: 'American Airlines',
          iata: 'AA',
          icao: 'AAL',
        ),
        flight: FlightInfo(
          number: '171',
          iata: 'AA171',
          icao: 'AAL171',
          codeshared: null,
        ),
        aircraft: Aircraft(
          registration: 'N456AA',
          iata: 'A321',
          icao: 'A321',
          icao24: 'B67890',
        ),
        live: null,
      ),
      Flight(
        flightDate: departureDate,
        flightStatus: 'scheduled',
        departure: Departure(
          airport: 'John F Kennedy International',
          timezone: 'America/New_York',
          iata: departureCity,
          icao: 'KJFK',
          terminal: '2',
          gate: 'B8',
          delay: null,
          scheduled: '${departureDate}T14:30:00+00:00',
          estimated: '${departureDate}T14:30:00+00:00',
          actual: null,
          estimatedRunway: null,
          actualRunway: null,
        ),
        arrival: Arrival(
          airport: 'Los Angeles International',
          timezone: 'America/Los_Angeles',
          iata: arrivalCity,
          icao: 'KLAX',
          terminal: '3',
          gate: '32A',
          baggage: 'T3B2',
          delay: null,
          scheduled: '${departureDate}T17:30:00+00:00',
          estimated: null,
          actual: null,
          estimatedRunway: null,
          actualRunway: null,
        ),
        airline: Airline(
          name: 'Delta Air Lines',
          iata: 'DL',
          icao: 'DAL',
        ),
        flight: FlightInfo(
          number: '2345',
          iata: 'DL2345',
          icao: 'DAL2345',
          codeshared: null,
        ),
        aircraft: Aircraft(
          registration: 'N789DL',
          iata: 'B739',
          icao: 'B739',
          icao24: 'C11111',
        ),
        live: null,
      ),
    ];
  }
} 