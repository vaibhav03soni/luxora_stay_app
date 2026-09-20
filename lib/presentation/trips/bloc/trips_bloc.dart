import 'package:flutter_bloc/flutter_bloc.dart';
import 'trips_event.dart';
import 'trips_state.dart';
import '../../../domain/repositories/booking/booking_repository.dart';
import '../../../domain/repositories/hotel_repository.dart';
import '../../../core/services/auth_service.dart';
import '../../../data/models/hotel_model.dart';

class TripsBloc extends Bloc<TripsEvent, TripsState> {
  final BookingRepository bookingRepository;
  final HotelRepository hotelRepository;
  final AuthService authService;

  TripsBloc({
    required this.bookingRepository,
    required this.hotelRepository,
    required this.authService,
  }) : super(TripsInitial()) {
    on<LoadTrips>(_onLoadTrips);
    on<CancelTrip>(_onCancelTrip);
  }

  Future<void> _onLoadTrips(LoadTrips event, Emitter<TripsState> emit) async {
    emit(TripsLoading());
    try {
      final user = authService.currentUser;
      if (user == null) {
        emit(const TripsError("User not logged in"));
        return;
      }

      final bookings = await bookingRepository.getBookings(user.uid);

      final Map<String, HotelModel> hotelsMap = {};
      for (var booking in bookings) {
        if (!hotelsMap.containsKey(booking.hotelId)) {
          final hotel = await hotelRepository.getHotelById(booking.hotelId);
          if (hotel != null) {
            hotelsMap[booking.hotelId] = hotel;
          }
        }
      }

      emit(TripsLoaded(
        bookings: bookings,
        hotels: hotelsMap,
      ));
    } catch (e) {
      emit(TripsError(e.toString()));
    }
  }

  Future<void> _onCancelTrip(CancelTrip event, Emitter<TripsState> emit) async {
    try {
      await bookingRepository.cancelBooking(event.bookingId);
      add(LoadTrips());
    } catch (e) {
      emit(TripsError(e.toString()));
    }
  }
}
