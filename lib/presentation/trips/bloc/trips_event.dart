import 'package:equatable/equatable.dart';

abstract class TripsEvent extends Equatable {
  const TripsEvent();

  @override
  List<Object> get props => [];
}

class LoadTrips extends TripsEvent {}

class CancelTrip extends TripsEvent {
  final String bookingId;
  const CancelTrip(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}
