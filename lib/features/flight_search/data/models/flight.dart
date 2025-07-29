import 'dart:convert';

class Aircraft {
  final String? registration;
  final String? iata;
  final String? icao;
  final String? icao24;

  Aircraft({
    this.registration,
    this.iata,
    this.icao,
    this.icao24,
  });

  factory Aircraft.fromJson(Map<String, dynamic> json) {
    return Aircraft(
      registration: json['registration'],
      iata: json['iata'],
      icao: json['icao'],
      icao24: json['icao24'],
    );
  }

  @override
  int get hashCode {
    return registration.hashCode ^ iata.hashCode ^ icao.hashCode ^ icao24.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Aircraft &&
        other.registration == registration &&
        other.iata == iata &&
        other.icao == icao &&
        other.icao24 == icao24;
  }

  Map<String, dynamic> toJson() {
    return {
      'registration': registration,
      'iata': iata,
      'icao': icao,
      'icao24': icao24,
    };
  }
}

class Airline {
  final String? name;
  final String? iata;
  final String? icao;

  Airline({
    this.name,
    this.iata,
    this.icao,
  });

  factory Airline.fromJson(Map<String, dynamic> json) {
    return Airline(
      name: json['name'],
      iata: json['iata'],
      icao: json['icao'],
    );
  }

  @override
  int get hashCode {
    return name.hashCode ^ iata.hashCode ^ icao.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Airline &&
        other.name == name &&
        other.iata == iata &&
        other.icao == icao;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'iata': iata,
      'icao': icao,
    };
  }
}

class Arrival {
  final String? airport;
  final String? timezone;
  final String? iata;
  final String? icao;
  final String? terminal;
  final String? gate;
  final String? baggage;
  final int? delay;
  final String? scheduled;
  final String? estimated;
  final String? actual;
  final String? estimatedRunway;
  final String? actualRunway;

  Arrival({
    this.airport,
    this.timezone,
    this.iata,
    this.icao,
    this.terminal,
    this.gate,
    this.baggage,
    this.delay,
    this.scheduled,
    this.estimated,
    this.actual,
    this.estimatedRunway,
    this.actualRunway,
  });

  factory Arrival.fromJson(Map<String, dynamic> json) {
    return Arrival(
      airport: json['airport'],
      timezone: json['timezone'],
      iata: json['iata'],
      icao: json['icao'],
      terminal: json['terminal'],
      gate: json['gate'],
      baggage: json['baggage'],
      delay: json['delay'],
      scheduled: json['scheduled'],
      estimated: json['estimated'],
      actual: json['actual'],
      estimatedRunway: json['estimated_runway'],
      actualRunway: json['actual_runway'],
    );
  }

  @override
  int get hashCode {
    return airport.hashCode ^
        timezone.hashCode ^
        iata.hashCode ^
        icao.hashCode ^
        terminal.hashCode ^
        gate.hashCode ^
        baggage.hashCode ^
        delay.hashCode ^
        scheduled.hashCode ^
        estimated.hashCode ^
        actual.hashCode ^
        estimatedRunway.hashCode ^
        actualRunway.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Arrival &&
        other.airport == airport &&
        other.timezone == timezone &&
        other.iata == iata &&
        other.icao == icao &&
        other.terminal == terminal &&
        other.gate == gate &&
        other.baggage == baggage &&
        other.delay == delay &&
        other.scheduled == scheduled &&
        other.estimated == estimated &&
        other.actual == actual &&
        other.estimatedRunway == estimatedRunway &&
        other.actualRunway == actualRunway;
  }

  Map<String, dynamic> toJson() {
    return {
      'airport': airport,
      'timezone': timezone,
      'iata': iata,
      'icao': icao,
      'terminal': terminal,
      'gate': gate,
      'baggage': baggage,
      'delay': delay,
      'scheduled': scheduled,
      'estimated': estimated,
      'actual': actual,
      'estimated_runway': estimatedRunway,
      'actual_runway': actualRunway,
    };
  }
}

class Departure {
  final String? airport;
  final String? timezone;
  final String? iata;
  final String? icao;
  final String? terminal;
  final String? gate;
  final int? delay;
  final String? scheduled;
  final String? estimated;
  final String? actual;
  final String? estimatedRunway;
  final String? actualRunway;

  Departure({
    this.airport,
    this.timezone,
    this.iata,
    this.icao,
    this.terminal,
    this.gate,
    this.delay,
    this.scheduled,
    this.estimated,
    this.actual,
    this.estimatedRunway,
    this.actualRunway,
  });

  factory Departure.fromJson(Map<String, dynamic> json) {
    return Departure(
      airport: json['airport'],
      timezone: json['timezone'],
      iata: json['iata'],
      icao: json['icao'],
      terminal: json['terminal'],
      gate: json['gate'],
      delay: json['delay'],
      scheduled: json['scheduled'],
      estimated: json['estimated'],
      actual: json['actual'],
      estimatedRunway: json['estimated_runway'],
      actualRunway: json['actual_runway'],
    );
  }

