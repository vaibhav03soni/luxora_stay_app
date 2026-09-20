import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/hotel_model.dart';
import '../../../domain/repositories/wishlist_repository.dart';

// Events
abstract class WishlistEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadWishlist extends WishlistEvent {}

class ToggleWishlist extends WishlistEvent {
  final HotelModel hotel;
  ToggleWishlist(this.hotel);
  @override
  List<Object?> get props => [hotel];
}

// States
abstract class WishlistState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<HotelModel> hotels;
  WishlistLoaded(this.hotels);
  @override
  List<Object?> get props => [hotels];
}

// Bloc
class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository wishlistRepository;

  WishlistBloc({required this.wishlistRepository}) : super(WishlistInitial()) {
    on<LoadWishlist>((event, emit) async {
      emit(WishlistLoading());
      final hotels = await wishlistRepository.getWishlist();
      emit(WishlistLoaded(List.from(hotels)));
    });

    on<ToggleWishlist>((event, emit) async {
      final isInWishlist = await wishlistRepository.isInWishlist(event.hotel.id);
      if (isInWishlist) {
        await wishlistRepository.removeFromWishlist(event.hotel.id);
      } else {
        await wishlistRepository.addToWishlist(event.hotel);
      }
      add(LoadWishlist());
    });
  }
}
