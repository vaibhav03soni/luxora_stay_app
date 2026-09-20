import '../../data/models/hotel_model.dart';
import '../../data/models/destination_model.dart';
import '../../core/constants/enums.dart';

abstract class HotelRepository {
  Future<List<HotelModel>> getHotels({
    String? city,
    String? destinationId,
    double? minPrice,
    double? maxPrice,
    int? starRating,
    PropertyType? propertyType,
    List<AmenityType>? amenities,
  });

  Future<HotelModel?> getHotelById(String id);

  Future<List<DestinationModel>> getPopularDestinations();

  Future<List<HotelModel>> getFeaturedHotels();
}
