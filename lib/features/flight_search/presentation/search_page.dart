import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/city.dart';
import 'providers.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  String _selectedTripType = 'One way';
  bool _directFlightsOnly = false;
  bool _includeNearbyAirports = false;
  final String _travelClass = 'Economy';
  final int _passengers = 1;
  City? _selectedFromCity;
  City? _selectedToCity;
  DateTime? _selectedDepartureDate;

  final List<String> _tripTypes = ['One way', 'Round trip', 'Multi-City'];

  @override
  Widget build(BuildContext context) {
    final flightsController = ref.watch(flightsProvider);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, automaticallyImplyLeading: false,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: const Text(
          'Search Flights',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLocationFields(flightsController),
            const SizedBox(height: 24),
            _buildTripTypeSelector(),
            const SizedBox(height: 24),
            _buildDepartureDateField(),
            const SizedBox(height: 32),
            _buildOptionalFilters(),
            const SizedBox(height: 40),
            _buildSearchButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartureDateField() {
    return GestureDetector(
      onTap: () {
        final now = DateTime.now();
        final initialDate = _selectedDepartureDate ?? now;
        
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
                            if (_selectedDepartureDate == null) {
                              setState(() {
                                _selectedDepartureDate = now;
                              });
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
                        setState(() {
                          _selectedDepartureDate = newDate;
                        });
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedDepartureDate != null
                    ? '${_selectedDepartureDate!.year}-${_selectedDepartureDate!.month.toString().padLeft(2, '0')}-${_selectedDepartureDate!.day.toString().padLeft(2, '0')}'
                    : 'Departure Date',
                style: TextStyle(
                  color: _selectedDepartureDate != null ? Colors.black : Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow(String label, bool? isSwitch, Function(bool)? onChanged, {String? value}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
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
      itemAsString: (City city) => '${city.cityName} (${city.iataCode})',
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue),
          ),
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

  Widget _buildLocationFields(flightsController) {
    return Column(
      children: [
        _buildLocationField(
          'From',
          Icons.flight_takeoff,
          _selectedFromCity,
          (City? city) {
            setState(() {
              _selectedFromCity = city;
            });
          },
          flightsController,
        ),
        const SizedBox(height: 16),
        _buildLocationField(
          'To',
          Icons.flight_land,
          _selectedToCity,
          (City? city) {
            setState(() {
              _selectedToCity = city;
            });
          },
          flightsController,
        ),
      ],
    );
  }

  Widget _buildOptionalFilters() {
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
        _buildFilterRow('Direct Flights Only', _directFlightsOnly, (value) {
          setState(() {
            _directFlightsOnly = value;
          });
        }),
        const SizedBox(height: 12),
        _buildFilterRow('Include Nearby Airports', _includeNearbyAirports, (value) {
          setState(() {
            _includeNearbyAirports = value;
          });
        }),
        const SizedBox(height: 12),
        _buildFilterRow('Travel Class', null, null, value: _travelClass),
        const SizedBox(height: 12),
        _buildFilterRow('Passengers', null, null, value: _passengers.toString()),
      ],
    );
  }

  Widget _buildSearchButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Implement search functionality
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Search Flights',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTripTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: _tripTypes.map((type) {
          final isSelected = type == _selectedTripType;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTripType = type;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
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
                    color: isSelected ? Colors.black : Colors.grey[600],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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
