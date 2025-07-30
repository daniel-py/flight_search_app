import 'package:intl/intl.dart';

import '../features/flight_search/data/models/flight.dart';

class FlightUtils {
  static String calculateDuration(Flight flight) {
    try {
      final departure = DateTime.parse(flight.departure?.scheduled ?? '');
      final arrival = DateTime.parse(flight.arrival?.scheduled ?? '');
      final duration = arrival.difference(departure);
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      return '${hours}h ${minutes}m';
    } catch (e) {
      return '5h 30m';
    }
  }

  static String formatDateAndPassengers(DateTime? date, int passengers) {
    if (date == null) return 'Fri, Jul 12 • 1 Adult';

    final dateFormat = DateFormat('E, MMM d', 'en_US');
    final formattedDate = dateFormat.format(date);

    final passengerText = passengers == 1 ? 'Adult' : 'Adults';

    return '$formattedDate • $passengers $passengerText';
  }

  static String formatTime(String time) {
    if (time == 'N/A') return 'N/A';
    try {
      final dateTime = DateTime.parse(time);
      final timeFormat = DateFormat('h:mm a', 'en_US');
      return timeFormat.format(dateTime);
    } catch (e) {
      return time;
    }
  }

  static String getMockPrice(Flight flight) {
    // Generate mock prices based on airline
    final airline = flight.airline?.name ?? '';
    if (airline.contains('American')) return '428';
    if (airline.contains('Delta')) return '520';
    return '320';
  }

  static String getStopInfo(Flight flight) {
    final airline = flight.airline?.name ?? '';
    if (airline.contains('American')) return 'Non-stop';
    if (airline.contains('Delta')) return '1 stop';
    return '1 stop';
  }
} 