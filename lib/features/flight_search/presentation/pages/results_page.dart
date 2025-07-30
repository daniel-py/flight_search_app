import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/flight_utils.dart';
import '../../data/models/flight.dart';
import '../providers/providers.dart';
import 'flight_details_page.dart';

class ResultsPage extends ConsumerStatefulWidget {
  const ResultsPage({super.key});

  @override
  ConsumerState<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends ConsumerState<ResultsPage> with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _cardController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  Widget build(BuildContext context) {
    final flightsController = ref.watch(flightsProvider);
    final flights = flightsController.flights;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: const Text(
            'Flights',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
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
            child: flightsController.isLoading
                ? const Center(child: CircularProgressIndicator())
                : flights.isEmpty
                    ? const Center(
                        child: Text(
                          'No flights found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildSearchSummary(ref),
                          _buildSortFilterSection(),
                          Expanded(
                            child: _buildFlightResults(context, flights),
                          ),
                        ],
                      ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.98,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutBack,
    ));

    // Start entrance animation
    _entranceController.forward();
  }

  Widget _buildFlightCard(BuildContext context, Flight flight, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlightDetailsPage(flight: flight),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFF1A5F7A)
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8EDF5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '\$${_getMockPrice(flight)} • Economy',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
                    _getStopInfo(flight),
                    style: const TextStyle(
                     color: Color(0xFF4A739C),
                fontWeight: FontWeight.w400,
                fontSize: 14,
                    ),
                  ),
            
            Text(
              flight.airline?.name ?? 'Unknown',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              "${flight.departure?.iata} ${FlightUtils.formatTime(flight.departure?.scheduled ?? 'N/A')} • ${flight.arrival?.iata} ${FlightUtils.formatTime(flight.arrival?.scheduled ?? 'N/A')} • ${FlightUtils.calculateDuration(flight)}",
              style: const TextStyle(
                color: Color(0xFF4A739C),
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightResults(BuildContext context, List<Flight> flights) {
    final pageController = PageController();

    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(maxHeight: 270, minHeight: 200),
          child: PageView.builder(
            controller: pageController,
            itemCount: flights.length,
            itemBuilder: (context, index) {
              final flight = flights[index];
              return _buildFlightCard(context, flight, index);
            },
          ),
        ),

        SmoothPageIndicator(
          controller: pageController,
          count: flights.length,
          effect: const ScrollingDotsEffect(
            dotColor: Colors.grey,
            fixedCenter: true,
            activeDotColor: Colors.blue,
            dotHeight: 8,
            dotWidth: 8,
            spacing: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchSummary(WidgetRef ref) {
    final flightsController = ref.watch(flightsProvider);
    final fromCity = flightsController.fromCity;
    final toCity = flightsController.toCity;
    final departureDate = flightsController.departureDate;
    final passengers = flightsController.passengers;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fromCity?.iataCode ?? 'JFK',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      fromCity?.cityName ?? 'New York',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4A739C),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Transform.rotate(
                  angle: 1.5708,
                  child: Icon(
                    Icons.flight,
                    color: Colors.grey[700],
                    size: 24,
                  ),
                ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      toCity?.iataCode ?? 'LAX',
                      style:  TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      toCity?.cityName ?? 'Los Angeles',
                      style: const TextStyle(
                          fontSize: 14,
                        color: Color(0xFF4A739C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            FlightUtils.formatDateAndPassengers(departureDate, passengers),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortFilterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            'Sort & Filter',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey[800],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.tune,
              color: Colors.grey[700],
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  String _getMockPrice(Flight flight) {
    return FlightUtils.getMockPrice(flight);
  }

  String _getStopInfo(Flight flight) {
    return FlightUtils.getStopInfo(flight);
  }
}
