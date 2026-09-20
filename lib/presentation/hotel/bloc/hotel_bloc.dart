import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/services/recent_viewed_service.dart';
import '../../../data/models/hotel_model.dart';
import '../../../domain/repositories/hotel_repository.dart';

// Events
abstract class HotelEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadHotelDetails extends HotelEvent {
  final String id;
  LoadHotelDetails(this.id);
  @override
  List<Object?> get props => [id];
}

// States
abstract class HotelState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HotelInitial extends HotelState {}

class HotelLoading extends HotelState {}

class HotelLoaded extends HotelState {
  final HotelModel hotel;
  HotelLoaded(this.hotel);
  @override
  List<Object?> get props => [hotel];
}

class HotelError extends HotelState {
  final String message;
  HotelError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class HotelBloc extends Bloc<HotelEvent, HotelState> {
  final HotelRepository hotelRepository;

  HotelBloc({required this.hotelRepository}) : super(HotelInitial()) {
    on<LoadHotelDetails>((event, emit) async {
      emit(HotelLoading());
      try {
        final hotel = await hotelRepository.getHotelById(event.id);
        if (hotel != null) {
          await RecentViewedService.addHotel(event.id);
          emit(HotelLoaded(hotel));
        } else {
          emit(HotelError('Hotel not found.'));
        }
      } catch (e) {
        emit(HotelError(e.toString()));
      }
    });
  }
}
