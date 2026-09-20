class ReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String userImageUrl;
  final double rating;
  final String comment;
  final DateTime date;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImageUrl,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userImageUrl: json['userImageUrl'],
      rating: json['rating'].toDouble(),
      comment: json['comment'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userImageUrl': userImageUrl,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }
}
