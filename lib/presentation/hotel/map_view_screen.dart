import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../data/models/hotel_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/config/app_router.dart';

class MapViewScreen extends StatefulWidget {
  final List<HotelModel> hotels;
  final LatLng? initialPosition;

  const MapViewScreen({super.key, required this.hotels, this.initialPosition});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  void _createMarkers() {
    for (var hotel in widget.hotels) {
      _markers.add(
        Marker(
          markerId: MarkerId(hotel.id),
          position: LatLng(hotel.latitude, hotel.longitude),
          infoWindow: InfoWindow(
            title: hotel.name,
            snippet: '₹\${hotel.lowestPrice.toInt()}/night',
            onTap: () {
              Navigator.pushNamed(context, AppRouter.hotelDetails, arguments: hotel.id);
            },
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore on Map'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.initialPosition ??
              (widget.hotels.isNotEmpty
                  ? LatLng(widget.hotels.first.latitude, widget.hotels.first.longitude)
                  : const LatLng(20.5937, 78.9629)), // India center
          zoom: 12,
        ),
        onMapCreated: (controller) {},
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
