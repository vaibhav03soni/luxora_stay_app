import '../../../domain/repositories/booking/booking_repository.dart';
import '../../models/booking_model.dart';
import '../../../core/services/firestore/firestore_service.dart';
import '../../../core/config/app_config.dart';

class BookingRepositoryImpl implements BookingRepository {
  final FirestoreService _firestoreService;
  static final List<BookingModel> _mockBookings = [];

  BookingRepositoryImpl({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  @override
  Future<String> createBooking(BookingModel booking) async {
    if (AppConfig.isMock) {
      final id = 'mock_booking_${DateTime.now().millisecondsSinceEpoch}';
      final newBooking = BookingModel(
        id: id,
        hotelId: booking.hotelId,
        roomId: booking.roomId,
        userId: booking.userId,
        checkIn: booking.checkIn,
        checkOut: booking.checkOut,
        guests: booking.guests,
        totalAmount: booking.totalAmount,
        status: booking.status,
        transactionId: booking.transactionId,
        createdAt: booking.createdAt,
      );
      _mockBookings.add(newBooking);
      return id;
    }
    final ref = await _firestoreService.addData(
      path: 'bookings',
      data: booking.toJson(),
    );
    return ref?.id ?? '';
  }

  @override
  Future<List<BookingModel>> getBookings(String userId) async {
    if (AppConfig.isMock) {
      final filtered = _mockBookings.where((b) => b.userId == userId).toList();
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return filtered;
    }
    final List<BookingModel> bookings = await _firestoreService.streamCollection<BookingModel>(
      path: 'bookings',
      builder: (data, id) => BookingModel.fromJson({...data, 'id': id}),
      queryBuilder: (query) => query.where('userId', isEqualTo: userId).orderBy('createdAt', descending: true),
    ).first;
    return bookings;
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    if (AppConfig.isMock) {
      final index = _mockBookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        final b = _mockBookings[index];
        _mockBookings[index] = BookingModel(
          id: b.id,
          hotelId: b.hotelId,
          roomId: b.roomId,
          userId: b.userId,
          checkIn: b.checkIn,
          checkOut: b.checkOut,
          guests: b.guests,
          totalAmount: b.totalAmount,
          status: 'CANCELLED',
          transactionId: b.transactionId,
          createdAt: b.createdAt,
        );
      }
      return;
    }
    await _firestoreService.setData(
      path: 'bookings/$bookingId',
      data: {'status': 'CANCELLED'},
    );
  }
}
