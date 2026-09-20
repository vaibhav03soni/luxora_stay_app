import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/booking_model.dart';
import '../../data/models/hotel_model.dart';
import '../../domain/repositories/hotel_repository.dart';
import '../../core/config/dependency_injection.dart';
import '../../core/services/image_service/image_service.dart';

class BookingDetailsScreen extends StatelessWidget {
  final BookingModel booking;
  const BookingDetailsScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
        ],
      ),
      body: FutureBuilder<HotelModel?>(
        future: sl<HotelRepository>().getHotelById(booking.hotelId),
        builder: (context, snapshot) {
          final hotel = snapshot.data;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hotel != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ImageService.hotel(imageUrl: hotel.images.first, height: 200),
                  ),
                  const SizedBox(height: 16),
                  Text(hotel.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(hotel.address, style: const TextStyle(color: Colors.grey)),
                  const Divider(height: 48),
                ],
                _buildStatusBadge(),
                const SizedBox(height: 24),
                Text('Booking ID: ${booking.id.toUpperCase()}', style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                _buildSection('Stay Information'),
                _buildInfoRow('Check-in', DateFormat('EEE, MMM dd, yyyy').format(booking.checkIn)),
                _buildInfoRow('Check-out', DateFormat('EEE, MMM dd, yyyy').format(booking.checkOut)),
                _buildInfoRow('Nights', '${booking.checkOut.difference(booking.checkIn).inDays}'),
                _buildInfoRow('Guests', '${booking.guests} Guests'),
                const Divider(height: 40),
                _buildSection('Payment Information'),
                _buildInfoRow('Transaction ID', booking.transactionId.toUpperCase()),
                _buildInfoRow('Total Amount', '₹${booking.totalAmount.toInt()}', isTotal: true),
                const SizedBox(height: 40),
                if (booking.status == 'CONFIRMED' && booking.checkIn.isAfter(DateTime.now()))
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contacting hotel...')));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary, foregroundColor: AppColors.primary),
                    child: const Text('Contact Hotel'),
                  ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back to Trips'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: booking.status == 'CONFIRMED' ? AppColors.success : Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        booking.status,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isTotal ? 18 : 14, color: isTotal ? Colors.black : Colors.grey)),
          Text(value, style: TextStyle(fontSize: isTotal ? 18 : 14, fontWeight: FontWeight.bold, color: isTotal ? AppColors.primary : Colors.black)),
        ],
      ),
    );
  }
}