  @override
  int get hashCode {
    return airport.hashCode ^
        timezone.hashCode ^
        iata.hashCode ^
        icao.hashCode ^
        terminal.hashCode ^
        gate.hashCode ^
        delay.hashCode ^
        scheduled.hashCode ^
        estimated.hashCode ^
        actual.hashCode ^
        estimatedRunway.hashCode ^
        actualRunway.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Departure &&
        other.airport == airport &&
        other.timezone == timezone &&
        other.iata == iata &&
        other.icao == icao &&
        other.terminal == terminal &&
        other.gate == gate &&
        other.delay == delay &&
        other.scheduled == scheduled &&
        other.estimated == estimated &&
        other.actual == actual &&
        other.estimatedRunway == estimatedRunway &&
        other.actualRunway == actualRunway;
  }

  Map<String, dynamic> toJson() {
    return {
      'airport': airport,
      'timezone': timezone,
      'iata': iata,
      'icao': icao,
      'terminal': terminal,
      'gate': gate,
      'delay': delay,
      'scheduled': scheduled,
      'estimated': estimated,
      'actual': actual,
      'estimated_runway': estimatedRunway,
      'actual_runway': actualRunway,
    };
  }
}

class Flight {
  final String? flightDate;
  final String? flightStatus;
  final Departure? departure;
  final Arrival? arrival;
  final Airline? airline;
  final FlightInfo? flight;
  final Aircraft? aircraft;
  final Live? live;

  Flight({
    this.flightDate,
    this.flightStatus,
    this.departure,
    this.arrival,
    this.airline,
    this.flight,
    this.aircraft,
    this.live,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      flightDate: json['flight_date'],
      flightStatus: json['flight_status'],
      departure: json['departure'] != null ? Departure.fromJson(json['departure']) : null,
      arrival: json['arrival'] != null ? Arrival.fromJson(json['arrival']) : null,
      airline: json['airline'] != null ? Airline.fromJson(json['airline']) : null,
      flight: json['flight'] != null ? FlightInfo.fromJson(json['flight']) : null,
      aircraft: json['aircraft'] != null ? Aircraft.fromJson(json['aircraft']) : null,
      live: json['live'] != null ? Live.fromJson(json['live']) : null,
    );
  }

  @override
  int get hashCode {
    return flightDate.hashCode ^
        flightStatus.hashCode ^
        departure.hashCode ^
        arrival.hashCode ^
        airline.hashCode ^
        flight.hashCode ^
        aircraft.hashCode ^
        live.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Flight &&
        other.flightDate == flightDate &&
        other.flightStatus == flightStatus &&
        other.departure == departure &&
        other.arrival == arrival &&
        other.airline == airline &&
        other.flight == flight &&
        other.aircraft == aircraft &&
        other.live == live;
  }

  String encode() {
    return toJson().toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'flight_date': flightDate,
      'flight_status': flightStatus,
      'departure': departure?.toJson(),
      'arrival': arrival?.toJson(),
      'airline': airline?.toJson(),
      'flight': flight?.toJson(),
      'aircraft': aircraft?.toJson(),
      'live': live?.toJson(),
    };
  }

  static Flight decode(String encoded) {
    try {
      final Map<String, dynamic> json = jsonDecode(encoded);
      return Flight.fromJson(json);
    } catch (e) {
      throw Exception('Failed to decode Flight: $e');
    }
  }
}

class FlightInfo {
  final String? number;
  final String? iata;
  final String? icao;
  final String? codeshared;

  FlightInfo({
    this.number,
    this.iata,
    this.icao,
    this.codeshared,
  });

  factory FlightInfo.fromJson(Map<String, dynamic> json) {
    return FlightInfo(
      number: json['number'],
      iata: json['iata'],
      icao: json['icao'],
      codeshared: json['codeshared'],
    );
  }

  @override
  int get hashCode {
    return number.hashCode ^ iata.hashCode ^ icao.hashCode ^ codeshared.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlightInfo &&
        other.number == number &&
        other.iata == iata &&
        other.icao == icao &&
        other.codeshared == codeshared;
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'iata': iata,
      'icao': icao,
      'codeshared': codeshared,
    };
  }
}

class Live {
  final String? updated;
  final double? latitude;
  final double? longitude;
  final double? altitude;
  final double? direction;
  final double? speedHorizontal;
  final double? speedVertical;
  final bool? isGround;

  Live({
    this.updated,
    this.latitude,
    this.longitude,
    this.altitude,
    this.direction,
    this.speedHorizontal,
    this.speedVertical,
    this.isGround,
  });

  factory Live.fromJson(Map<String, dynamic> json) {
    return Live(
      updated: json['updated'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      altitude: json['altitude']?.toDouble(),
      direction: json['direction']?.toDouble(),
      speedHorizontal: json['speed_horizontal']?.toDouble(),
      speedVertical: json['speed_vertical']?.toDouble(),
      isGround: json['is_ground'],
    );
  }

  @override
  int get hashCode {
    return updated.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        altitude.hashCode ^
        direction.hashCode ^
        speedHorizontal.hashCode ^
        speedVertical.hashCode ^
        isGround.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Live &&
        other.updated == updated &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.altitude == altitude &&
        other.direction == direction &&
        other.speedHorizontal == speedHorizontal &&
        other.speedVertical == speedVertical &&
        other.isGround == isGround;
  }

  Map<String, dynamic> toJson() {
    return {
      'updated': updated,
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'direction': direction,
      'speed_horizontal': speedHorizontal,
      'speed_vertical': speedVertical,
      'is_ground': isGround,
    };
  }
} 