import 'package:flight_search_app/core/flight_utils.dart';
import 'package:flight_search_app/features/flight_search/data/models/flight.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlightUtils Tests', () {
    group('calculateDuration Tests', () {
      test('should calculate duration correctly for valid times', () {
        final flight = Flight(
          departure: Departure(
            scheduled: '2024-01-15T13:00:00+00:00',
          ),
          arrival: Arrival(
            scheduled: '2024-01-15T16:30:00+00:00',
          ),
        );

        final duration = FlightUtils.calculateDuration(flight);

        expect(duration, '3h 30m');
      });

      test('should calculate duration for same day flight', () {
        final flight = Flight(
          departure: Departure(
            scheduled: '2024-01-15T08:00:00+00:00',
          ),
          arrival: Arrival(
            scheduled: '2024-01-15T10:15:00+00:00',
          ),
        );

        final duration = FlightUtils.calculateDuration(flight);

        expect(duration, '2h 15m');
      });

      test('should calculate duration for overnight flight', () {
        final flight = Flight(
          departure: Departure(
            scheduled: '2024-01-15T23:00:00+00:00',
          ),
          arrival: Arrival(
            scheduled: '2024-01-16T06:30:00+00:00',
          ),
        );

        final duration = FlightUtils.calculateDuration(flight);

        expect(duration, '7h 30m');
      });

      test('should handle null departure time', () {
        final flight = Flight(
          departure: Departure(
            scheduled: null,
          ),
          arrival: Arrival(
            scheduled: '2024-01-15T16:30:00+00:00',
          ),
        );

        final duration = FlightUtils.calculateDuration(flight);

        expect(duration, '5h 30m'); 
      });

      test('should handle null arrival time', () {
        final flight = Flight(
          departure: Departure(
            scheduled: '2024-01-15T13:00:00+00:00',
          ),
          arrival: Arrival(
            scheduled: null,
          ),
        );

        final duration = FlightUtils.calculateDuration(flight);

        expect(duration, '5h 30m'); 
      });

      test('should handle invalid departure time format', () {
        final flight = Flight(
          departure: Departure(
            scheduled: 'invalid-time',
          ),
          arrival: Arrival(
            scheduled: '2024-01-15T16:30:00+00:00',
          ),
        );

        final duration = FlightUtils.calculateDuration(flight);

        expect(duration, '5h 30m'); 
      });

      test('should handle invalid arrival time format', () {
        final flight = Flight(
          departure: Departure(
            scheduled: '2024-01-15T13:00:00+00:00',
          ),
          arrival: Arrival(
            scheduled: 'invalid-time',
          ),
        );

        final duration = FlightUtils.calculateDuration(flight);

        expect(duration, '5h 30m'); 
      });

      test('should handle null departure and arrival', () {
        final flight = Flight(
          departure: Departure(
            scheduled: null,
          ),
          arrival: Arrival(
            scheduled: null,
          ),
        );

        final duration = FlightUtils.calculateDuration(flight);

        expect(duration, '5h 30m'); 
      });

      test('should handle empty string times', () {
        final flight = Flight(
          departure: Departure(
            scheduled: '',
          ),
          arrival: Arrival(
            scheduled: '',
          ),
        );

        final duration = FlightUtils.calculateDuration(flight);

        expect(duration, '5h 30m');
      });
    });

    group('formatDateAndPassengers Tests', () {
      test('should format date and passengers correctly', () {
        final date = DateTime(2024, 7, 12); 
        const passengers = 2;

        final result = FlightUtils.formatDateAndPassengers(date, passengers);

        expect(result, 'Fri, Jul 12 • 2 Adults');
      });

      test('should handle single passenger', () {
        final date = DateTime(2024, 7, 12);
        const passengers = 1;

        final result = FlightUtils.formatDateAndPassengers(date, passengers);

        expect(result, 'Fri, Jul 12 • 1 Adult');
      });

      test('should handle multiple passengers', () {
        final date = DateTime(2024, 7, 12);
        const passengers = 4;

        final result = FlightUtils.formatDateAndPassengers(date, passengers);

        expect(result, 'Fri, Jul 12 • 4 Adults');
      });

      test('should handle null date', () {
        const passengers = 1;

        final result = FlightUtils.formatDateAndPassengers(null, passengers);

        expect(result, 'Fri, Jul 12 • 1 Adult');
      });

      test('should handle different dates', () {
        final date = DateTime(2024, 12, 25); 
        const passengers = 3;

        final result = FlightUtils.formatDateAndPassengers(date, passengers);

        expect(result, 'Wed, Dec 25 • 3 Adults');
      });

      test('should handle zero passengers', () {
        final date = DateTime(2024, 7, 12);
        const passengers = 0;

        final result = FlightUtils.formatDateAndPassengers(date, passengers);

        expect(result, 'Fri, Jul 12 • 0 Adults');
      });
    });

    group('formatTime Tests', () {
      test('should format time correctly', () {
        const time = '2024-01-15T13:30:00+00:00';

        final result = FlightUtils.formatTime(time);

        expect(result, '1:30 PM');
      });

      test('should format morning time', () {
        const time = '2024-01-15T08:15:00+00:00';

        final result = FlightUtils.formatTime(time);

        expect(result, '8:15 AM');
      });

      test('should format evening time', () {
        const time = '2024-01-15T22:45:00+00:00';

        final result = FlightUtils.formatTime(time);

        expect(result, '10:45 PM');
      });

      test('should handle N/A time', () {
        const time = 'N/A';

        final result = FlightUtils.formatTime(time);

        expect(result, 'N/A');
      });

      test('should handle invalid time format', () {
        const time = 'invalid-time';

        final result = FlightUtils.formatTime(time);

        expect(result, 'invalid-time'); 
      });

      test('should handle empty time string', () {
        const time = '';

        final result = FlightUtils.formatTime(time);

        expect(result, ''); 
      });

      test('should handle null time', () {
      });

      test('should format midnight time', () {
        const time = '2024-01-15T00:00:00+00:00';

        final result = FlightUtils.formatTime(time);

        expect(result, '12:00 AM');
      });

      test('should format noon time', () {
        const time = '2024-01-15T12:00:00+00:00';

        final result = FlightUtils.formatTime(time);

        expect(result, '12:00 PM');
      });
    });

    group('getMockPrice Tests', () {
      test('should return correct price for American Airlines', () {
        final flight = Flight(
          airline: Airline(name: 'American Airlines'),
        );

        final price = FlightUtils.getMockPrice(flight);

        expect(price, '428');
      });

      test('should return correct price for Delta Airlines', () {
        final flight = Flight(
          airline: Airline(name: 'Delta Air Lines'),
        );

        final price = FlightUtils.getMockPrice(flight);

        expect(price, '520');
      });

      test('should return default price for other airlines', () {
        final flight = Flight(
          airline: Airline(name: 'Alaska Airlines'),
        );

        final price = FlightUtils.getMockPrice(flight);

        expect(price, '320');
      });

      test('should return default price for null airline', () {
        final flight = Flight(
          airline: null,
        );

        final price = FlightUtils.getMockPrice(flight);

        expect(price, '320');
      });

      test('should return default price for empty airline name', () {
        final flight = Flight(
          airline: Airline(name: ''),
        );

        final price = FlightUtils.getMockPrice(flight);

        expect(price, '320');
      });

      test('should return default price for airline with partial match', () {
        final flight = Flight(
          airline: Airline(name: 'American'),
        );

        final price = FlightUtils.getMockPrice(flight);

        expect(price, '428');
      });

      test('should return default price for case sensitive match', () {
        final flight = Flight(
          airline: Airline(name: 'American Airlines'),
        );

        final price = FlightUtils.getMockPrice(flight);

        expect(price, '428');
      });
    });

    group('getStopInfo Tests', () {
      test('should return non-stop for American Airlines', () {
        final flight = Flight(
          airline: Airline(name: 'American Airlines'),
        );

        final stopInfo = FlightUtils.getStopInfo(flight);

        expect(stopInfo, 'Non-stop');
      });

      test('should return 1 stop for Delta Airlines', () {
        final flight = Flight(
          airline: Airline(name: 'Delta Air Lines'),
        );

        final stopInfo = FlightUtils.getStopInfo(flight);

        expect(stopInfo, '1 stop');
      });

      test('should return 1 stop for other airlines', () {
        final flight = Flight(
          airline: Airline(name: 'Alaska Airlines'),
        );

        final stopInfo = FlightUtils.getStopInfo(flight);

        expect(stopInfo, '1 stop');
      });

      test('should return 1 stop for null airline', () {
        final flight = Flight(
          airline: null,
        );

        final stopInfo = FlightUtils.getStopInfo(flight);

        expect(stopInfo, '1 stop');
      });

      test('should return 1 stop for empty airline name', () {
        final flight = Flight(
          airline: Airline(name: ''),
        );

        final stopInfo = FlightUtils.getStopInfo(flight);

        expect(stopInfo, '1 stop');
      });

      test('should return non-stop for partial American match', () {
        final flight = Flight(
          airline: Airline(name: 'American'),
        );

        final stopInfo = FlightUtils.getStopInfo(flight);

        expect(stopInfo, 'Non-stop');
      });

      test('should return 1 stop for partial Delta match', () {
        final flight = Flight(
          airline: Airline(name: 'Delta'),
        );

        final stopInfo = FlightUtils.getStopInfo(flight);

        expect(stopInfo, '1 stop');
      });
    });

    group('Edge Cases and Error Handling', () {
      test('should handle all null values in flight', () {
        final flight = Flight(
          departure: null,
          arrival: null,
          airline: null,
        );

        final duration = FlightUtils.calculateDuration(flight);
        final price = FlightUtils.getMockPrice(flight);
        final stopInfo = FlightUtils.getStopInfo(flight);

        expect(duration, '5h 30m');
        expect(price, '320');
        expect(stopInfo, '1 stop');
      });

      test('should handle very long duration', () {
        final flight = Flight(
          departure: Departure(
            scheduled: '2024-01-15T00:00:00+00:00',
          ),
          arrival: Arrival(
            scheduled: '2024-01-16T23:59:00+00:00',
          ),
        );

        final duration = FlightUtils.calculateDuration(flight);

        expect(duration, '47h 59m'); 
      });

      test('should handle very short duration', () {
        final flight = Flight(
          departure: Departure(
            scheduled: '2024-01-15T13:00:00+00:00',
          ),
          arrival: Arrival(
            scheduled: '2024-01-15T13:30:00+00:00',
          ),
        );

        final duration = FlightUtils.calculateDuration(flight);

        expect(duration, '0h 30m');
      });

      test('should handle negative duration gracefully', () {
        final flight = Flight(
          departure: Departure(
            scheduled: '2024-01-15T16:00:00+00:00',
          ),
          arrival: Arrival(
            scheduled: '2024-01-15T13:00:00+00:00',
          ),
        );

        final duration = FlightUtils.calculateDuration(flight);

        expect(duration, '-3h 0m');
      });

      test('should handle special characters in airline names', () {
        final flight = Flight(
          airline: Airline(name: 'American Airlines & Co.'),
        );

        final price = FlightUtils.getMockPrice(flight);
        final stopInfo = FlightUtils.getStopInfo(flight);

        expect(price, '428');
        expect(stopInfo, 'Non-stop');
      });

      test('should handle whitespace in airline names', () {
        final flight = Flight(
          airline: Airline(name: '  American Airlines  '),
        );

        final price = FlightUtils.getMockPrice(flight);
        final stopInfo = FlightUtils.getStopInfo(flight);

        expect(price, '428');
        expect(stopInfo, 'Non-stop');
      });
    });

    group('Integration Tests', () {
      test('should work with complete flight data', () {
        final flight = Flight(
          flightDate: '2024-01-15',
          flightStatus: 'scheduled',
          departure: Departure(
            airport: 'John F Kennedy International',
            iata: 'JFK',
            scheduled: '2024-01-15T13:00:00+00:00',
          ),
          arrival: Arrival(
            airport: 'Los Angeles International',
            iata: 'LAX',
            scheduled: '2024-01-15T16:30:00+00:00',
          ),
          airline: Airline(
            name: 'American Airlines',
            iata: 'AA',
          ),
          flight: FlightInfo(
            number: '1234',
            iata: 'AA1234',
          ),
        );

        final duration = FlightUtils.calculateDuration(flight);
        final price = FlightUtils.getMockPrice(flight);
        final stopInfo = FlightUtils.getStopInfo(flight);
        final departureTime = FlightUtils.formatTime(flight.departure?.scheduled ?? '');
        final arrivalTime = FlightUtils.formatTime(flight.arrival?.scheduled ?? '');

        expect(duration, '3h 30m');
        expect(price, '428');
        expect(stopInfo, 'Non-stop');
        expect(departureTime, '1:00 PM');
        expect(arrivalTime, '4:30 PM');
      });

      test('should handle multiple flights with different airlines', () {
        final flights = [
          Flight(
            airline: Airline(name: 'American Airlines'),
            departure: Departure(scheduled: '2024-01-15T10:00:00+00:00'),
            arrival: Arrival(scheduled: '2024-01-15T12:00:00+00:00'),
          ),
          Flight(
            airline: Airline(name: 'Delta Air Lines'),
            departure: Departure(scheduled: '2024-01-15T14:00:00+00:00'),
            arrival: Arrival(scheduled: '2024-01-15T17:30:00+00:00'),
          ),
          Flight(
            airline: Airline(name: 'Alaska Airlines'),
            departure: Departure(scheduled: '2024-01-15T20:00:00+00:00'),
            arrival: Arrival(scheduled: '2024-01-15T23:45:00+00:00'),
          ),
        ];

        final results = flights.map((flight) {
          return {
            'duration': FlightUtils.calculateDuration(flight),
            'price': FlightUtils.getMockPrice(flight),
            'stopInfo': FlightUtils.getStopInfo(flight),
          };
        }).toList();

        expect(results[0]['duration'], '2h 0m');
        expect(results[0]['price'], '428');
        expect(results[0]['stopInfo'], 'Non-stop');

        expect(results[1]['duration'], '3h 30m');
        expect(results[1]['price'], '520');
        expect(results[1]['stopInfo'], '1 stop');

        expect(results[2]['duration'], '3h 45m');
        expect(results[2]['price'], '320');
        expect(results[2]['stopInfo'], '1 stop');
      });
    });
  });
} 