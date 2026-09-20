import '../../domain/repositories/hotel_repository.dart';
import '../models/hotel_model.dart';
import '../models/destination_model.dart';
import '../mock/mock_data.dart';
import '../../core/config/app_config.dart';
import '../../core/services/firestore/firestore_service.dart';
import '../../core/constants/enums.dart';
import 'package:flutter/foundation.dart';

class HotelRepositoryImpl implements HotelRepository {
  final FirestoreService _firestoreService;

  HotelRepositoryImpl({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  @override
  Future<List<HotelModel>> getHotels({
    String? city,
    String? destinationId,
    double? minPrice,
    double? maxPrice,
    int? starRating,
    PropertyType? propertyType,
    List<AmenityType>? amenities,
  }) async {
    if (AppConfig.isMock) {
      return _getMockHotels(city, destinationId, minPrice, maxPrice, starRating, propertyType, amenities);
    }

    try {
      final List<HotelModel> hotels = await _firestoreService.streamCollection<HotelModel>(
        path: 'hotels',
        builder: (data, id) => HotelModel.fromJson({...data, 'id': id}),
        queryBuilder: (query) {
          if (city != null) {
            query = query.where('city', isEqualTo: city);
          }
          if (destinationId != null) {
            query = query.where('destinationId', isEqualTo: destinationId);
          }
          if (starRating != null) {
            query = query.where('starRating', isEqualTo: starRating);
          }
          if (propertyType != null) {
            query = query.where('propertyType', isEqualTo: propertyType.name);
          }
          return query;
        },
      ).first;

      var filteredHotels = List<HotelModel>.from(hotels);
      if (minPrice != null) {
        filteredHotels = filteredHotels.where((h) => h.lowestPrice >= minPrice).toList();
      }
      if (maxPrice != null) {
        filteredHotels = filteredHotels.where((h) => h.lowestPrice <= maxPrice).toList();
      }
      if (amenities != null && amenities.isNotEmpty) {
        filteredHotels = filteredHotels.where((h) {
          final hotelAmenityNames = h.amenities.map((a) => a.toLowerCase().replaceAll(' ', '')).toList();
          return amenities.every((a) => hotelAmenityNames.contains(a.name.toLowerCase()));
        }).toList();
      }

      if (filteredHotels.isEmpty && !AppConfig.isReal) {
        return _getMockHotels(city, destinationId, minPrice, maxPrice, starRating, propertyType, amenities);
      }
      return filteredHotels;
    } catch (e) {
      debugPrint('Error fetching real hotels: $e');
      return _getMockHotels(city, destinationId, minPrice, maxPrice, starRating, propertyType, amenities);
    }
  }

  List<HotelModel> _getMockHotels(
    String? city,
    String? destinationId,
    double? minPrice,
    double? maxPrice,
    int? starRating,
    PropertyType? propertyType,
    List<AmenityType>? amenities,
  ) {
    var hotels = MockData.hotels;

    if (city != null) {
      hotels = hotels.where((h) => h.city.toLowerCase().contains(city.toLowerCase()) || h.name.toLowerCase().contains(city.toLowerCase())).toList();
    }
    if (destinationId != null) {
      hotels = hotels.where((h) => h.destinationId == destinationId).toList();
    }
    if (starRating != null) {
      hotels = hotels.where((h) => h.starRating == starRating).toList();
    }
    if (propertyType != null) {
      hotels = hotels.where((h) {
        final typeName = propertyType.name.toLowerCase();
        // Categorize hotels based on ID or Name for mock filtering
        if (typeName == 'hotel') return h.name.contains('Grand') || h.name.contains('Oberoi');
        if (typeName == 'resort') return h.name.contains('Taj') || h.name.contains('Resort');
        if (typeName == 'villa') return h.id.contains('h3') || h.id.contains('h7');
        return true;
      }).toList();
    }

    if (minPrice != null) {
      hotels = hotels.where((h) => h.lowestPrice >= minPrice).toList();
    }
    if (maxPrice != null) {
      hotels = hotels.where((h) => h.lowestPrice <= maxPrice).toList();
    }
    if (amenities != null && amenities.isNotEmpty) {
      hotels = hotels.where((h) {
        final hotelAmenityNames = h.amenities.map((a) => a.toLowerCase().replaceAll(' ', '')).toList();
        return amenities.every((a) => hotelAmenityNames.contains(a.name.toLowerCase()));
      }).toList();
    }

    return hotels;
  }

  @override
  Future<HotelModel?> getHotelById(String id) async {
    if (AppConfig.isMock) {
      return MockData.hotels.firstWhere((h) => h.id == id);
    }

    try {
      final hotel = await _firestoreService.getDocument<HotelModel>(
        path: 'hotels/$id',
        builder: (data, docId) => HotelModel.fromJson({...data, 'id': docId}),
      );
      return hotel ?? MockData.hotels.firstWhere((h) => h.id == id);
    } catch (e) {
      debugPrint('Error fetching hotel by id: $e');
      return MockData.hotels.firstWhere((h) => h.id == id);
    }
  }

  @override
  Future<List<DestinationModel>> getPopularDestinations() async {
    if (AppConfig.isMock) {
      return MockData.destinations;
    }

    try {
      final destinations = await _firestoreService.streamCollection<DestinationModel>(
        path: 'destinations',
        builder: (data, id) => DestinationModel.fromJson({...data, 'id': id}),
      ).first;

      if (destinations.isEmpty) {
        return MockData.destinations;
      }
      return destinations;
    } catch (e) {
      debugPrint('Error fetching destinations: $e');
      return MockData.destinations;
    }
  }

  @override
  Future<List<HotelModel>> getFeaturedHotels() async {
    final hotels = await getHotels();
    return hotels.where((h) => h.isFeatured).toList();
  }
}
