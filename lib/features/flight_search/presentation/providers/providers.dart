import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/flights_datasource.dart';
import '../../data/repositories/flights_repository_impl.dart';
import '../../domain/controllers/flights_controller.dart';

final flightsProvider = ChangeNotifierProvider((ref) {
  final dataSource = FlightsDataSource();
  final repository = FlightsRepositoryImpl(dataSource);
  return FlightsController(repository);
}); 