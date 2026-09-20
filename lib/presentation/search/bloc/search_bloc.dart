import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/hotel_model.dart';
import '../../../domain/repositories/hotel_repository.dart';
import '../../../core/constants/enums.dart';

// Events
abstract class SearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchHotels extends SearchEvent {
  final String? query;
  final String? destinationId;
  final int? starRating;
  final double? minPrice;
  final double? maxPrice;
  final String? sortBy;
  final PropertyType? propertyType;
  final List<AmenityType>? amenities;

  SearchHotels({
    this.query,
    this.destinationId,
    this.starRating,
    this.minPrice,
    this.maxPrice,
    this.sortBy,
    this.propertyType,
    this.amenities,
  });

  @override
  List<Object?> get props => [query, destinationId, starRating, minPrice, maxPrice, sortBy, propertyType, amenities];
}

class SearchSuggestionsRequested extends SearchEvent {
  final String query;
  SearchSuggestionsRequested(this.query);
  @override
  List<Object?> get props => [query];
}

// States
abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchResults extends SearchState {
  final List<HotelModel> hotels;
  SearchResults(this.hotels);

  @override
  List<Object?> get props => [hotels];
}

class SearchSuggestionsLoaded extends SearchState {
  final List<String> suggestions;
  SearchSuggestionsLoaded(this.suggestions);
  @override
  List<Object?> get props => [suggestions];
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final HotelRepository hotelRepository;

  SearchBloc({required this.hotelRepository}) : super(SearchInitial()) {
    on<SearchHotels>((event, emit) async {
      emit(SearchLoading());
      try {
        var results = await hotelRepository.getHotels(
          city: event.query,
          destinationId: event.destinationId,
          starRating: event.starRating,
          minPrice: event.minPrice,
          maxPrice: event.maxPrice,
          propertyType: event.propertyType,
          amenities: event.amenities,
        );

        if (event.sortBy != null) {
          results = List<HotelModel>.from(results);
          if (event.sortBy == 'price_low_to_high') {
            results.sort((a, b) => a.lowestPrice.compareTo(b.lowestPrice));
          } else if (event.sortBy == 'price_high_to_low') {
            results.sort((a, b) => b.lowestPrice.compareTo(a.lowestPrice));
          } else if (event.sortBy == 'rating') {
            results.sort((a, b) => b.rating.compareTo(a.rating));
          }
        }

        emit(SearchResults(results));
      } catch (e) {
        emit(SearchError('Search failed: \${e.toString()}'));
      }
    });

    on<SearchSuggestionsRequested>((event, emit) async {
      if (event.query.isEmpty) {
        emit(SearchInitial());
        return;
      }
      try {
        final hotels = await hotelRepository.getHotels(city: event.query);
        final destinations = await hotelRepository.getPopularDestinations();

        final suggestions = <String>{};
        for (var h in hotels) {
          if (h.name.toLowerCase().contains(event.query.toLowerCase())) suggestions.add(h.name);
          if (h.city.toLowerCase().contains(event.query.toLowerCase())) suggestions.add(h.city);
        }
        for (var d in destinations) {
          if (d.name.toLowerCase().contains(event.query.toLowerCase())) suggestions.add(d.name);
        }

        emit(SearchSuggestionsLoaded(suggestions.take(5).toList()));
      } catch (_) {
        // Silent fail for suggestions
      }
    });
  }
}
