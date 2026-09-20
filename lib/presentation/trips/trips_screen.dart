import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/image_service/image_service.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/config/dependency_injection.dart';
import '../../domain/repositories/booking/booking_repository.dart';
import '../../domain/repositories/hotel_repository.dart';
import '../../core/services/auth_service.dart';
import 'bloc/trips_bloc.dart';
import 'bloc/trips_event.dart';
import 'bloc/trips_state.dart';
import '../../data/models/booking_model.dart';
import '../../data/models/hotel_model.dart';
import '../../core/config/app_router.dart';
import 'package:intl/intl.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripsBloc(
        bookingRepository: sl<BookingRepository>(),
        hotelRepository: sl<HotelRepository>(),
        authService: sl<AuthService>(),
      )..add(LoadTrips()),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('My Trips', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Upcoming'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
              indicatorColor: AppColors.secondary,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
            ),
          ),
          body: BlocBuilder<TripsBloc, TripsState>(
            builder: (context, state) {
              if (state is TripsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is TripsError) {
                return Center(child: Text(state.message));
              }
              if (state is TripsLoaded) {
                return TabBarView(
                  children: [
                    _buildTripsList(context, state.bookings.where((b) => b.status == 'CONFIRMED' && b.checkIn.isAfter(DateTime.now())).toList(), state.hotels),
                    _buildTripsList(context, state.bookings.where((b) => b.status == 'CONFIRMED' && b.checkIn.isBefore(DateTime.now())).toList(), state.hotels),
                    _buildTripsList(context, state.bookings.where((b) => b.status == 'CANCELLED').toList(), state.hotels),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTripsList(BuildContext context, List<BookingModel> bookings, Map<String, HotelModel> hotels) {
    if (bookings.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        final hotel = hotels[booking.hotelId];
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRouter.bookingDetails, arguments: booking),
          child: _TripCard(booking: booking, hotel: hotel),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("No trips found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text("Book your next stay to see it here!", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final BookingModel booking;
  final HotelModel? hotel;
  const _TripCard({required this.booking, this.hotel});

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd MMM');
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Stack(
            children: [
              ImageService.hotel(
                imageUrl: hotel?.images.first ?? "https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?q=80&w=600",
                height: 140,
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: booking.status == 'CONFIRMED' ? AppColors.success : Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    booking.status,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hotel?.name ?? "Hotel Name", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("Total Price: ₹${booking.totalAmount.toInt()}", style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("DATES", style: TextStyle(fontSize: 10, color: Colors.grey)),
                        Text("${df.format(booking.checkIn)} - ${df.format(booking.checkOut)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text("BOOKING ID", style: TextStyle(fontSize: 10, color: Colors.grey)),
                        Text(
                          booking.id.length >= 8
                              ? booking.id.substring(0, 8).toUpperCase()
                              : booking.id.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (booking.status == 'CONFIRMED' && booking.checkIn.isAfter(DateTime.now()))
                  OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Cancel Booking?'),
                          content: const Text('Are you sure you want to cancel this booking? A refund will be processed as per hotel policy.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('No')),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                context.read<TripsBloc>().add(CancelTrip(booking.id));
                              },
                              child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 44),
                      side: const BorderSide(color: Colors.red),
                      foregroundColor: Colors.red,
                    ),
                    child: const Text("Cancel Booking"),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
