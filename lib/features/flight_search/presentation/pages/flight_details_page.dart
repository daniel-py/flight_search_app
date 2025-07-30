import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/flight_utils.dart';
import '../../data/models/flight.dart';

class FlightDetailsPage extends ConsumerWidget {
  final Flight flight;

  const FlightDetailsPage({
    super.key,
    required this.flight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Flight Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFlightDetailsSection(),
            const SizedBox(height: 24),
            _buildFlightInformationSection(),
            const SizedBox(height: 24),
            _buildMapSection(),
            const SizedBox(height: 24),
            _buildBaggageInformationSection(),
            const SizedBox(height: 24),
            _buildPoliciesSection(),
            const SizedBox(height: 24),
            _buildAmenitiesSection(),
            const SizedBox(height: 24),
            _buildBottomButton()
          ],
        ),
      ),
    );
  }

  Widget _buildAmenitiesSection() {
    return _buildSection(
      'Amenities',
      [
        _buildDetailItem(
          Icons.monitor,
          'In-flight Entertainment',
          '',
        ),
        _buildDetailItem(
          Icons.wifi,
          'Wi-Fi',
          '',
        ),
        _buildDetailItem(
          Icons.restaurant,
          'Meals',
          '',
        ),
      ],
    );
  }

  Widget _buildBaggageInformationSection() {
    return _buildSection(
      'Baggage Information',
      [
        _buildDetailItem(
          Icons.luggage,
          'Checked Baggage',
          "${flight.arrival?.baggage??0} checked bag(s)",
        ),
        _buildDetailItem(
          Icons.shopping_bag,
          'Carry-on Baggage',
          '1 carry-on',
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: const Text(
          'Continue to Book',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE8EDF5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.black,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4A739C),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightDetailsSection() {
    return _buildSection(
      '',
      [
        _buildDetailItem(
          Icons.language,
          flight.airline?.name ?? 'Unknown Airline',
          'Flight Number: ${flight.flight?.number ?? flight.flight?.iata ?? 'N/A'}',
        ),
        _buildDetailItem(
          Icons.flight,
          'Aircraft Type',
          flight.aircraft?.iata ?? flight.aircraft?.icao ?? 'Unknown',
        ),
      ],
    );
  }

  Widget _buildFlightInformationSection() {
    return _buildSection(
      'Flight Information',
      [
        _buildDetailItem(
          Icons.airline_seat_recline_normal,
          'Seat Class',
          'Economy',
        ),
        _buildDetailItem(
          Icons.access_time,
          'Total Duration',
          FlightUtils.calculateDuration(flight),
        ),
        _buildDetailItem(
          Icons.location_on,
          'Layovers and Stops',
          FlightUtils.getStopInfo(flight),
        ),
      ],
    );
  }

  Widget _buildMapSection() {
    final latitude = flight.live?.latitude;
    final longitude = flight.live?.longitude;
    
    const defaultLat = 40.7128;
    const defaultLng = -74.0060;
    
    final lat = latitude ?? defaultLat;
    final lng = longitude ?? defaultLng;
    
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(lat, lng),
                initialZoom: 10.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.none,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.flight_search_app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(lat, lng),
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.flight,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${flight.departure?.iata ?? 'N/A'} → ${flight.arrival?.iata ?? 'N/A'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  latitude != null && longitude != null 
                      ? 'Live: ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}'
                      : 'Default: ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPoliciesSection() {
    return _buildSection(
      'Policies',
      [
        _buildDetailItem(
          Icons.description,
          'Cancellation Policy',
          '',
        ),
        _buildDetailItem(
          Icons.description,
          'Refund Policy',
          '',
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}
