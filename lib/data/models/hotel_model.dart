import 'room_model.dart';
import 'review_model.dart';

class HotelModel {
  final String id;
  final String name;
  final String description;
  final String address;
  final String city;
  final String destinationId;
  final double rating;
  final int reviewCount;
  final int starRating;
  final List<String> images;
  final List<String> amenities;
  final List<RoomModel> rooms;
  final List<ReviewModel> reviews;
  final double latitude;
  final double longitude;
  final bool isFeatured;

  HotelModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.city,
    required this.destinationId,
    required this.rating,
    required this.reviewCount,
    required this.starRating,
    required this.images,
    required this.amenities,
    required this.rooms,
    required this.reviews,
    required this.latitude,
    required this.longitude,
    this.isFeatured = false,
  });

  double get lowestPrice {
    if (rooms.isEmpty) return 0;
    return rooms.map((r) => r.pricePerNight).reduce((a, b) => a < b ? a : b);
  }

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      city: json['city'],
      destinationId: json['destinationId'],
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
      starRating: json['starRating'],
      images: List<String>.from(json['images']),
      amenities: List<String>.from(json['amenities']),
      rooms: (json['rooms'] as List).map((r) => RoomModel.fromJson(r)).toList(),
      reviews: json['reviews'] != null ? (json['reviews'] as List).map((r) => ReviewModel.fromJson(r)).toList() : [],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      isFeatured: json['isFeatured'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'city': city,
      'destinationId': destinationId,
      'rating': rating,
      'reviewCount': reviewCount,
      'starRating': starRating,
      'images': images,
      'amenities': amenities,
      'rooms': rooms.map((r) => r.toJson()).toList(),
      'reviews': reviews.map((r) => r.toJson()).toList(),
      'latitude': latitude,
      'longitude': longitude,
      'isFeatured': isFeatured,
    };
  }
}
