class RoomModel {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final double pricePerNight;
  final int maxOccupancy;
  final String bedType;
  final double roomSize; // in sq ft
  final List<String> amenities;
  final bool isAvailable;

  RoomModel({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.pricePerNight,
    required this.maxOccupancy,
    required this.bedType,
    required this.roomSize,
    required this.amenities,
    this.isAvailable = true,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      images: List<String>.from(json['images']),
      pricePerNight: json['pricePerNight'].toDouble(),
      maxOccupancy: json['maxOccupancy'],
      bedType: json['bedType'],
      roomSize: json['roomSize'].toDouble(),
      amenities: List<String>.from(json['amenities']),
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'images': images,
      'pricePerNight': pricePerNight,
      'maxOccupancy': maxOccupancy,
      'bedType': bedType,
      'roomSize': roomSize,
      'amenities': amenities,
      'isAvailable': isAvailable,
    };
  }
}
