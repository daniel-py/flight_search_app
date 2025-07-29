import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/flights_datasource.dart';
import '../domain/flights_repository.dart';
import 'flights_controller.dart';

final flightsProvider = ChangeNotifierProvider((ref) {
  final dataSource = FlightsDataSource();
  final repository = FlightsRepositoryImpl(dataSource);
  return FlightsController(repository);
}); 