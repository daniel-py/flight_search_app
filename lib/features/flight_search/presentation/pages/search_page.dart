import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../../data/models/city.dart';
import '../providers/providers.dart';
import 'results_page.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _staggerController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  Widget build(BuildContext context) {
    final flightsController = ref.watch(flightsProvider);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: const Text(
              'Search Flights',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLocationFields(flightsController, ref),
                  const SizedBox(height: 24),
                  _buildTripTypeSelector(flightsController),
                  const SizedBox(height: 24),
                  _buildDepartureDateField(flightsController, context),
                  const SizedBox(height: 32),
                  _buildOptionalFilters(flightsController),
                  const SizedBox(height: 40),
                  _buildSearchButton(flightsController, ref, context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutBack,
    ));

    _entranceController.forward();
  }

  Widget _buildDepartureDateField(flightsController, BuildContext context) {
    return GestureDetector(
      onTap: () {
        final now = DateTime.now();
        final initialDate = flightsController.departureDate ?? now;
        
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 300,
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: 50,
                    color: Colors.grey[200],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                          child: const Text('Cancel'),
                          onPressed: () => Navigator.pop(context),
                        ),
                        CupertinoButton(
                          child: const Text('Done'),
                          onPressed: () {
                            if (flightsController.departureDate == null) {
                              flightsController.setDepartureDate(now);
                            }
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: initialDate.isBefore(now) ? now : initialDate,
                      minimumDate: now,
                      onDateTimeChanged: (DateTime newDate) {
                        flightsController.setDepartureDate(newDate);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFE8EDF5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              flightsController.departureDate != null
                  ? '${flightsController.departureDate!.year}-${flightsController.departureDate!.month.toString().padLeft(2, '0')}-${flightsController.departureDate!.day.toString().padLeft(2, '0')}'
                  : 'Departure Date',
              style: TextStyle(
                color: flightsController.departureDate != null ? Colors.black : const Color(0xFF4A739C),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow(String label, bool? isSwitch, Function(bool)? onChanged, {String? value}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          if (isSwitch != null)
            Switch(
              value: isSwitch,
              onChanged: onChanged,
              activeColor: Colors.blue,
              inactiveTrackColor: const Color(0xFFE8EDF5),
              activeTrackColor: Colors.blue,
              thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return Colors.white;
              }),
              trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
                return Colors.transparent;
              }),
            )
          else if (value != null)
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLocationField(
    String label,
    IconData icon,
    City? selectedCity,
    Function(City?) onChanged,
    flightsController,
    WidgetRef ref,
  ) {
    return DropdownSearch<City>(
      asyncItems: (String filter) async {
        if (flightsController.cities.isEmpty) {
          await ref.read(flightsProvider).fetchCities();
        }
        return flightsController.cities.where((city) {
          final searchTerm = filter.toLowerCase();
          return city.cityName?.toLowerCase().contains(searchTerm) == true ||
                 city.iataCode?.toLowerCase().contains(searchTerm) == true ||
                 city.countryIso2?.toLowerCase().contains(searchTerm) == true;
        }).toList();
      },
      selectedItem: selectedCity,
      onChanged: onChanged,
      itemAsString: (City city) => '${city.cityName} (${city.countryIso2})',
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: label,
            contentPadding: const EdgeInsets.all(16),
            labelStyle: const TextStyle(fontSize: 16, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE8EDF5)),
            ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue),
          ),
            filled: true,
            fillColor: const Color(0xFFE8EDF5)
        ),
      ),
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: 'Search cities...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        constraints: const BoxConstraints(maxHeight: 300),
      ),
    );
  }

  Widget _buildLocationFields(flightsController, WidgetRef ref) {
    return Column(
      children: [
        _buildLocationField(
          'From',
          Icons.flight_takeoff,
          flightsController.fromCity,
          (City? city) {
            flightsController.setFromCity(city);
          },
          flightsController,
          ref,
        ),
        const SizedBox(height: 16),
        _buildLocationField(
          'To',
          Icons.flight_land,
          flightsController.toCity,
          (City? city) {
            flightsController.setToCity(city);
          },
          flightsController,
          ref,
        ),
      ],
    );
  }

  Widget _buildOptionalFilters(flightsController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Optional Filters',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        _buildFilterRow('Direct Flights Only', flightsController.directFlightsOnly, (value) {
          flightsController.setDirectFlightsOnly(value);
        }),
        _buildFilterRow('Include Nearby Airports', flightsController.includeNearbyAirports, (value) {
          flightsController.setIncludeNearbyAirports(value);
        }),
        const SizedBox(height: 14),
        _buildFilterRow('Travel Class', null, null, value: flightsController.travelClass),
        const SizedBox(height: 20),
        _buildFilterRow('Passengers', null, null, value: flightsController.passengers.toString()),
      ],
    );
  }

  Widget _buildSearchButton(flightsController, WidgetRef ref, BuildContext context) {
    final isFormValid = flightsController.fromCity != null && 
                       flightsController.toCity != null && 
                       flightsController.departureDate != null &&
                       flightsController.fromCity != flightsController.toCity;
    
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isFormValid
            ? () async {
                final navigatorContext = context;
                SmartDialog.showLoading();
                try {
                  final result = await ref.read(flightsProvider).fetchFlights();
                  SmartDialog.dismiss();

                  if (result == 'success') {
                    Navigator.push(
                      navigatorContext,
                      MaterialPageRoute(
                        builder: (context) => const ResultsPage(),
                      ),
                    );
                  } else if (result == 'mock_data') {
                    SmartDialog.showToast("Using mock data due to subscription limitation");
                    Navigator.push(
                      navigatorContext,
                      MaterialPageRoute(
                        builder: (context) => const ResultsPage(),
                      ),
                    );
                  } else {
                    SmartDialog.showToast('Failed to fetch flights. Please try again.');
                  }
                } catch (e) {
                  SmartDialog.dismiss();
                  String errorMessage = 'An error occurred while searching flights.';

                  SmartDialog.showToast(errorMessage);
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Search Flights',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildTripTypeSelector(flightsController) {
    final tripTypes = ['One way', 'Round trip', 'Multi-City'];
    
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEBEDF2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: tripTypes.map((type) {
          final isSelected = type == flightsController.tripType;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                flightsController.setTripType(type);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  type,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.black : const Color(0xFF5C738A),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
