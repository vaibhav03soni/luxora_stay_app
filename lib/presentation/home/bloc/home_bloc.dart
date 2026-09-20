import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/hotel_model.dart';
import '../../../data/models/destination_model.dart';
import '../../../domain/repositories/hotel_repository.dart';
import '../../../core/services/recent_viewed_service.dart';

// Events
abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadHomeData extends HomeEvent {}

// States
abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<HotelModel> featuredHotels;
  final List<DestinationModel> popularDestinations;
  final List<HotelModel> recommendedHotels;
  final List<HotelModel> recentlyViewedHotels;

  HomeLoaded({
    required this.featuredHotels,
    required this.popularDestinations,
    required this.recommendedHotels,
    required this.recentlyViewedHotels,
  });

  @override
  List<Object?> get props => [featuredHotels, popularDestinations, recommendedHotels, recentlyViewedHotels];
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HotelRepository hotelRepository;

  HomeBloc({required this.hotelRepository}) : super(HomeInitial()) {
    on<LoadHomeData>((event, emit) async {
      emit(HomeLoading());
      try {
        final featured = await hotelRepository.getFeaturedHotels();
        final destinations = await hotelRepository.getPopularDestinations();
        final recommended = await hotelRepository.getHotels();

        // Load recently viewed
        final recentIds = await RecentViewedService.getRecentHotels();
        final List<HotelModel> recentHotels = [];
        for (final id in recentIds) {
          final hotel = await hotelRepository.getHotelById(id);
          if (hotel != null) recentHotels.add(hotel);
        }

        emit(HomeLoaded(
          featuredHotels: featured,
          popularDestinations: destinations,
          recommendedHotels: recommended.take(10).toList(),
          recentlyViewedHotels: recentHotels,
        ));
      } catch (e) {
        emit(HomeError('Failed to load home data: \${e.toString()}'));
      }
    });
  }
}
