import 'package:flutter/material.dart';
import '../../core/constants/enums.dart';

class AmenityModel {
  final String id;
  final String name;
  final IconData icon;
  final AmenityType type;

  AmenityModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
  });

  factory AmenityModel.fromType(AmenityType type) {
    switch (type) {
      case AmenityType.wifi:
        return AmenityModel(id: 'wifi', name: 'Free Wi-Fi', icon: Icons.wifi, type: type);
      case AmenityType.pool:
        return AmenityModel(id: 'pool', name: 'Swimming Pool', icon: Icons.pool, type: type);
      case AmenityType.gym:
        return AmenityModel(id: 'gym', name: 'Fitness Center', icon: Icons.fitness_center, type: type);
      case AmenityType.restaurant:
        return AmenityModel(id: 'restaurant', name: 'Restaurant', icon: Icons.restaurant, type: type);
      case AmenityType.spa:
        return AmenityModel(id: 'spa', name: 'Spa & Wellness', icon: Icons.spa, type: type);
      case AmenityType.parking:
        return AmenityModel(id: 'parking', name: 'Free Parking', icon: Icons.local_parking, type: type);
      case AmenityType.ac:
        return AmenityModel(id: 'ac', name: 'Air Conditioning', icon: Icons.ac_unit, type: type);
      case AmenityType.breakfast:
        return AmenityModel(id: 'breakfast', name: 'Breakfast Included', icon: Icons.free_breakfast, type: type);
    }
  }
}
