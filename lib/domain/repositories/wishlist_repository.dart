import '../../data/models/hotel_model.dart';

abstract class WishlistRepository {
  Future<List<HotelModel>> getWishlist();
  Future<void> addToWishlist(HotelModel hotel);
  Future<void> removeFromWishlist(String hotelId);
  Future<bool> isInWishlist(String hotelId);
}
