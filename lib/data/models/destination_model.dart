class DestinationModel {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final int hotelCount;

  DestinationModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.description = '',
    this.hotelCount = 0,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      description: json['description'] ?? '',
      hotelCount: json['hotelCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'hotelCount': hotelCount,
    };
  }
}
