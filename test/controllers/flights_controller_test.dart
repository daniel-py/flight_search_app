import 'package:dio/dio.dart';
import 'package:flight_search_app/features/flight_search/data/models/city.dart';
import 'package:flight_search_app/features/flight_search/data/models/flight.dart';
import 'package:flight_search_app/features/flight_search/domain/controllers/flights_controller.dart';
import 'package:flight_search_app/features/flight_search/domain/repositories/flights_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'flights_controller_test.mocks.dart';

@GenerateMocks([FlightsRepository])
void main() {
  group('FlightsController Tests', () {
    late FlightsController controller;
    late MockFlightsRepository mockRepository;

    setUp(() {
      mockRepository = MockFlightsRepository();
      controller = FlightsController(mockRepository);
    });

    group('Initial State Tests', () {
      test('should initialize with default values', () {
        expect(controller.isLoading, false);
        expect(controller.flights, isEmpty);
        expect(controller.cities, isEmpty);
        expect(controller.errorMessage, isNull);
        expect(controller.fromCity, isNull);
        expect(controller.toCity, isNull);
        expect(controller.departureDate, isNull);
        expect(controller.tripType, 'One way');
        expect(controller.travelClass, 'Economy');
        expect(controller.passengers, 1);
        expect(controller.directFlightsOnly, false);
        expect(controller.includeNearbyAirports, false);
      });

      test('should return unmodifiable lists', () {
        expect(controller.flights, isA<List<Flight>>());
        expect(controller.cities, isA<List<City>>());
        
        expect(() => controller.flights.add(Flight()), throwsUnsupportedError);
        expect(() => controller.cities.add(City()), throwsUnsupportedError);
      });
    });

    group('City Selection Tests', () {
      test('should set and get fromCity', () {
        final city = City(iataCode: 'JFK', cityName: 'New York');
        controller.setFromCity(city);

        expect(controller.fromCity, equals(city));
      });

      test('should set and get toCity', () {
        final city = City(iataCode: 'LAX', cityName: 'Los Angeles');
        controller.setToCity(city);

        expect(controller.toCity, equals(city));
      });

      test('should handle null city values', () {
        controller.setFromCity(null);
        controller.setToCity(null);

        expect(controller.fromCity, isNull);
        expect(controller.toCity, isNull);
      });
    });

    group('Date and Time Tests', () {
      test('should set and get departureDate', () {
        final date = DateTime(2024, 1, 15);
        controller.setDepartureDate(date);

        expect(controller.departureDate, equals(date));
      });

      test('should handle null departureDate', () {
        controller.setDepartureDate(null);
        expect(controller.departureDate, isNull);
      });
    });

    group('Search Parameters Tests', () {
      test('should set and get tripType', () {
        controller.setTripType('Round trip');
        expect(controller.tripType, 'Round trip');

        controller.setTripType('One way');
        expect(controller.tripType, 'One way');
      });

      test('should set and get travelClass', () {
        controller.setTravelClass('Business');
        expect(controller.travelClass, 'Business');

        controller.setTravelClass('First Class');
        expect(controller.travelClass, 'First Class');
      });

      test('should set and get passengers', () {
        controller.setPassengers(3);
        expect(controller.passengers, 3);

        controller.setPassengers(1);
        expect(controller.passengers, 1);
      });

      test('should set and get directFlightsOnly', () {
        controller.setDirectFlightsOnly(true);
        expect(controller.directFlightsOnly, true);

        controller.setDirectFlightsOnly(false);
        expect(controller.directFlightsOnly, false);
      });

      test('should set and get includeNearbyAirports', () {
        controller.setIncludeNearbyAirports(true);
        expect(controller.includeNearbyAirports, true);

        controller.setIncludeNearbyAirports(false);
        expect(controller.includeNearbyAirports, false);
      });
    });

    group('Clear Methods Tests', () {
      test('should clear cities', () {

        controller.clearCities();
        expect(controller.cities, isEmpty);
      });

      test('should clear flights', () {

        controller.clearFlights();
        expect(controller.flights, isEmpty);
      });

      test('should clear error', () {

        controller.clearError();
        expect(controller.errorMessage, isNull);
      });
    });

    group('fetchCities Tests', () {
      test('should fetch cities successfully', () async {
        final response = Response(
          data: {
            'data': [
              {'iata_code': 'JFK', 'city_name': 'New York'},
              {'iata_code': 'LAX', 'city_name': 'Los Angeles'},
            ]
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/cities'),
        );

        when(mockRepository.fetchCities(offset: 0))
            .thenAnswer((_) async => response);

        final result = await controller.fetchCities();

        expect(result, true);
        expect(controller.cities.length, 2);
        expect(controller.cities[0].iataCode, 'JFK');
        expect(controller.cities[0].cityName, 'New York');
        expect(controller.cities[1].iataCode, 'LAX');
        expect(controller.cities[1].cityName, 'Los Angeles');
        expect(controller.isLoading, false);
        expect(controller.errorMessage, isNull);
      });

      test('should fetch cities with offset', () async {
        final response = Response(
          data: {'data': []},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/cities'),
        );

        when(mockRepository.fetchCities(offset: 10))
            .thenAnswer((_) async => response);

        final result = await controller.fetchCities(offset: 10);

        expect(result, true);
        verify(mockRepository.fetchCities(offset: 10)).called(1);
      });

      test('should handle fetch cities error response', () async {
        final response = Response(
          data: null,
          statusCode: 500,
          requestOptions: RequestOptions(path: '/cities'),
        );

        when(mockRepository.fetchCities(offset: 0))
            .thenAnswer((_) async => response);

        final result = await controller.fetchCities();

        expect(result, false);
        expect(controller.cities, isEmpty);
        expect(controller.isLoading, false);
        expect(controller.errorMessage, contains('Failed to fetch cities: 500'));
      });

      test('should handle fetch cities network exception', () async {
        when(mockRepository.fetchCities(offset: 0))
            .thenThrow(Exception('Network error'));

        final result = await controller.fetchCities();

        expect(result, isNull);
        expect(controller.cities, isEmpty);
        expect(controller.isLoading, false);
        expect(controller.errorMessage, contains('Error fetching cities'));
      });

      test('should handle empty data response', () async {
        final response = Response(
          data: {'data': []},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/cities'),
        );

        when(mockRepository.fetchCities(offset: 0))
            .thenAnswer((_) async => response);

        final result = await controller.fetchCities();

        expect(result, true);
        expect(controller.cities, isEmpty);
        expect(controller.isLoading, false);
        expect(controller.errorMessage, isNull);
      });

      test('should handle null data in response', () async {
        final response = Response(
          data: {'data': null},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/cities'),
        );

        when(mockRepository.fetchCities(offset: 0))
            .thenAnswer((_) async => response);

        final result = await controller.fetchCities();

        expect(result, true);
        expect(controller.cities, isEmpty);
        expect(controller.isLoading, false);
        expect(controller.errorMessage, isNull);
      });
    });

    group('fetchFlights Tests', () {
      test('should fetch flights successfully', () async {
        final response = Response(
          data: {
            'data': [
              {
                'flight_date': '2024-01-15',
                'flight_status': 'scheduled',
                'departure': {
                  'airport': 'John F Kennedy International',
                  'iata': 'JFK',
                  'scheduled': '2024-01-15T13:00:00+00:00',
                },
                'arrival': {
                  'airport': 'Los Angeles International',
                  'iata': 'LAX',
                  'scheduled': '2024-01-15T16:00:00+00:00',
                },
                'airline': {
                  'name': 'Alaska Airlines',
                  'iata': 'AS',
                },
                'flight': {
                  'number': '1234',
                  'iata': 'AS1234',
                },
              }
            ]
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/flights'),
        );

        when(mockRepository.fetchFlights(
          departureCity: 'JFK',
          arrivalCity: 'LAX',
          departureDate: '2024-01-15',
        )).thenAnswer((_) async => response);

        controller.setFromCity(City(iataCode: 'JFK'));
        controller.setToCity(City(iataCode: 'LAX'));
        controller.setDepartureDate(DateTime(2024, 1, 15));

        final result = await controller.fetchFlights();

        expect(result, 'success');
        expect(controller.flights.length, 1);
        expect(controller.flights[0].flightDate, '2024-01-15');
        expect(controller.flights[0].flightStatus, 'scheduled');
        expect(controller.flights[0].departure?.iata, 'JFK');
        expect(controller.flights[0].arrival?.iata, 'LAX');
        expect(controller.isLoading, false);
        expect(controller.errorMessage, isNull);
      });

      test('should use mock data when API subscription limited', () async {
        when(mockRepository.fetchFlights(
          departureCity: 'JFK',
          arrivalCity: 'LAX',
          departureDate: '2024-01-15',
        )).thenThrow(Exception('function_access_restricted'));

        controller.setFromCity(City(iataCode: 'JFK'));
        controller.setToCity(City(iataCode: 'LAX'));
        controller.setDepartureDate(DateTime(2024, 1, 15));

        final result = await controller.fetchFlights();

        expect(result, 'mock_data');
        expect(controller.flights.length, 3); 
        expect(controller.isLoading, false);
        expect(controller.errorMessage, isNull);
      });

      test('should use mock data when API returns 403', () async {
        when(mockRepository.fetchFlights(
          departureCity: 'JFK',
          arrivalCity: 'LAX',
          departureDate: '2024-01-15',
        )).thenThrow(Exception('403'));

        controller.setFromCity(City(iataCode: 'JFK'));
        controller.setToCity(City(iataCode: 'LAX'));
        controller.setDepartureDate(DateTime(2024, 1, 15));

        final result = await controller.fetchFlights();

        expect(result, 'mock_data');
        expect(controller.flights.length, 3); 
        expect(controller.isLoading, false);
      });

      test('should use mock data when subscription error', () async {
        when(mockRepository.fetchFlights(
          departureCity: 'JFK',
          arrivalCity: 'LAX',
          departureDate: '2024-01-15',
        )).thenThrow(Exception('subscription'));

        controller.setFromCity(City(iataCode: 'JFK'));
        controller.setToCity(City(iataCode: 'LAX'));
        controller.setDepartureDate(DateTime(2024, 1, 15));

        final result = await controller.fetchFlights();

        expect(result, 'mock_data');
        expect(controller.flights.length, 3); 
        expect(controller.isLoading, false);
      });

      test('should handle fetch flights error response', () async {
        final response = Response(
          data: null,
          statusCode: 500,
          requestOptions: RequestOptions(path: '/flights'),
        );

        when(mockRepository.fetchFlights(
          departureCity: 'JFK',
          arrivalCity: 'LAX',
          departureDate: '2024-01-15',
        )).thenAnswer((_) async => response);

        controller.setFromCity(City(iataCode: 'JFK'));
        controller.setToCity(City(iataCode: 'LAX'));
        controller.setDepartureDate(DateTime(2024, 1, 15));

        final result = await controller.fetchFlights();

        expect(result, 'error');
        expect(controller.flights, isEmpty);
        expect(controller.isLoading, false);
        expect(controller.errorMessage, contains('Failed to fetch flights: 500'));
      });

      test('should handle fetch flights network exception', () async {
        when(mockRepository.fetchFlights(
          departureCity: 'JFK',
          arrivalCity: 'LAX',
          departureDate: '2024-01-15',
        )).thenThrow(Exception('Network error'));

        controller.setFromCity(City(iataCode: 'JFK'));
        controller.setToCity(City(iataCode: 'LAX'));
        controller.setDepartureDate(DateTime(2024, 1, 15));

        final result = await controller.fetchFlights();

        expect(result, isNull);
        expect(controller.flights, isEmpty);
        expect(controller.isLoading, false);
        expect(controller.errorMessage, contains('Error fetching flights'));
      });

      test('should handle empty flights response', () async {
        final response = Response(
          data: {'data': []},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/flights'),
        );

        when(mockRepository.fetchFlights(
          departureCity: 'JFK',
          arrivalCity: 'LAX',
          departureDate: '2024-01-15',
        )).thenAnswer((_) async => response);

        controller.setFromCity(City(iataCode: 'JFK'));
        controller.setToCity(City(iataCode: 'LAX'));
        controller.setDepartureDate(DateTime(2024, 1, 15));

        final result = await controller.fetchFlights();

        expect(result, 'success');
        expect(controller.flights, isEmpty);
        expect(controller.isLoading, false);
        expect(controller.errorMessage, isNull);
      });

      test('should handle null flights data', () async {
        final response = Response(
          data: {'data': null},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/flights'),
        );

        when(mockRepository.fetchFlights(
          departureCity: 'JFK',
          arrivalCity: 'LAX',
          departureDate: '2024-01-15',
        )).thenAnswer((_) async => response);

        controller.setFromCity(City(iataCode: 'JFK'));
        controller.setToCity(City(iataCode: 'LAX'));
        controller.setDepartureDate(DateTime(2024, 1, 15));

        final result = await controller.fetchFlights();

        expect(result, 'success');
        expect(controller.flights, isEmpty);
        expect(controller.isLoading, false);
        expect(controller.errorMessage, isNull);
      });

      test('should handle missing city codes', () async {
        final response = Response(
          data: {'data': []},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/flights'),
        );

        when(mockRepository.fetchFlights(
          departureCity: '',
          arrivalCity: '',
          departureDate: '2024-01-15',
        )).thenAnswer((_) async => response);

        controller.setFromCity(null);
        controller.setToCity(null);
        controller.setDepartureDate(DateTime(2024, 1, 15));

        final result = await controller.fetchFlights();

        expect(result, 'success');
        expect(controller.flights, isEmpty);
        expect(controller.isLoading, false);
      });

      test('should handle missing departure date', () async {
        final response = Response(
          data: {'data': []},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/flights'),
        );

        when(mockRepository.fetchFlights(
          departureCity: 'JFK',
          arrivalCity: 'LAX',
          departureDate: '',
        )).thenAnswer((_) async => response);

        controller.setFromCity(City(iataCode: 'JFK'));
        controller.setToCity(City(iataCode: 'LAX'));
        controller.setDepartureDate(null);

        final result = await controller.fetchFlights();

        expect(result, 'success');
        expect(controller.flights, isEmpty);
        expect(controller.isLoading, false);
      });
    });

    group('Mock Flights Tests', () {
      test('should generate mock flights with correct data', () async {
        when(mockRepository.fetchFlights(
          departureCity: 'JFK',
          arrivalCity: 'LAX',
          departureDate: '2024-01-15',
        )).thenThrow(Exception('function_access_restricted'));

        controller.setFromCity(City(iataCode: 'JFK'));
        controller.setToCity(City(iataCode: 'LAX'));
        controller.setDepartureDate(DateTime(2024, 1, 15));

        final result = await controller.fetchFlights();

        expect(result, 'mock_data');
        expect(controller.flights.length, 3);


        final firstFlight = controller.flights[0];
        expect(firstFlight.flightDate, '2024-01-15');
        expect(firstFlight.flightStatus, 'scheduled');
        expect(firstFlight.departure?.iata, 'JFK');
        expect(firstFlight.arrival?.iata, 'LAX');
        expect(firstFlight.airline?.name, 'Alaska Airlines');
        expect(firstFlight.flight?.number, '1234');


        final secondFlight = controller.flights[1];
        expect(secondFlight.airline?.name, 'American Airlines');
        expect(secondFlight.flight?.number, '171');


        final thirdFlight = controller.flights[2];
        expect(thirdFlight.airline?.name, 'Delta Air Lines');
        expect(thirdFlight.flight?.number, '2345');
      });

      test('should use default values when cities are null', () async {
        when(mockRepository.fetchFlights(
          departureCity: '',
          arrivalCity: '',
          departureDate: '2024-01-15',
        )).thenThrow(Exception('function_access_restricted'));

        controller.setFromCity(null);
        controller.setToCity(null);
        controller.setDepartureDate(DateTime(2024, 1, 15));

        final result = await controller.fetchFlights();

        expect(result, 'mock_data');
        expect(controller.flights.length, 3);


        final firstFlight = controller.flights[0];
        expect(firstFlight.departure?.iata, 'JFK');
        expect(firstFlight.arrival?.iata, 'LAX');
      });
    });

    group('Loading State Tests', () {
      test('should set loading state during fetchCities', () async {
        final response = Response(
          data: {'data': []},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/cities'),
        );

        when(mockRepository.fetchCities(offset: 0))
            .thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return response;
        });

        final future = controller.fetchCities();
        

        expect(controller.isLoading, true);
        
        await future;
        

        expect(controller.isLoading, false);
      });

      test('should set loading state during fetchFlights', () async {
        final response = Response(
          data: {'data': []},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/flights'),
        );

        when(mockRepository.fetchFlights(
          departureCity: 'JFK',
          arrivalCity: 'LAX',
          departureDate: '2024-01-15',
        )).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return response;
        });

        controller.setFromCity(City(iataCode: 'JFK'));
        controller.setToCity(City(iataCode: 'LAX'));
        controller.setDepartureDate(DateTime(2024, 1, 15));

        final future = controller.fetchFlights();
        
        expect(controller.isLoading, true);
        
        await future;
        
        expect(controller.isLoading, false);
      });
    });
  });
} 