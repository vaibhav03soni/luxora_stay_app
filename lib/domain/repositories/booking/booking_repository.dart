import '../../../data/models/booking_model.dart';

abstract class BookingRepository {
  Future<String> createBooking(BookingModel booking);
  Future<List<BookingModel>> getBookings(String userId);
  Future<void> cancelBooking(String bookingId);
}
