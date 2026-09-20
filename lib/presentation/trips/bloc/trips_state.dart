import 'package:equatable/equatable.dart';
import '../../../data/models/booking_model.dart';
import '../../../data/models/hotel_model.dart';

abstract class TripsState extends Equatable {
  const TripsState();

  @override
  List<Object> get props => [];
}

class TripsInitial extends TripsState {}

class TripsLoading extends TripsState {}

class TripsLoaded extends TripsState {
  final List<BookingModel> bookings;
  final Map<String, HotelModel> hotels;

  const TripsLoaded({required this.bookings, required this.hotels});

  @override
  List<Object> get props => [bookings, hotels];
}

class TripsError extends TripsState {
  final String message;
  const TripsError(this.message);

  @override
  List<Object> get props => [message];
}
